// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(uploadedUrl) => "Uploaded image URL: ${uploadedUrl}";

  static String m1(comment) => "Comment ${comment}";

  static String m2(country) => "Country: ${country}";

  static String m3(date) => "Date and Time ${date}";

  static String m4(e) => "Error adding river: ${e}";

  static String m5(errorMsg) => "Error extending video: ${errorMsg}";

  static String m6(errorMsg) => "Error starting generation: ${errorMsg}";

  static String m7(e) => "Upload or generation error: ${e}";

  static String m8(e) => "Error while extending video: ${e}";

  static String m9(state) => "Generating... Current state ${state}";

  static String m10(generationId) =>
      "Video generation started. ID: ${generationId}";

  static String m11(humidity) => "Humidity: ${humidity}";

  static String m12(precipitationTotal) => "Precipation: ${precipitationTotal}";

  static String m13(precipitationIntensity) =>
      "Precipitation Intensity: ${precipitationIntensity}";

  static String m14(precipitacionProbability) =>
      "Precipation: ${precipitacionProbability}";

  static String m15(risk) => "Risk ${risk}";

  static String m16(spi) => "SPI: ${spi}";

  static String m17(temperature) => "Temperature: ${temperature}";

  static String m18(newId) => "Extended video generation started. ID: ${newId}";

  static String m19(failReason) => "Video generation failed: ${failReason}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "DEFAULT": MessageLookupByLibrary.simpleMessage("Unknown"),
    "HIGH": MessageLookupByLibrary.simpleMessage("High"),
    "LOW": MessageLookupByLibrary.simpleMessage("Low"),
    "MEDIUM": MessageLookupByLibrary.simpleMessage("Medium"),
    "UploadedImgUrl": m0,
    "UploadingImg": MessageLookupByLibrary.simpleMessage("Uploading image..."),
    "addNew": MessageLookupByLibrary.simpleMessage("Add New River"),
    "advicetext": MessageLookupByLibrary.simpleMessage(
      "Here are some sites to learn more about flooding:",
    ),
    "buttonSettingSelectRiver": MessageLookupByLibrary.simpleMessage(
      "Select Rivers",
    ),
    "change_language": MessageLookupByLibrary.simpleMessage("Change Language"),
    "closeMapScreen": MessageLookupByLibrary.simpleMessage("Close"),
    "commentMapScreen": m1,
    "commentSelectorPostScreen": MessageLookupByLibrary.simpleMessage(
      "Comment",
    ),
    "country": m2,
    "countryform": MessageLookupByLibrary.simpleMessage("Country"),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "dateandtime": m3,
    "description": MessageLookupByLibrary.simpleMessage(
      "Pay attention to the recommendations of local authorities",
    ),
    "duringAFlood": MessageLookupByLibrary.simpleMessage("During a Flood"),
    "erroeCheckingStatus": MessageLookupByLibrary.simpleMessage(
      "Error checking status (retrying...)",
    ),
    "errorAddingRiver": m4,
    "errorExtendingVideo": m5,
    "errorGeneration": m6,
    "errorhasocured": MessageLookupByLibrary.simpleMessage(
      "An error has occurred",
    ),
    "errorretrievingUrl": MessageLookupByLibrary.simpleMessage(
      "Error retrieving video URL. Retrying...",
    ),
    "errortype": m7,
    "errortypeextendingVideo": m8,
    "extendGenerate": MessageLookupByLibrary.simpleMessage("Extend Generate"),
    "firstSelectaRiver": MessageLookupByLibrary.simpleMessage(
      "First you need to select at least 1 river",
    ),
    "floodSafety": MessageLookupByLibrary.simpleMessage("Flood Safety"),
    "generate": MessageLookupByLibrary.simpleMessage("Generate"),
    "generatingstate": m9,
    "generationStarted": m10,
    "generationTimeOut": MessageLookupByLibrary.simpleMessage(
      "Generation timed out. Please try again.",
    ),
    "hello": MessageLookupByLibrary.simpleMessage("Hello"),
    "house": MessageLookupByLibrary.simpleMessage("House"),
    "humidity": m11,
    "imageCouldntbeloaded": MessageLookupByLibrary.simpleMessage(
      "Image could not be loaded",
    ),
    "imageSelectorPostScreen": MessageLookupByLibrary.simpleMessage("Image"),
    "imagenotselected": MessageLookupByLibrary.simpleMessage(
      "Image not selected",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "latitude": MessageLookupByLibrary.simpleMessage("Latitude"),
    "length": MessageLookupByLibrary.simpleMessage("Length"),
    "locationdenied": MessageLookupByLibrary.simpleMessage(
      "Location authorization denied.",
    ),
    "locationisturnedoff": MessageLookupByLibrary.simpleMessage(
      "Location services are turned off.",
    ),
    "locationpermissionspermanently": MessageLookupByLibrary.simpleMessage(
      "Location permissions have been permanently denied. Please allow it from the settings.",
    ),
    "map": MessageLookupByLibrary.simpleMessage("Map"),
    "mapScreen": MessageLookupByLibrary.simpleMessage("Map Screen"),
    "moreInfo": MessageLookupByLibrary.simpleMessage("More Information"),
    "nameRiver": MessageLookupByLibrary.simpleMessage("Name of the River"),
    "noForecastData": MessageLookupByLibrary.simpleMessage(
      "No forecast data available",
    ),
    "noIDFound": MessageLookupByLibrary.simpleMessage(
      "No generation ID found.",
    ),
    "noImgSelected": MessageLookupByLibrary.simpleMessage("No image selected."),
    "noName": MessageLookupByLibrary.simpleMessage("No Name"),
    "noStationData": MessageLookupByLibrary.simpleMessage(
      "No station data available",
    ),
    "notification": MessageLookupByLibrary.simpleMessage(
      "⚠️Warning: HIGH Risk⚠️",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "pleaseSelectImage": MessageLookupByLibrary.simpleMessage(
      "Please select an image first.",
    ),
    "pleaseSelectOne": MessageLookupByLibrary.simpleMessage(
      "Please select only one option.",
    ),
    "pleaseSelectRiverorHouse": MessageLookupByLibrary.simpleMessage(
      "Please select either House or River.",
    ),
    "pleaseselectimage": MessageLookupByLibrary.simpleMessage(
      "Please select an image",
    ),
    "plsAddLatitude": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid latitude",
    ),
    "plsAddLenght": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid Length",
    ),
    "plsAddRiverName": MessageLookupByLibrary.simpleMessage(
      "Please add the name of the river",
    ),
    "plsAddStateProvince": MessageLookupByLibrary.simpleMessage(
      "Please add state/province",
    ),
    "plsAddcountry": MessageLookupByLibrary.simpleMessage("Please add country"),
    "post": MessageLookupByLibrary.simpleMessage("Post"),
    "postPostScreen": MessageLookupByLibrary.simpleMessage("Post"),
    "postScreen": MessageLookupByLibrary.simpleMessage("Posting screen"),
    "precipation": m12,
    "precipitationIntensity": m13,
    "precipitationProbability": m14,
    "readybutnotfound": MessageLookupByLibrary.simpleMessage(
      "Completed, but no video URL found. Retrying...",
    ),
    "requestVideo": MessageLookupByLibrary.simpleMessage(
      "Requesting extended video...",
    ),
    "risk": MessageLookupByLibrary.simpleMessage("Risk"),
    "riskRiskScreen": m15,
    "riskScreen": MessageLookupByLibrary.simpleMessage("Flood Risk Screen"),
    "riverAdded": MessageLookupByLibrary.simpleMessage(
      "River added successfully",
    ),
    "riverPostScreen": MessageLookupByLibrary.simpleMessage("River"),
    "riverSelectorPostScreen": MessageLookupByLibrary.simpleMessage(
      "Select a river",
    ),
    "riverSimulationScreen": MessageLookupByLibrary.simpleMessage("River"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "sendingtoDreamMachine": MessageLookupByLibrary.simpleMessage(
      "Sending request to Dream Machine...",
    ),
    "setting": MessageLookupByLibrary.simpleMessage("Setting"),
    "settings": MessageLookupByLibrary.simpleMessage("Setting"),
    "simulate": MessageLookupByLibrary.simpleMessage("Simulate"),
    "simulationScreen": MessageLookupByLibrary.simpleMessage(
      "Simulation Screen",
    ),
    "spi": m16,
    "stateoProvince": MessageLookupByLibrary.simpleMessage("State/Province"),
    "submissioncomplete": MessageLookupByLibrary.simpleMessage(
      "Submission is complete!",
    ),
    "temperature": m17,
    "userLocation": MessageLookupByLibrary.simpleMessage("User Location"),
    "videoGenerationStarted": m18,
    "videoLoading": MessageLookupByLibrary.simpleMessage("Video is loading..."),
    "videoReadyPlaying": MessageLookupByLibrary.simpleMessage(
      "Video ready! Playing...",
    ),
    "videogenerationFailed": m19,
    "waitingForInput": MessageLookupByLibrary.simpleMessage(
      "Waiting for input...",
    ),
    "writecommentSelectorPostScreen": MessageLookupByLibrary.simpleMessage(
      "Write a comment",
    ),
  };
}
