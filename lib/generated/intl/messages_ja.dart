// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(uploadedUrl) => "アップロードされた画像のURL: ${uploadedUrl}";

  static String m1(comment) => "コメント ${comment}";

  static String m2(country) => "国: ${country}";

  static String m3(date) => "日付と時間 ${date}";

  static String m4(errorMsg) => "ビデオの拡張エラー: ${errorMsg}";

  static String m5(errorMsg) => "生成開始エラー: ${errorMsg}";

  static String m6(e) => "アップロードまたは生成エラー: ${e}";

  static String m7(e) => "ビデオ拡張中のエラー: ${e}";

  static String m8(state) => "生成中... 現在の状態 ${state}";

  static String m9(generationId) => "ビデオ生成が開始されました。ID: ${generationId}";

  static String m10(humidity) => "湿度: ${humidity}";

  static String m11(precipitationTotal) => "降水量: ${precipitationTotal}";

  static String m12(precipitationIntensity) => "降水強度: ${precipitationIntensity}";

  static String m13(precipitacionProbability) => "降水確率: ${precipitacionProbability}";

  static String m14(risk) => "リスク ${risk}";

  static String m15(spi) => "SPI: ${spi}";

  static String m16(temperature) => "温度: ${temperature}";

  static String m17(newId) => "拡張ビデオ生成が開始されました。ID: ${newId}";

  static String m18(failReason) => "ビデオ生成失敗: ${failReason}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "DEFAULT": MessageLookupByLibrary.simpleMessage("不明"),
    "HIGH": MessageLookupByLibrary.simpleMessage("高い"),
    "LOW": MessageLookupByLibrary.simpleMessage("低い"),
    "MEDIUM": MessageLookupByLibrary.simpleMessage("中"),
    "UploadedImgUrl": m0,
    "UploadingImg": MessageLookupByLibrary.simpleMessage("画像をアップロード中..."),
    "closeMapScreen": MessageLookupByLibrary.simpleMessage("閉じる"),
    "commentMapScreen": m1,
    "commentSelectorPostScreen": MessageLookupByLibrary.simpleMessage("コメント"),
    "country": m2,
    "date": MessageLookupByLibrary.simpleMessage("日付"),
    "dateandtime": m3,
    "erroeCheckingStatus": MessageLookupByLibrary.simpleMessage("ステータスチェックエラー (再試行中...)"),
    "errorExtendingVideo": m4,
    "errorGeneration": m5,
    "errorhasocured": MessageLookupByLibrary.simpleMessage("エラーが発生しました"),
    "errorretrievingUrl": MessageLookupByLibrary.simpleMessage("ビデオURLの取得エラー。再試行中..."),
    "errortype": m6,
    "errortypeextendingVideo": m7,
    "extendGenerate": MessageLookupByLibrary.simpleMessage("ビデオを拡張"),
    "firstSelectaRiver": MessageLookupByLibrary.simpleMessage("最初に川を選択してください"),
    "generate": MessageLookupByLibrary.simpleMessage("生成"),
    "generatingstate": m8,
    "generationStarted": m9,
    "generationTimeOut": MessageLookupByLibrary.simpleMessage("生成タイムアウト。再試行してください。"),
    "hello": MessageLookupByLibrary.simpleMessage("こんにちは"),
    "house": MessageLookupByLibrary.simpleMessage("家"),
    "humidity": m10,
    "imageCouldntbeloaded": MessageLookupByLibrary.simpleMessage("画像を読み込めませんでした"),
    "imageSelectorPostScreen": MessageLookupByLibrary.simpleMessage("画像"),
    "imagenotselected": MessageLookupByLibrary.simpleMessage("画像が選択されていません"),
    "locationdenied": MessageLookupByLibrary.simpleMessage("位置情報の許可が拒否されました"),
    "locationisturnedoff": MessageLookupByLibrary.simpleMessage("位置情報サービスがオフになっています"),
    "locationpermissionspermanently": MessageLookupByLibrary.simpleMessage("位置情報の許可が永続的に拒否されました。設定から有効にしてください"),
    "map": MessageLookupByLibrary.simpleMessage("マップ"),
    "mapScreen": MessageLookupByLibrary.simpleMessage("マップ画面"),
    "moreInfo": MessageLookupByLibrary.simpleMessage("もっと情報"),
    "noForecastData": MessageLookupByLibrary.simpleMessage("予報データがありません"),
    "noIDFound": MessageLookupByLibrary.simpleMessage("生成IDが見つかりませんでした"),
    "noImgSelected": MessageLookupByLibrary.simpleMessage("画像が選択されていません"),
    "noName": MessageLookupByLibrary.simpleMessage("名前なし"),
    "noStationData": MessageLookupByLibrary.simpleMessage("データがありません"),
    "pleaseSelectImage": MessageLookupByLibrary.simpleMessage("最初に画像を選択してください"),
    "pleaseSelectOne": MessageLookupByLibrary.simpleMessage("1つだけ選択してください"),
    "pleaseSelectRiverorHouse": MessageLookupByLibrary.simpleMessage("家か川を選んでください"),
    "pleaseselectimage": MessageLookupByLibrary.simpleMessage("画像を選んでください"),
    "post": MessageLookupByLibrary.simpleMessage("投稿"),
    "postPostScreen": MessageLookupByLibrary.simpleMessage("投稿"),
    "postScreen": MessageLookupByLibrary.simpleMessage("投稿画面"),
    "precipation": m11,
    "precipitationIntensity": m12,
    "precipitationProbability": m13,
    "readybutnotfound": MessageLookupByLibrary.simpleMessage("完了しましたが、ビデオURLが見つかりませんでした。再試行中..."),
    "requestVideo": MessageLookupByLibrary.simpleMessage("拡張ビデオをリクエストしています..."),
    "risk": MessageLookupByLibrary.simpleMessage("リスク予測"),
    "riskRiskScreen": m14,
    "riskScreen": MessageLookupByLibrary.simpleMessage("流出予測"),
    "riverPostScreen": MessageLookupByLibrary.simpleMessage("川"),
    "riverSelectorPostScreen": MessageLookupByLibrary.simpleMessage("川を選択してください"),
    "riverSimulationScreen": MessageLookupByLibrary.simpleMessage("川シミュレーション"),
    "sendingtoDreamMachine": MessageLookupByLibrary.simpleMessage("Dream Machineにリクエストを送信しています..."),
    "setting": MessageLookupByLibrary.simpleMessage("設定"),
    "simulate": MessageLookupByLibrary.simpleMessage("シミュレーション"),
    "simulationScreen": MessageLookupByLibrary.simpleMessage("シミュレーション画面"),
    "spi": m15,
    "submissioncomplete": MessageLookupByLibrary.simpleMessage("投稿が正常に完了しました！"),
    "temperature": m16,
    "userLocation": MessageLookupByLibrary.simpleMessage("あなたの位置"),
    "videoGenerationStarted": m17,
    "videoLoading": MessageLookupByLibrary.simpleMessage("ビデオが読み込まれています..."),
    "videoReadyPlaying": MessageLookupByLibrary.simpleMessage("ビデオ準備完了！再生中..."),
    "videogenerationFailed": m18,
    "waitingForInput": MessageLookupByLibrary.simpleMessage("入力待ち..."),
    "writecommentSelectorPostScreen": MessageLookupByLibrary.simpleMessage("コメントを書く"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "language": MessageLookupByLibrary.simpleMessage("川を選択"),
    "notifications": MessageLookupByLibrary.simpleMessage("言語"),
    "buttonSettingSelectRiver": MessageLookupByLibrary.simpleMessage("通知"),
    "advicetext": MessageLookupByLibrary.simpleMessage(
      "洪水についてさらに詳しく知るには、次のサイトをご覧ください。",
    ),
    "floodSafety": MessageLookupByLibrary.simpleMessage("洪水に対する安全"),
    "duringAFlood": MessageLookupByLibrary.simpleMessage("洪水の間"),
    "addNew": MessageLookupByLibrary.simpleMessage("新しい川を追加"),
    "nameRiver": MessageLookupByLibrary.simpleMessage("川の名前"),
    "plsAddRiverName": MessageLookupByLibrary.simpleMessage("川の名前を追加してください"),
    "stateoProvince": MessageLookupByLibrary.simpleMessage("州/県"),
    "plsAddStateProvince": MessageLookupByLibrary.simpleMessage("州/県を追加してください"),
    "countryform": MessageLookupByLibrary.simpleMessage("国"),
    "plsAddcountry": MessageLookupByLibrary.simpleMessage("国を追加してください"),
    "latitude": MessageLookupByLibrary.simpleMessage("緯度"),
    "plsAddLatitude": MessageLookupByLibrary.simpleMessage("有効な緯度を入力してください"),
    "length": MessageLookupByLibrary.simpleMessage("長さ"),
    "plsAddLenght": MessageLookupByLibrary.simpleMessage("有効な長さを入力してください"),
    "riverAdded": MessageLookupByLibrary.simpleMessage("川が正常に追加されました"),
    "errorAddingRiver": MessageLookupByLibrary.simpleMessage("川の追加中にエラーが発生しました: {e}"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
  };
}
