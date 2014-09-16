# Slim GPX File
## Takes the fat out of uploaded .gpx files

A little utility built for a .gpx sharing application I'm building. Generally, 
.gpx files uploaded from a device such as a Garmin include a data that is 
redundant for general route sharing, and creates bloated files. 

This utility builds a lightweight .gpx track including only longitude, latitude 
and elevation data. Extras such as time, temperature, heartrate, cadence etc are 
left out.

## Dependencies:
- [Nokogiri](http://nokogiri.org/)
