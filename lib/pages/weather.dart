import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/weather_models.dart';
import '../services/weather_services.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  final _weatherService = WeatherService('4f6af137873981bb45889bf0d3c913a7');
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
}
