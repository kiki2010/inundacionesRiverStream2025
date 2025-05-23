import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:river_stream_unlimited_tech/services/getlocation.dart';

String userBestStation = "";
String apiKey = "026cda1f35b54cddacda1f35b53cdda3";
final String apiUrl1 = "https://api.weather.com/v3/location/near?geocode=$userLatitude,$userLongitude&product=PWS&format=json&apiKey=$apiKey";

Future<void> getNearestUserStation() async {
  try {
    final response = await http.get(Uri.parse(apiUrl1));

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

      userBestStation = stations.isNotEmpty ? stations.first['stationId'] : "";
      print(userBestStation);
    }
  }
  catch (e){
    print('error');
  }
}