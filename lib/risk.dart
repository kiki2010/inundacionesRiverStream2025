// risk.dart

// リスク画面 / Risk screen
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:statistics/statistics.dart';
import 'package:intl/intl.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:weather_icons/weather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';

//Api key
final String apiKey = "";

// リスク画面用ウィジェット / Widget for risk screen
class RiskScreen extends StatefulWidget {
  List<Map<String, dynamic>> selectedRivers;
  
  RiskScreen({
    required this.selectedRivers,
    super.key
  });

  @override
  State<RiskScreen> createState() => _RiskScreenState();
}

class _RiskScreenState extends State<RiskScreen> {
  @override
  void initState() {
    super.initState();
    _loadModel();
    getUserPosition().then((_) {
      _getUserThreeDayForecast();
    });
    _loadSelectedRivers().then((_) {
      _selectRiverStation();
      _getRiverThreeDayForecast();
    });
  }

  //Getting user risk:
  //Variables for the getUserPosition funtion
  String userLatitude = "Loading...";
  String userLongitude = "Loading..."; 

  //Get User Position Funtion
  Future <void> getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        userLatitude = "Disabled";
        userLongitude = "Disabled";
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          userLatitude = "Permission Denied";
          userLongitude = "Permission Denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        userLatitude = "Permission Denied Forever";
        userLongitude = "Permission Denied Forever";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      double roundedLat = double.parse(position.latitude.toStringAsFixed(3));
      double roundedLon = double.parse(position.longitude.toStringAsFixed(3));
      
      setState(() {
        userLatitude = roundedLat.toString();
        userLongitude = roundedLon.toString();
      });

