import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:river_stream_unlimited_tech/services/getbeststation.dart';

Map<String, dynamic> userObservation = {};

Future <void> getuserobservations() async {
  final String observationApiUrl = "https://api.weather.com/v2/pws/observations/current?stationId=$userBestStation&format=json&units=m&apiKey=$apiKey";

  try {
    final ObservationResponse = await http.get(Uri.parse(observationApiUrl));
    if (ObservationResponse.statusCode == 200) {
        final data = json.decode(ObservationResponse.body);
        final observation = data['observations']?[0];

        if (observation != null) {
          userObservation = {
            "LocalTime": observation['obsTimeLocal'],
            "Country": observation['country'],
            "Temperature": observation['metric']['temp'],
            "Humidity": observation['humidity'],
            "PrecipTotal": observation['metric']['precipTotal'],
            "PrecipRate": observation['metric']['precipRate']
          };
        }
    }
  }catch(e){
    print('error');
  }
}