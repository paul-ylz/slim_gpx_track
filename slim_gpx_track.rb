#!/usr/bin/env ruby
require 'nokogiri'

# Takes a .gpx file, and builds a new, lighter-weight gpx from it. All trkpts
# are consolidated into a single segment, and data other than longitude,
# latitude and elevation is stripped. (No time, heartrate, temperature etc).

class SlimGpxTrack

  def initialize(file)
    File.open(file) { |f| @doc = Nokogiri::XML(f) }
  end

  def trkpts
    @doc.xpath("//xmlns:trkpt")
  end

  def gpx_attributes
    {
      "xsi:schemaLocation" => "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd",
      "xmlns"              => "http://www.topografix.com/GPX/1/1",
      "xmlns:gpxtpx"       => "http://www.garmin.com/xmlschemas/TrackPointExtension/v1",
      "xmlns:gpxx"         => "http://www.garmin.com/xmlschemas/GpxExtensions/v3",
      "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
      "version"            => "1.0",
      "creator"            => "CNX Biker"
    }
  end

  def gpx_metadata
    {
      "creator" => "CNX Biker",
      "url"     => "http://cnxbiker.herokuapp.com/"
    }
  end

  def create(new_file_name)
    slim_gpx = build(new_file_name)
    File.open(new_file_name, 'w+') do |f|
      f.puts slim_gpx.to_xml
    end
  end

  def build(name)
    Nokogiri::XML::Builder.new do |x|
      x.gpx(gpx_attributes) {
        x.metadata {
          x.link({ href: gpx_metadata['url'] }) {
            x.text gpx_metadata['creator']
          }
        }
        x.trk {
          x.name name
          x.trkseg {
            trkpts.each do |pt|
              x.trkpt lon: pt['lon'], lat: pt['lat'] {
                x.ele elevation_from(pt)
              }
            end
          }
        }
      }
    end
  end

  def elevation_from(trkpt)
    trkpt.children.each do |child|
      return child.content if child.name == 'ele'
    end
  end
end

slim = SlimGpxTrack.new ARGV[0]
slim.create('output.gpx')