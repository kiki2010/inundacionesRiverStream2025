import 'dart:typed_data';
import 'package:river_stream_unlimited_tech/services/getweekresume.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

double spi = userWeekData['SPI'];
double precipitation = userWeekData['Precitipation'];
double precipRate = userWeekData['PrecipRate'];
double humidity = userWeekData['Humidity'];

Interpreter? _interpreter;
String _result = "Not inferred yet";
String risk = "";

Future <void> loadModel() async {
  try {
  _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    print('Model loaded successfully');
  } catch (e) {
    print('Model loading error: $e');
  }
}

Future <void> calculateRisk() async{
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

  if (floodRiskLevel != null) {
    risk = floodRiskLevel;
  }
}