import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:statistics/statistics.dart';
import 'package:intl/intl.dart';
import 'package:river_stream_unlimited_tech/services/getbeststation.dart';
import 'package:river_stream_unlimited_tech/services/getobservations.dart';

Map<String, dynamic> userWeekData = {};
final String weekUserApiUrl = "https://api.weather.com/v2/pws/dailysummary/7day?stationId=$userBestStation&format=json&units=m&apiKey=$apiKey";

Future <void> getUserWeekData() async {
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

      if (spi != null) {
          userWeekData = {
            "Precitipation": precipitation,
            "PrecipRate": precipRate,
            "SPI": spi,
            "Humidity": humidity,
          };
        }
    }
  } 
  catch (e) {
    print('error');
  }
}