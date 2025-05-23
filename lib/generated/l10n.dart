// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message('Post', name: 'post', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Risk`
  String get risk {
    return Intl.message('Risk', name: 'risk', desc: '', args: []);
  }

  /// `Simulate`
  String get simulate {
    return Intl.message('Simulate', name: 'simulate', desc: '', args: []);
  }

  /// `Setting`
  String get setting {
    return Intl.message('Setting', name: 'setting', desc: '', args: []);
  }

  /// `Posting screen`
  String get postScreen {
    return Intl.message(
      'Posting screen',
      name: 'postScreen',
      desc: '',
      args: [],
    );
  }

  /// `Image not selected`
  String get imagenotselected {
    return Intl.message(
      'Image not selected',
      name: 'imagenotselected',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred`
  String get errorhasocured {
    return Intl.message(
      'An error has occurred',
      name: 'errorhasocured',
      desc: '',
      args: [],
    );
  }

  /// `Location services are turned off.`
  String get locationisturnedoff {
    return Intl.message(
      'Location services are turned off.',
      name: 'locationisturnedoff',
      desc: '',
      args: [],
    );
  }

  /// `Location authorization denied.`
  String get locationdenied {
    return Intl.message(
      'Location authorization denied.',
      name: 'locationdenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions have been permanently denied. Please allow it from the settings.`
  String get locationpermissionspermanently {
    return Intl.message(
      'Location permissions have been permanently denied. Please allow it from the settings.',
      name: 'locationpermissionspermanently',
      desc: '',
      args: [],
    );
  }

  /// `Please select an image`
  String get pleaseselectimage {
    return Intl.message(
      'Please select an image',
      name: 'pleaseselectimage',
      desc: '',
      args: [],
    );
  }

  /// `Submission is complete!`
  String get submissioncomplete {
    return Intl.message(
      'Submission is complete!',
      name: 'submissioncomplete',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `River`
  String get riverPostScreen {
    return Intl.message('River', name: 'riverPostScreen', desc: '', args: []);
  }

  /// `Select a river`
  String get riverSelectorPostScreen {
    return Intl.message(
      'Select a river',
      name: 'riverSelectorPostScreen',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get imageSelectorPostScreen {
    return Intl.message(
      'Image',
      name: 'imageSelectorPostScreen',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get commentSelectorPostScreen {
    return Intl.message(
      'Comment',
      name: 'commentSelectorPostScreen',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment`
  String get writecommentSelectorPostScreen {
    return Intl.message(
      'Write a comment',
      name: 'writecommentSelectorPostScreen',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get postPostScreen {
    return Intl.message('Post', name: 'postPostScreen', desc: '', args: []);
  }

  /// `Map Screen`
  String get mapScreen {
    return Intl.message('Map Screen', name: 'mapScreen', desc: '', args: []);
  }

  /// `More Information`
  String get moreInfo {
    return Intl.message(
      'More Information',
      name: 'moreInfo',
      desc: '',
      args: [],
    );
  }

  /// `Image could not be loaded`
  String get imageCouldntbeloaded {
    return Intl.message(
      'Image could not be loaded',
      name: 'imageCouldntbeloaded',
      desc: '',
      args: [],
    );
  }

  /// `Date and Time {date}`
  String dateandtime(Object date) {
    return Intl.message(
      'Date and Time $date',
      name: 'dateandtime',
      desc: '',
      args: [date],
    );
  }

  /// `Comment {comment}`
  String commentMapScreen(Object comment) {
    return Intl.message(
      'Comment $comment',
      name: 'commentMapScreen',
      desc: '',
      args: [comment],
    );
  }

  /// `Close`
  String get closeMapScreen {
    return Intl.message('Close', name: 'closeMapScreen', desc: '', args: []);
  }

  /// `Flood Risk Screen`
  String get riskScreen {
    return Intl.message(
      'Flood Risk Screen',
      name: 'riskScreen',
      desc: '',
      args: [],
    );
  }

  /// `User Location`
  String get userLocation {
    return Intl.message(
      'User Location',
      name: 'userLocation',
      desc: '',
      args: [],
    );
  }

  /// `Risk {risk}`
  String riskRiskScreen(Object risk) {
    return Intl.message(
      'Risk $risk',
      name: 'riskRiskScreen',
      desc: '',
      args: [risk],
    );
  }

  /// `Low`
  String get LOW {
    return Intl.message('Low', name: 'LOW', desc: '', args: []);
  }

  /// `Medium`
  String get MEDIUM {
    return Intl.message('Medium', name: 'MEDIUM', desc: '', args: []);
  }

  /// `High`
  String get HIGH {
    return Intl.message('High', name: 'HIGH', desc: '', args: []);
  }

  /// `Unknown`
  String get DEFAULT {
    return Intl.message('Unknown', name: 'DEFAULT', desc: '', args: []);
  }

  /// `Country: {country}`
  String country(Object country) {
    return Intl.message(
      'Country: $country',
      name: 'country',
      desc: '',
      args: [country],
    );
  }

  /// `Precipation: {precipitationTotal}`
  String precipation(Object precipitationTotal) {
    return Intl.message(
      'Precipation: $precipitationTotal',
      name: 'precipation',
      desc: '',
      args: [precipitationTotal],
    );
  }

  /// `Precipitation Intensity: {precipitationIntensity}`
  String precipitationIntensity(Object precipitationIntensity) {
    return Intl.message(
      'Precipitation Intensity: $precipitationIntensity',
      name: 'precipitationIntensity',
      desc: '',
      args: [precipitationIntensity],
    );
  }

  /// `Humidity: {humidity}`
  String humidity(Object humidity) {
    return Intl.message(
      'Humidity: $humidity',
      name: 'humidity',
      desc: '',
      args: [humidity],
    );
  }

  /// `SPI: {spi}`
  String spi(Object spi) {
    return Intl.message('SPI: $spi', name: 'spi', desc: '', args: [spi]);
  }

  /// `Temperature: {temperature}`
  String temperature(Object temperature) {
    return Intl.message(
      'Temperature: $temperature',
      name: 'temperature',
      desc: '',
      args: [temperature],
    );
  }

  /// `No station data available`
  String get noStationData {
    return Intl.message(
      'No station data available',
      name: 'noStationData',
      desc: '',
      args: [],
    );
  }

  /// `Precipation: {precipitacionProbability}`
  String precipitationProbability(Object precipitacionProbability) {
    return Intl.message(
      'Precipation: $precipitacionProbability',
      name: 'precipitationProbability',
      desc: '',
      args: [precipitacionProbability],
    );
  }

  /// `First you need to select at least 1 river`
  String get firstSelectaRiver {
    return Intl.message(
      'First you need to select at least 1 river',
      name: 'firstSelectaRiver',
      desc: '',
      args: [],
    );
  }

  /// `No Name`
  String get noName {
    return Intl.message('No Name', name: 'noName', desc: '', args: []);
  }

  /// `No forecast data available`
  String get noForecastData {
    return Intl.message(
      'No forecast data available',
      name: 'noForecastData',
      desc: '',
      args: [],
    );
  }

  /// `Simulation Screen`
  String get simulationScreen {
    return Intl.message(
      'Simulation Screen',
      name: 'simulationScreen',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for input...`
  String get waitingForInput {
    return Intl.message(
      'Waiting for input...',
      name: 'waitingForInput',
      desc: '',
      args: [],
    );
  }

  /// `No image selected.`
  String get noImgSelected {
    return Intl.message(
      'No image selected.',
      name: 'noImgSelected',
      desc: '',
      args: [],
    );
  }

  /// `Uploading image...`
  String get UploadingImg {
    return Intl.message(
      'Uploading image...',
      name: 'UploadingImg',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded image URL: {uploadedUrl}`
  String UploadedImgUrl(Object uploadedUrl) {
    return Intl.message(
      'Uploaded image URL: $uploadedUrl',
      name: 'UploadedImgUrl',
      desc: '',
      args: [uploadedUrl],
    );
  }

  /// `Please select only one option.`
  String get pleaseSelectOne {
    return Intl.message(
      'Please select only one option.',
      name: 'pleaseSelectOne',
      desc: '',
      args: [],
    );
  }

  /// `Sending request to Dream Machine...`
  String get sendingtoDreamMachine {
    return Intl.message(
      'Sending request to Dream Machine...',
      name: 'sendingtoDreamMachine',
      desc: '',
      args: [],
    );
  }

  /// `Video generation started. ID: {generationId}`
  String generationStarted(Object generationId) {
    return Intl.message(
      'Video generation started. ID: $generationId',
      name: 'generationStarted',
      desc: '',
      args: [generationId],
    );
  }

  /// `Error starting generation: {errorMsg}`
  String errorGeneration(Object errorMsg) {
    return Intl.message(
      'Error starting generation: $errorMsg',
      name: 'errorGeneration',
      desc: '',
      args: [errorMsg],
    );
  }

  /// `Upload or generation error: {e}`
  String errortype(Object e) {
    return Intl.message(
      'Upload or generation error: $e',
      name: 'errortype',
      desc: '',
      args: [e],
    );
  }

  /// `Requesting extended video...`
  String get requestVideo {
    return Intl.message(
      'Requesting extended video...',
      name: 'requestVideo',
      desc: '',
      args: [],
    );
  }

  /// `Extended video generation started. ID: {newId}`
  String videoGenerationStarted(Object newId) {
    return Intl.message(
      'Extended video generation started. ID: $newId',
      name: 'videoGenerationStarted',
      desc: '',
      args: [newId],
    );
  }

  /// `Error extending video: {errorMsg}`
  String errorExtendingVideo(Object errorMsg) {
    return Intl.message(
      'Error extending video: $errorMsg',
      name: 'errorExtendingVideo',
      desc: '',
      args: [errorMsg],
    );
  }

  /// `Error while extending video: {e}`
  String errortypeextendingVideo(Object e) {
    return Intl.message(
      'Error while extending video: $e',
      name: 'errortypeextendingVideo',
      desc: '',
      args: [e],
    );
  }

  /// `Generating... Current state {state}`
  String generatingstate(Object state) {
    return Intl.message(
      'Generating... Current state $state',
      name: 'generatingstate',
      desc: '',
      args: [state],
    );
  }

  /// `Video ready! Playing...`
  String get videoReadyPlaying {
    return Intl.message(
      'Video ready! Playing...',
      name: 'videoReadyPlaying',
      desc: '',
      args: [],
    );
  }

  /// `Error retrieving video URL. Retrying...`
  String get errorretrievingUrl {
    return Intl.message(
      'Error retrieving video URL. Retrying...',
      name: 'errorretrievingUrl',
      desc: '',
      args: [],
    );
  }

  /// `Completed, but no video URL found. Retrying...`
  String get readybutnotfound {
    return Intl.message(
      'Completed, but no video URL found. Retrying...',
      name: 'readybutnotfound',
      desc: '',
      args: [],
    );
  }

  /// `Video generation failed: {failReason}`
  String videogenerationFailed(Object failReason) {
    return Intl.message(
      'Video generation failed: $failReason',
      name: 'videogenerationFailed',
      desc: '',
      args: [failReason],
    );
  }

  /// `Error checking status (retrying...)`
  String get erroeCheckingStatus {
    return Intl.message(
      'Error checking status (retrying...)',
      name: 'erroeCheckingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Generation timed out. Please try again.`
  String get generationTimeOut {
    return Intl.message(
      'Generation timed out. Please try again.',
      name: 'generationTimeOut',
      desc: '',
      args: [],
    );
  }

  /// `House`
  String get house {
    return Intl.message('House', name: 'house', desc: '', args: []);
  }

  /// `River`
  String get riverSimulationScreen {
    return Intl.message(
      'River',
      name: 'riverSimulationScreen',
      desc: '',
      args: [],
    );
  }

  /// `Video is loading...`
  String get videoLoading {
    return Intl.message(
      'Video is loading...',
      name: 'videoLoading',
      desc: '',
      args: [],
    );
  }

  /// `Please select either House or River.`
  String get pleaseSelectRiverorHouse {
    return Intl.message(
      'Please select either House or River.',
      name: 'pleaseSelectRiverorHouse',
      desc: '',
      args: [],
    );
  }

  /// `Please select an image first.`
  String get pleaseSelectImage {
    return Intl.message(
      'Please select an image first.',
      name: 'pleaseSelectImage',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get generate {
    return Intl.message('Generate', name: 'generate', desc: '', args: []);
  }

  /// `No generation ID found.`
  String get noIDFound {
    return Intl.message(
      'No generation ID found.',
      name: 'noIDFound',
      desc: '',
      args: [],
    );
  }

  /// `Extend Generate`
  String get extendGenerate {
    return Intl.message(
      'Extend Generate',
      name: 'extendGenerate',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get settings {
    return Intl.message('Setting', name: 'settings', desc: '', args: []);
  }

  /// `Select Rivers`
  String get buttonSettingSelectRiver {
    return Intl.message(
      'Select Rivers',
      name: 'buttonSettingSelectRiver',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Here are some sites to learn more about flooding:`
  String get advicetext {
    return Intl.message(
      'Here are some sites to learn more about flooding:',
      name: 'advicetext',
      desc: '',
      args: [],
    );
  }

  /// `Flood Safety`
  String get floodSafety {
    return Intl.message(
      'Flood Safety',
      name: 'floodSafety',
      desc: '',
      args: [],
    );
  }

  /// `During a Flood`
  String get duringAFlood {
    return Intl.message(
      'During a Flood',
      name: 'duringAFlood',
      desc: '',
      args: [],
    );
  }

  /// `Add New River`
  String get addNew {
    return Intl.message('Add New River', name: 'addNew', desc: '', args: []);
  }

  /// `Name of the River`
  String get nameRiver {
    return Intl.message(
      'Name of the River',
      name: 'nameRiver',
      desc: '',
      args: [],
    );
  }

  /// `Please add the name of the river`
  String get plsAddRiverName {
    return Intl.message(
      'Please add the name of the river',
      name: 'plsAddRiverName',
      desc: '',
      args: [],
    );
  }

  /// `State/Province`
  String get stateoProvince {
    return Intl.message(
      'State/Province',
      name: 'stateoProvince',
      desc: '',
      args: [],
    );
  }

  /// `Please add state/province`
  String get plsAddStateProvince {
    return Intl.message(
      'Please add state/province',
      name: 'plsAddStateProvince',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get countryform {
    return Intl.message('Country', name: 'countryform', desc: '', args: []);
  }

  /// `Please add country`
  String get plsAddcountry {
    return Intl.message(
      'Please add country',
      name: 'plsAddcountry',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message('Latitude', name: 'latitude', desc: '', args: []);
  }

  /// `Please enter a valid latitude`
  String get plsAddLatitude {
    return Intl.message(
      'Please enter a valid latitude',
      name: 'plsAddLatitude',
      desc: '',
      args: [],
    );
  }

  /// `Length`
  String get length {
    return Intl.message('Length', name: 'length', desc: '', args: []);
  }

  /// `Please enter a valid Length`
  String get plsAddLenght {
    return Intl.message(
      'Please enter a valid Length',
      name: 'plsAddLenght',
      desc: '',
      args: [],
    );
  }

  /// `River added successfully`
  String get riverAdded {
    return Intl.message(
      'River added successfully',
      name: 'riverAdded',
      desc: '',
      args: [],
    );
  }

  /// `Error adding river: {e}`
  String errorAddingRiver(Object e) {
    return Intl.message(
      'Error adding river: $e',
      name: 'errorAddingRiver',
      desc: '',
      args: [e],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `⚠️Warning: HIGH Risk⚠️`
  String get notification {
    return Intl.message(
      '⚠️Warning: HIGH Risk⚠️',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Pay attention to the recommendations of local authorities`
  String get description {
    return Intl.message(
      'Pay attention to the recommendations of local authorities',
      name: 'description',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
