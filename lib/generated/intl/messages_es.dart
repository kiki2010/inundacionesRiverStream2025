// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(uploadedUrl) => "Uploaded image URL: ${uploadedUrl}";

  static String m1(comment) => "Comentario ${comment}";

  static String m2(country) => "País: ${country}";

  static String m3(date) => "Día y Hora ${date}";

  static String m4(errorMsg) => "Error extending video: ${errorMsg}";

  static String m5(errorMsg) => "Error starting generation: ${errorMsg}";

  static String m6(e) => "Upload or generation error: ${e}";

  static String m7(e) => "Error while extending video: ${e}";

  static String m8(state) => "Generating... Current state ${state}";

  static String m9(generationId) =>
      "Video generation started. ID: ${generationId}";

  static String m10(humidity) => "Humedad: ${humidity}";

  static String m11(precipitationTotal) =>
      "Precipitaciones: ${precipitationTotal}";

  static String m12(precipitationIntensity) =>
      "Intensidad de precipitación: ${precipitationIntensity}";

  static String m13(precipitacionProbability) =>
      "Precipitaciones: ${precipitacionProbability}";

  static String m14(risk) => "Riesgo ${risk}";

  static String m15(spi) => "SPI: ${spi}";

  static String m16(temperature) => "Temperatura: ${temperature}";

  static String m17(newId) => "Extended video generation started. ID: ${newId}";

  static String m18(failReason) => "Video generation failed: ${failReason}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "DEFAULT": MessageLookupByLibrary.simpleMessage("Desconocido"),
    "HIGH": MessageLookupByLibrary.simpleMessage("Alto"),
    "LOW": MessageLookupByLibrary.simpleMessage("Bajo"),
    "MEDIUM": MessageLookupByLibrary.simpleMessage("Medio"),
    "UploadedImgUrl": m0,
    "UploadingImg": MessageLookupByLibrary.simpleMessage("Subiendo imagen..."),
    "closeMapScreen": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "commentMapScreen": m1,
    "commentSelectorPostScreen": MessageLookupByLibrary.simpleMessage(
      "Comentario",
    ),
    "country": m2,
    "date": MessageLookupByLibrary.simpleMessage("Fecha"),
    "dateandtime": m3,
    "erroeCheckingStatus": MessageLookupByLibrary.simpleMessage(
      "Error checking status (retrying...)",
    ),
    "errorExtendingVideo": m4,
    "errorGeneration": m5,
    "errorhasocured": MessageLookupByLibrary.simpleMessage(
      "An error has occurred",
    ),
    "errorretrievingUrl": MessageLookupByLibrary.simpleMessage(
      "Error retrieving video URL. Retrying...",
    ),
    "errortype": m6,
    "errortypeextendingVideo": m7,
    "extendGenerate": MessageLookupByLibrary.simpleMessage("Extender Video"),
    "firstSelectaRiver": MessageLookupByLibrary.simpleMessage(
      "Primero necesitas seleccionar un río",
    ),
    "generate": MessageLookupByLibrary.simpleMessage("Generar"),
    "generatingstate": m8,
    "generationStarted": m9,
    "generationTimeOut": MessageLookupByLibrary.simpleMessage(
      "Generation timed out. Please try again.",
    ),
    "hello": MessageLookupByLibrary.simpleMessage("Hola"),
    "house": MessageLookupByLibrary.simpleMessage("Casa"),
    "humidity": m10,
    "imageCouldntbeloaded": MessageLookupByLibrary.simpleMessage(
      "No se pudo cargar la imagen",
    ),
    "imageSelectorPostScreen": MessageLookupByLibrary.simpleMessage("Imagen"),
    "imagenotselected": MessageLookupByLibrary.simpleMessage(
      "Imagen no seleccionada",
    ),
    "locationdenied": MessageLookupByLibrary.simpleMessage(
      "Autorización de ubicación denegada.",
    ),
    "locationisturnedoff": MessageLookupByLibrary.simpleMessage(
      "Los servicios de ubicación están desactivados.",
    ),
    "locationpermissionspermanently": MessageLookupByLibrary.simpleMessage(
      "Los permisos de ubicación se han denegado de forma permanente. Habilítelos desde la configuración.",
    ),
    "map": MessageLookupByLibrary.simpleMessage("Mapa"),
    "mapScreen": MessageLookupByLibrary.simpleMessage("Pantalla de Mapa"),
    "moreInfo": MessageLookupByLibrary.simpleMessage("Más Información"),
    "noForecastData": MessageLookupByLibrary.simpleMessage(
      "No hay datos de pronostico disponibles",
    ),
    "noIDFound": MessageLookupByLibrary.simpleMessage(
      "No se encontró ningún ID de generación.",
    ),
    "noImgSelected": MessageLookupByLibrary.simpleMessage(
      "No hay ninguna imagen seleccionada.",
    ),
    "noName": MessageLookupByLibrary.simpleMessage("No Name"),
    "noStationData": MessageLookupByLibrary.simpleMessage(
      "Hay datos disponibles",
    ),
    "pleaseSelectImage": MessageLookupByLibrary.simpleMessage(
      "Seleccione una imagen primero.",
    ),
    "pleaseSelectOne": MessageLookupByLibrary.simpleMessage(
      "Please select only one option.",
    ),
    "pleaseSelectRiverorHouse": MessageLookupByLibrary.simpleMessage(
      "Por favor seleccione Casa o Río.",
    ),
    "pleaseselectimage": MessageLookupByLibrary.simpleMessage(
      "Por favor seleccione una imagen",
    ),
    "post": MessageLookupByLibrary.simpleMessage("Post"),
    "postPostScreen": MessageLookupByLibrary.simpleMessage("Publicar"),
    "postScreen": MessageLookupByLibrary.simpleMessage("Pantalla de Post"),
    "precipation": m11,
    "precipitationIntensity": m12,
    "precipitationProbability": m13,
    "readybutnotfound": MessageLookupByLibrary.simpleMessage(
      "Completed, but no video URL found. Retrying...",
    ),
    "requestVideo": MessageLookupByLibrary.simpleMessage(
      "Requesting extended video...",
    ),
    "risk": MessageLookupByLibrary.simpleMessage("Predicción"),
    "riskRiskScreen": m14,
    "riskScreen": MessageLookupByLibrary.simpleMessage(
      "Pronosticos de Escurrimientos",
    ),
    "riverPostScreen": MessageLookupByLibrary.simpleMessage("Río"),
    "riverSelectorPostScreen": MessageLookupByLibrary.simpleMessage(
      "Seleccione un río",
    ),
    "riverSimulationScreen": MessageLookupByLibrary.simpleMessage("Río"),
    "sendingtoDreamMachine": MessageLookupByLibrary.simpleMessage(
      "Sending request to Dream Machine...",
    ),
    "setting": MessageLookupByLibrary.simpleMessage("Configuración"),
    "simulate": MessageLookupByLibrary.simpleMessage("Simulación"),
    "simulationScreen": MessageLookupByLibrary.simpleMessage(
      "Pantalla de simulación",
    ),
    "spi": m15,
    "submissioncomplete": MessageLookupByLibrary.simpleMessage(
      "¡El post se a subido correctamente!",
    ),
    "temperature": m16,
    "userLocation": MessageLookupByLibrary.simpleMessage("Tu ubicación"),
    "videoGenerationStarted": m17,
    "videoLoading": MessageLookupByLibrary.simpleMessage(
      "El vídeo se está cargando...",
    ),
    "videoReadyPlaying": MessageLookupByLibrary.simpleMessage(
      "Video ready! Playing...",
    ),
    "videogenerationFailed": m18,
    "waitingForInput": MessageLookupByLibrary.simpleMessage(
      "Esperando Input...",
    ),
    "writecommentSelectorPostScreen": MessageLookupByLibrary.simpleMessage(
      "Escribe un comentario",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Configuración"),
    "language": MessageLookupByLibrary.simpleMessage("Lenguaje"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notificaciones"),
    "buttonSettingSelectRiver": MessageLookupByLibrary.simpleMessage("Seleccionar Ríos"),
    "advicetext": MessageLookupByLibrary.simpleMessage(
      "A continuación se muestran algunos sitios donde puede obtener más información sobre las inundaciones:",
    ),
    "floodSafety": MessageLookupByLibrary.simpleMessage("Seguridad \n contra \n inundaciones"),
    "duringAFlood": MessageLookupByLibrary.simpleMessage("Durante \n una \n inundación"),
    "addNew": MessageLookupByLibrary.simpleMessage("Añadir nuevo río"),
    "nameRiver": MessageLookupByLibrary.simpleMessage("Nombre del río"),
    "plsAddRiverName": MessageLookupByLibrary.simpleMessage("Añadir el nombre del río"),
    "stateoProvince": MessageLookupByLibrary.simpleMessage("Estado/Provincia"),
    "plsAddStateProvince": MessageLookupByLibrary.simpleMessage("Añadir estado/provincia"),
    "countryform": MessageLookupByLibrary.simpleMessage("País"),
    "plsAddcountry": MessageLookupByLibrary.simpleMessage("Añadir país"),
    "latitude": MessageLookupByLibrary.simpleMessage("Latitud"),
    "plsAddLatitude": MessageLookupByLibrary.simpleMessage("Introducir una latitud válida"),
    "length": MessageLookupByLibrary.simpleMessage("Longitud"),
    "plsAddLenght": MessageLookupByLibrary.simpleMessage("Introducir una longitud válida"),
    "riverAdded": MessageLookupByLibrary.simpleMessage("Río añadido correctamente"),
    "errorAddingRiver": MessageLookupByLibrary.simpleMessage("Error al añadir el río: {e}"),
    "save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "description": MessageLookupByLibrary.simpleMessage(
      "Preste atención a las recomendaciones de las autoridades locales",
    ),
    "notification": MessageLookupByLibrary.simpleMessage(
      "⚠️Advertencia: Riego ALTO⚠️",
    ),
  };
}
