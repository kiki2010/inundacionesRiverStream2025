import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';

final FlutterLocalNotificationsPlugin flutterNotificationPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'channel_id',
  'channel_name',
  description: 'Descripción del canal',
  importance: Importance.high,
);

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_riverstream');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterNotificationPlugin.initialize(initializationSettings);

  final AndroidFlutterLocalNotificationsPlugin? androidPlatformChannelSpecifics =
      flutterNotificationPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidPlatformChannelSpecifics?.createNotificationChannel(channel);
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'Descripción del canal',
    importance: Importance.high,
    priority: Priority.max,
    icon: 'ic_stat_riverstream',
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterNotificationPlugin.show(
    1,
    S.current.notification,
    S.current.description,
    notificationDetails,
  );
}