import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';

import '../services/weather_services.dart';

class ShowWeather extends StatefulWidget {
  const ShowWeather({super.key});

  @override
  State<ShowWeather> createState() => _ShowWeatherState();
}

class _ShowWeatherState extends State<ShowWeather> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeatherForCurrentLocation();
  }

  Future<void> _fetchWeatherForCurrentLocation() async {
    try {
      var status = await Permission.location.request();

      if (status == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

        // Debug by printing the retrieved city name:
        String areaName = placemarks.first.administrativeArea ?? "Unknown";
        areaName = areaName.replaceAll(" County", "");
        print("Retrieved city name: $areaName");


        final weather = await _wf.currentWeatherByCityName(areaName);
        if (weather != null) {
          setState(() {
            _weather = weather;
          });
        } else {
          // Handle the case where weather information is not available
          print("Weather information not available for $areaName");
          // You may display a message to the user or default to a specific city
        }
      } else {
        // Handle if location permission is not granted
      }
    } catch (e) {
      print('Error fetching weather: $e');
      // Handle the error gracefully, e.g., show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Weather",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "Literata",
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.00),
          _dateTimeInfo(),
          SizedBox(height: 10),
          _weatherIcon(),
          SizedBox(height: 10),
          _currentTemperature(),
          const SizedBox(height: 10),
          _extraInfo(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.00),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 22,
        fontFamily: "Georgia",
          fontWeight: FontWeight.bold,

      ),
    );
  }



  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              " ${DateFormat("d.m.y").format(now)}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",

              ),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Widget _currentTemperature() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}˚ C",
      style: const TextStyle(
        fontSize: 24,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}˚ C",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}˚ C",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}














/*class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    try {
      var status = await Permission.location.request();

      if (status == PermissionStatus.granted) {
        // Location permission granted
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String cityName = placemarks.first.locality ?? "Unknown";

        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      } else {
        
      }
    } catch (e) {
      print('Error fetching weather: $e');
      // Handle the error gracefully, e.g., show a message to the user
    }
  }

  // Weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'lib/lotties/sunny.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'lib/lotties/cloudy.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'lib/lotties/rain.json';

      case 'thunderstorm':
        return 'lib/lotties/thunder.json';

      case 'clear':
        return 'lib/lotties/sunny.json';

      default:
        return 'lib/lotties/sunny.json';
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();
    // Fetch data on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading city..."),

            // Weather animation
            Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition),
            ),

            // Temperature
            Text("${_weather?.temperature.round()}°C"),

            // Weather condition
            Text(_weather?.mainCondition ?? ""),



          ],
        ),
      ),
    );
  }
}*/