      _getNearestUserStation();
      //_getThreeDayForecast();
    } catch (e) {
      setState(() {
        userLatitude = "Error";
        userLongitude = "Error";
      });
    }
  }

  //Variables for the  getNearestUserStation funtion
  String userBestStation = "";

  //Funtion for getting the user nearest and most recent weather station
  Future<void> _getNearestUserStation() async {
    final String apiUrl = "https://api.weather.com/v3/location/near?geocode=$userLatitude,$userLongitude&product=PWS&format=json&apiKey=$apiKey";
    String apiResponse = "";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final stationsIds = data['location']['stationId'];
        final updateTimes = data['location']['updateTimeUtc'];
        final distances = data['location']['distanceKm'];

        final List<Map<String, dynamic>> stations = [];
        for (int i = 0; i < stationsIds.length; i++) {
          stations.add({
            'stationId': stationsIds[i].toString(),
            'updateTime': updateTimes[i],
            'distance': distances[i].toDouble(),
          });
        }

        // Sort stations first by updateTime (most recent) and then by distance (closest)
        stations.sort((a, b) {
          int updateComparison = b['updateTime'].compareTo(a['updateTime']);
          if (updateComparison != 0) return updateComparison; // If the update date is different, use the most recent one
          return a['distance'].compareTo(b['distance']); // If the dates are the same, use the closest one
        });

        setState(() {
          userBestStation = stations.isNotEmpty ? stations.first['stationId'] : "";
          print(userBestStation);
        });

        setState(() {
          apiResponse = "Data retrieved:\n${data.toString()}";
        });

        _getUserObservationData();
      } else {
        setState(() {
          apiResponse = "Error retrieving data: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        apiResponse = "Error connecting to the API: $e";
      });
    }

    if (userBestStation.isNotEmpty) {
      _getUserObservationData();
    } else {
      setState(() {
        apiResponse = "No valid station";
      });
    }
  }

  //Map where we are going to save the response of the Observation Api (User)
  Map<String, dynamic> userObservation = {};

  Future<void> _getUserObservationData() async {
    final String observationApiUrl =
        "https://api.weather.com/v2/pws/observations/current?stationId=$userBestStation&format=json&units=m&apiKey=$apiKey";
    
    try {
      final ObservationResponse = await http.get(Uri.parse(observationApiUrl));

      if (ObservationResponse.statusCode == 200) {
        final data = json.decode(ObservationResponse.body);
        final observation = data['observations']?[0];

        if (observation != null) {
          setState(() {
            userObservation = {
              "LocalTime": observation['obsTimeLocal'],
              "Country": observation['country'],
              "Temperature": observation['metric']['temp'],
              "Humidity": observation['humidity'],
              "PrecipTotal": observation['metric']['precipTotal'],
              "PrecipRate": observation['metric']['precipRate']
            };
          });

          _getUserWeekData();
        }
      }
    } catch (e) {
      print("Error fetching observations: $e");
    }
  }

  Interpreter? _interpreter;
  String _result = "Not inferred yet";

  Future <void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Model loading error: $e');
    }
  }

  Map<String, dynamic> userWeekData = {};

  Future <void> _getUserWeekData() async {
    if (userBestStation == null) return;

    final String weekUserApiUrl =
        "https://api.weather.com/v2/pws/dailysummary/7day?stationId=$userBestStation&format=json&units=m&apiKey=$apiKey";

    try {
      final userWeekResponse = await http.get(Uri.parse(weekUserApiUrl));
      if (userWeekResponse.statusCode == 200) {
        final dataUserWeekApi = json.decode(userWeekResponse.body);
        final userSummarie = dataUserWeekApi['summaries'];

        if (userSummarie == null || userSummarie is! List) {
          print("Invalid or empty summary data");
          return;
        }

        double totalPrecipitation = 0;
        int daysWithData = 0;
        List<double> precipitationValues = [];

        Map<DateTime, List<dynamic>> groupedByDay = {};

        for (var entry in userSummarie) {
          if (entry['obsTimeLocal'] != null) {
            String obsUserDateStr = entry['obsTimeLocal'].split(' ')[0];
            DateTime obsUserDate = DateFormat('yyyy-MM-dd').parse(obsUserDateStr);
            groupedByDay.putIfAbsent(obsUserDate, () => []).add(entry);
          }
        }

        groupedByDay.forEach((date, entries) {
          List<double> precipTotal = entries
              .where((e) => e['metric']?['precipTotal'] != null)
              .map((e) => (e['metric']['precipTotal'] as num).toDouble())
              .toList();

          double dailyPrecipitation =
              precipTotal.isNotEmpty ? precipTotal.reduce((a, b) => a + b) : 0;

          totalPrecipitation += dailyPrecipitation;
          if (dailyPrecipitation > 0) daysWithData++;
          precipitationValues.add(dailyPrecipitation);
        });

        double avgPrecipitation = totalPrecipitation / 7;
        double stdDev = precipitationValues.standardDeviation;

          //Calculate the spi
        double spi = stdDev > 0
            ? (totalPrecipitation - avgPrecipitation) / stdDev
            : 0;

        double precipitation = userObservation['PrecipTotal'] ?? 0.0;
        double precipRate = userObservation['PrecipRate'] ?? 0.0;
        double humidity = (userObservation['Humidity'] ?? 0.0) / 100;

        List<double> inputData = [spi, precipitation, precipRate, humidity];
          var input = [Float32List.fromList(inputData)];
          var output = List.filled(3, 0.0).reshape([1, 3]);

          print(inputData);

          _interpreter!.run(input, output);

          int predictedClass = output[0].indexWhere((element) {
            double maxValue = (output[0] as List<dynamic>).reduce((a, b) => (a as double) > (b as double) ? a : b);
            return element == maxValue;
          });

          String floodRiskLevel;
          switch (predictedClass) {
            case 0:
              floodRiskLevel = 'LOW';
              break;
            case 1:
              floodRiskLevel = 'MEDIUM';
              break;
            case 2:
              floodRiskLevel = 'HIGH';
              break;
            default:
              floodRiskLevel = 'ERROR';
          }

        userWeekData = {
          "spi": spi.toStringAsFixed(2),
          "avgPrecipitation": avgPrecipitation,
          "stdDev": stdDev,
          "FloodRisk": floodRiskLevel,
        };

        if (userWeekData != null) {
          setState(() {
            userWeekData = {
              "spi": spi.toStringAsFixed(2),
              "avgPrecipitation": avgPrecipitation,
              "stdDev": stdDev,
              "FloodRisk": floodRiskLevel,
            };
          });
        }

        print("User week data: $userWeekData");
        print("spi ${userWeekData['spi']}");
      } else {
        print("Error: API responded with status ${userWeekResponse.statusCode}");
      }
    } catch (e) {
      print("Error fetching user week data: $e");
    }
  }


  List<Map<String, dynamic>> userForecast = [];

  Future<void> _getUserThreeDayForecast() async {
    String forecastUserApiUrl =
        "https://api.weather.com/v3/wx/forecast/daily/5day?geocode=$userLatitude,$userLongitude&format=json&units=m&language=en-US&apiKey=$apiKey";

    try {
      final forecastResponse = await http.get(Uri.parse(forecastUserApiUrl));

      if (forecastResponse.statusCode == 200) {
        final forecastApi = json.decode(forecastResponse.body);

        // Obtener datos del API
        final precipChances = forecastApi['daypart'][0]['precipChance']; 
        final precipTypes = forecastApi['daypart'][0]['precipType']; 
        final daysOfWeek = forecastApi['dayOfWeek']; 
        final forecast = forecastApi['daypart'][0]['wxPhraseLong'];

        // Crear lista para los próximos 3 días
        List<Map<String, dynamic>> threeDayForecast = [];
        for (int i = 0; i < 3; i++) {
          final dailyForecast = {
            'dayOfWeek': daysOfWeek[i],
            'precipChance': precipChances[i * 2] ?? 0, 
            'precipType': precipTypes[i * 2] ?? 'N/A',
            'forecast': forecast[i * 2] ?? 'No data',
          };
          threeDayForecast.add(dailyForecast);
        }

        setState(() {
          userForecast = threeDayForecast;
        });

      } else {
        print('Error al obtener el pronóstico: ${forecastResponse.statusCode}');
      }
    } catch (e) {
      print('Error al obtener el pronóstico: $e');
    }
  }

  IconData getForecastIcon(String? forecast) {
    if (forecast == null || forecast.isEmpty) {
      return WeatherIcons.na;
    }

    switch (forecast.toLowerCase()) {
      case 'sunny':
      case 'hot':
      case 'mostly sunny':
      case 'clear':
      case 'mostly clear':
        return WeatherIcons.day_sunny;
        
      case 'cloudy':
        return WeatherIcons.cloud;

      case 'mostly cloudy':
      case 'partly cloudy':
        return WeatherIcons.day_cloudy;

      case 'strong storms':
      case 'thunderstorms':
      case 'pm thunderstorms':
      case 'am thunderstorm':
      case 'isolated thunderstorms':
      case 'scattered thunderstorms':
        return WeatherIcons.thunderstorm;
      
      case 'rain':
      case 'drizzle':
      case 'showers':
      case 'am showers':
      case 'pm showers':
      case 'scattered showers':
      case 'heavy rain':
        return WeatherIcons.rain;
      
      case 'freezing drizzle':
      case 'hail':
      case 'sleet':
      case 'mixed rain and hail':
        return WeatherIcons.day_hail;
       
      case 'flurries':
      case 'snow':
      case 'snow showers':
      case 'frezzing rain':
      case 'scatted snow showers':
      case 'heavy snow':
      case 'blizzard':
      case 'wintry mix':
      case 'drifting snows':
      case 'ice crystals':
        return WeatherIcons.day_snow; 

      default:
        return WeatherIcons.na;
    }
  }

  //funtion for getting the saved rivers
  Future<void> _loadSelectedRivers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? riversAsJson = prefs.getStringList('SelectedRivers');
    if (riversAsJson != null) {
      setState(() {
        widget.selectedRivers = riversAsJson
            .map((riverJson) => jsonDecode(riverJson) as Map<String, dynamic>)
            .toList();
      });
    }
  }

  //Funtion for getting the river nearest and most recent weather station
  Future<void> _selectRiverStation() async {
    for (var river in widget.selectedRivers) {
      final riverLat = river['Coordinates']['Latitude'];
      final riverLon = river['Coordinates']['Longitude'];

      String baseApiUrl = "https://api.weather.com/v3/location/near?geocode=$riverLat,$riverLon&product=PWS&format=json&apiKey=$apiKey";

      try {
        final response = await http.get(Uri.parse(baseApiUrl));

        //once we get api response
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final stationsIds = data['location']['stationId'];
          final updateTimes = data['location']['updateTimeUtc'];
          final distances = data['location']['distanceKm'];

          if (stationsIds != null && stationsIds.isNotEmpty) {
            // Map and sort stations by update time
            final List<Map<String, dynamic>> stations = [];
            for (int i = 0; i < stationsIds.length; i++) {
              stations.add({
                'stationId': stationsIds[i].toString(),
                'updateTime': updateTimes[i],
                'distance': distances[i].toDouble(),
              });
            }

            stations.sort((a, b) => b['updateTime'].compareTo(a['updateTime']));

            setState(() {
              river['BestStation'] = stations.first['stationId'];
            });

            // call the other funtions that need the stationID
            await _getRiverObservation(river);
            await _getRiverWeekData(river);
          } else {
            setState(() {
              river['BestStation'] = null;
            });
          }
        } else {
          setState(() {
            river['BestStation'] = null;
          });
        }
      } catch (e) {
        setState(() {
          river['BestStation'] = null;
        });
      }
    }
  }

  //funtion for getting the actual time  river observations
  Future<void> _getRiverObservation(Map<String, dynamic> river) async {
    if (river['BestStation'] == null) return;

    final String RiverObservationApiUrl =
        "https://api.weather.com/v2/pws/observations/current?stationId=${river['BestStation']}&format=json&units=m&apiKey=$apiKey";

    try {
      final riverObservationResponse = await http.get(Uri.parse(RiverObservationApiUrl));

      if (riverObservationResponse.statusCode == 200) {
        final data = json.decode(riverObservationResponse.body);
        final observation = data['observations']?[0];

        if (observation != null) {
          setState(() {
            river['Observation'] = {
              "LocalTime": observation['obsTimeLocal'],
              "Neighborhood": observation['neighborhood'],
              "Country": observation['country'],
              "Temperature": observation['metric']['temp'],
              "Humidity": observation['humidity'],
              "PrecipTotal": observation['metric']['precipTotal'],
              "PrecipRate": observation['metric']['precipRate']
            };
          });
        }
      }
    } catch (e) {
      print("Error fetching observations: $e");
    }
  }

  Future<void> _getRiverWeekData(Map<String, dynamic> river) async {
    if (river['BestStation'] == null || _interpreter == null) return;

    final String weekApiUrl = 
      "https://api.weather.com/v2/pws/dailysummary/7day?stationId=${river['BestStation']}&format=json&units=m&apiKey=$apiKey" 
    ;

    try {
      final WeekRiverResponse = await http.get(Uri.parse(weekApiUrl));
        if (WeekRiverResponse.statusCode == 200) {
          //Decode the JSON
          final dataRiverWeekApi = json.decode(WeekRiverResponse.body);
          //get data
          final summaries = dataRiverWeekApi['summaries'];

          double totalPrecipitation = 0;
          int daysWithData = 0;
          List<double> precipitationValues = [];

          if (summaries != null) {
            Map<DateTime, List<dynamic>> groupedByDay = {};

            for (var entry in summaries) {
              // get the dates
              String obsDateStr = entry['obsTimeLocal'].split(' ')[0];
              DateTime obsDate = DateFormat('yyyy-MM-dd').parse(obsDateStr);

              groupedByDay.putIfAbsent(obsDate, () => []).add(entry);
            }

            // Browse throght the saved data
            groupedByDay.forEach((date, entries) {
              List<double> precipTotal = entries
                  .where((e) => e['metric']?['precipTotal'] != null)
                  .map((e) => e['metric']['precipTotal'] as double)
                  .toList();

              double dailyPrecipitation =
                  precipTotal.isNotEmpty ? precipTotal.reduce((a, b) => a + b) : 0;

              // Refresh data
              totalPrecipitation += dailyPrecipitation;
              if (dailyPrecipitation > 0) daysWithData++;
              precipitationValues.add(dailyPrecipitation);
            });
          }
          
          double avgPrecipitation = totalPrecipitation / 7;
          double stdDev = precipitationValues.standardDeviation;

          //Calculate the spi
          double spi = stdDev > 0
              ? (totalPrecipitation - avgPrecipitation) / stdDev
              : 0;
          
          double precipitation = river['Observation']?['PrecipTotal'] ?? 0.0;
          double precipRate = river['Observation']?['PrecipRate'] ?? 0.0;
          double humidity = (river['Observation']?['Humidity'] ?? 0.0) / 100; 

          List<double> inputData = [spi, precipitation, precipRate, humidity];
          
          var input = [Float32List.fromList(inputData)];
          var output = List.filled(3, 0.0).reshape([1, 3]);

          _interpreter!.run(input, output);

          int predictedClass = output[0].indexWhere((element) {
            double maxValue = (output[0] as List<dynamic>).reduce((a, b) => (a as double) > (b as double) ? a : b);
            return element == maxValue;
          });

          String floodRiskLevel;
          switch (predictedClass) {
            case 0:
              floodRiskLevel = 'LOW';
              break;
            case 1:
              floodRiskLevel = 'MEDIUM';
              break;
            case 2:
              floodRiskLevel = 'HIGH';
              break;
            default:
              floodRiskLevel = 'ERROR';
          }

          // Refresh states
          setState(() {
            river['totalPrecipitation'] = totalPrecipitation;
            river['avgPrecipitation'] = avgPrecipitation;
            river['stdDev'] = stdDev;
            river['SPI'] = spi.toStringAsFixed(2);
            river['floodRisk'] = floodRiskLevel;
          });
        }
      }catch(e) {
      print("Error");
    }
  }

  Future <void> _getRiverThreeDayForecast() async {
    for (var river in widget.selectedRivers) {
      final riverLat = river['Coordinates']['Latitude'];
      final riverLon = river['Coordinates']['Longitude'];

      String forecastApiUrl =
          "https://api.weather.com/v3/wx/forecast/daily/5day?geocode=$riverLat,$riverLon&format=json&units=m&language=en-US&apiKey=$apiKey";

      try {
        final forecastResponse = await http.get(Uri.parse(forecastApiUrl));

        if (forecastResponse.statusCode == 200) {
          final forecastApi = json.decode(forecastResponse.body);

          // get forecast for the next 3 days
          
          final precipChances = forecastApi['daypart'][0]['precipChance']; 
          final precipTypes = forecastApi['daypart'][0]['precipType']; 
          final daysOfWeek = forecastApi['dayOfWeek']; 
          final forecast = forecastApi['daypart'][0]['wxPhraseLong'];

          // create a list
          List<Map<String, dynamic>> threeDayForecast = [];
          for (int i = 0; i < 3; i++) {
            final dailyForecast = {
              'dayOfWeek': daysOfWeek[i],
              'precipChance': precipChances[i * 2],
              'precipType': precipTypes[i * 2] ?? 'N/A',
              'forecast': forecast[i * 2],
            };
            threeDayForecast.add(dailyForecast);
          }

          // actualize 
          setState(() {
            river['threeDayForecast'] = threeDayForecast;
          });

        } else {
          print('Error al obtener el pronóstico: ${forecastResponse.statusCode}');
        }
      } catch (e) {
        print('Error al obtener el pronóstico: $e');
      }
    }
  }

  //Get risk

  @override
  Widget build(BuildContext context) {
    Color userRiskColor;
    String riskuserText;

      switch(userWeekData['FloodRisk']) {
        case 'LOW':
        riskuserText = S.current.LOW;
        userRiskColor = Colors.green;
        break;
        case 'MEDIUM':
        riskuserText = S.current.MEDIUM;
        userRiskColor = Colors.amber;
        break;
        case 'HIGH':
        riskuserText = S.current.HIGH;
        userRiskColor = Colors.red;
        break;
        default:
        riskuserText = S.current.DEFAULT;
        userRiskColor = Colors.grey;
      }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(S.current.riskScreen), backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ExpansionTile(
                title: Row(
                  children: [
                    Expanded(child: Text('${S.current.userLocation}\n${S.current.riskRiskScreen(riskuserText ?? 'Desconocido')}')),
                    
                    Icon(Icons.water, color: userRiskColor, size: 65,),
                                      
                  ],
                ),
                children: [
                  if (userBestStation.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0), 
                    child: 
                    Text(
                      "${S.current.country(userObservation['Country'] ?? 'N/A')}\n"
                      "${S.current.precipation(userObservation['PrecipTotal'] ?? 'N/A')}mm\n"
                      "${S.current.precipitationIntensity(userObservation['PrecipRate'] ?? 'N/A')}\n"
                      "${S.current.humidity(userObservation['Humidity'] ?? 'N/A')}%\n"
                      "${S.current.spi(userWeekData['spi'] ?? 'N/A')}\n"
                      "${S.current.temperature(userObservation['Temperature'] ?? 'N/A')}°C\n"
                    )
                  )else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                         S.current.noStationData,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (userForecast != null)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, 
                    child: Row(
                      children: userForecast.map<Widget>((forecast) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                          child: Column(
                            children: [
                              Icon(
                                getForecastIcon(forecast['forecast']),
                                size: 40,
                              ),
                              Text(
                                forecast['dayOfWeek'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${S.current.precipitationProbability(forecast['precipChance'] ?? 'N/A')}%"),
                              Text(forecast['forecast'] ?? 'N/A'),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  if (widget.selectedRivers.isEmpty)
                    Column(
                      children: [
                        Text(
                          S.current.firstSelectaRiver,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ...widget.selectedRivers.map((river) {
                    Color riskColor;
                    String riskText;
                    switch (river['floodRisk']) {
                      case 'LOW':
                        riskText = S.current.LOW;
                        riskColor = Colors.green;
                        break;
                      case 'MEDIUM':
                        riskText = S.current.MEDIUM;
                        riskColor = Colors.amber;
                        break;
                      case 'HIGH':
                        riskText = S.current.HIGH;
                        riskColor = Colors.red;
                        break;
                      default:
                        riskText = S.current.DEFAULT;
                        riskColor = Colors.grey;
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Expanded(child: Text("${river['RiverName'] ?? S.current.noName}\n" "${S.current.riskRiskScreen(riskText ?? 'Desconocido')}")),
                            Icon(Icons.water, color: riskColor, size: 65,),
                          ],
                        ),
                        children: [
                          if (river['BestStation'] != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${S.current.country(river['Observation']?['Country'] ?? 'N/A')}\n"
                                "${S.current.precipation(river['Observation']?['PrecipTotal'] ?? 'N/A')}mm\n"
                                "${S.current.precipitationIntensity(river['Observation']?['PrecipRate'] ?? 'N/A')}\n"
                                "${S.current.humidity(river['Observation']?['Humidity'] ?? 'N/A')}%\n"
                                "${S.current.spi(river['SPI'] ?? 'N/A')}\n"
                                "${S.current.temperature(river['Observation']?['Temperature'] ?? 'N/A')}°C\n"
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                S.current.noStationData,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          if (river['threeDayForecast'] != null)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal, 
                            child: Row(
                              children: river['threeDayForecast'].map<Widget>((forecast) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                                  child: Column(
                                    children: [
                                      Icon(
                                        getForecastIcon(forecast['forecast']),
                                        size: 40,
                                      ),
                                      Text(
                                        forecast['dayOfWeek'],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text("${S.current.precipitationProbability(forecast['precipChance'] ?? 'N/A')}%"),
                                      Text(forecast['forecast'] ?? 'N/A'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                          else
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                S.current.noForecastData,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}