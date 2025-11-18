import 'package:flutter/material.dart';
import 'package:flutter_weather/models/weather_model.dart';
import 'package:flutter_weather/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService("<YOUR_API_KEY>");
  Weather? _weather;

  getWeather() async {
    String city = await weatherService.getCurrentCity();

    try {
      final weather = await weatherService.fetchWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  getCondition(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud. json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder-json';
      case 'clear':
        return 'assets/sunny-json';
      default:
        return 'assets/cloud.json';
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(_weather?.cityName ?? 'Loading city...', style: TextStyle(fontSize: 20),),

            // Animation
            Lottie.asset(
              getCondition(_weather?.mainCondition ?? ""),
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),

            // Temperature
            Text("${_weather?.temperature.round()} ํC", style: TextStyle(fontSize: 80),),

            // Main Condition
            Text(_weather?.mainCondition ?? 'Loading condition...'),
          ] ,
        ),
      ),
    );
  }
}