 1 # Description:
 2 #   Tells the weather
 3 #
 4 # Configuration:
 5 #   HUBOT_WEATHER_API_URL - Optional openweathermap.org API endpoint to use
 6 #   HUBOT_WEATHER_UNITS - Temperature units to use. 'metric' or 'imperial'
 7 #
 8 # Commands:
 9 #   weather in <location> - Tells about the weather in given location
10 #
11 # Author:
12 #   spajus
13 
14 process.env.HUBOT_WEATHER_API_URL ||=
15   'http://api.openweathermap.org/data/2.5/weather'
16 process.env.HUBOT_WEATHER_UNITS ||= 'imperial'
17 
18 module.exports = (robot) ->
19   robot.hear /weather in (\w+)/i, (msg) ->
20     city = msg.match[1]
21     query = { units: process.env.HUBOT_WEATHER_UNITS, q: city }
22     url = process.env.HUBOT_WEATHER_API_URL
23     msg.robot.http(url).query(query).get() (err, res, body) ->
24       data = JSON.parse(body)
25       weather = [ "#{Math.round(data.main.temp)} degrees" ]
26       for w in data.weather
27         weather.push w.description
28       msg.reply "It's #{weather.join(', ')} in #{data.name}, #{data.sys.count\
29 ry}"