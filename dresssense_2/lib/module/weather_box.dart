import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class WeatherBox extends StatefulWidget {
  const WeatherBox({super.key});

  @override
  State<WeatherBox> createState() => _WeatherBoxState();
}

class _WeatherBoxState extends State<WeatherBox> {
  String weatherCondition = "Loading...";
  int _currentIndex = 0;

  final List<String> _clothes = [
    'assets/icons/baju-2.png',
    'assets/icons/baju-1.png',
    'assets/icons/baju-4.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          weatherCondition = "Location disabled";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            weatherCondition = "Permission denied";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          weatherCondition = "Permission denied forever";
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final double lat = position.latitude;
      final double lon = position.longitude;


      final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conditionRaw = data['weather'][0]['main'];

        final condition = conditionRaw.toString().toLowerCase();

        setState(() {
          if (condition.contains("rain")) {
            weatherCondition = "Rainy";
          } else if (condition.contains("clear")) {
            weatherCondition = "Sunny";
          } else if (condition.contains("cloud")) {
            weatherCondition = "Cloudy";
          } else if (condition.contains("mist") || condition.contains("fog")) {
            weatherCondition = "Misty";
          } else if (condition.contains("haze")) {
            weatherCondition = "Hazy";
          } else if (condition.contains("thunder")) {
            weatherCondition = "Stormy";
          } else {
            weatherCondition = "Windy";
          }
        });
      } else {
        setState(() {
          weatherCondition = "Unknown";
        });
      }
    } catch (e) {
      setState(() {
        weatherCondition = "Error";
      });
    }
  }

  void _nextClothes() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _clothes.length;
    });
  }

  void _prevClothes() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _clothes.length) % _clothes.length;
    });
  }

  String getWeatherIconPath() {
    switch (weatherCondition.toLowerCase()) {
      case "sunny":
        return 'assets/icons/weather/sunny.png';
      case "rainy":
        return 'assets/icons/weather/rainy.png';
      case "cloudy":
        return 'assets/icons/weather/cloud.png';
      case "misty":
        return 'assets/icons/weather/cloud.png';
      case "hazy":
        return 'assets/icons/weather/cloud.png';
      case "stormy":
        return 'assets/icons/weather/rainy.png';
      default:
        return 'assets/icons/weather/angin.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 212,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(getWeatherIconPath(), width: 30),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.kalnia(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "It’s a little "),
                      TextSpan(
                        text: weatherCondition,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " today."),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Here’s some clothes\nyou may consider:",
                  style: GoogleFonts.kalnia(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Kanan: Box pakaian
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          _nextClothes();
                        } else if (details.primaryVelocity! > 0) {
                          _prevClothes();
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset(
                          _clothes[_currentIndex],
                          key: ValueKey(_clothes[_currentIndex]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _clothes.length,
                          (dotIndex) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == dotIndex
                              ? Colors.black
                              : Colors.black26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
