import 'package:datascrap/main.dart';
import 'package:datascrap/views/fantasy_players_UI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:datascrap/services/notification.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).initialize();
    super.initState();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotifications);
  void onClickedNotifications(String payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Homepage()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Consumer<NotificationService>(
      builder: (context, model, _) =>
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () => model.instantNofitication(),
            child: Text('Sensors')),
        ElevatedButton(
            onPressed: () => model.imageNotification(),
            child: Text('Robot Alert')),
        ElevatedButton(
            onPressed: () => model.stylishNotification(),
            child: Text('Robot Battery')),
        ElevatedButton(
            onPressed: () => model.sheduledNotification(),
            child: Text('Periodic Check Notification')),
        ElevatedButton(
            onPressed: () => model.cancelNotification(),
            child: Text('Cancel Notification')),
      ]),
    ))));
  }
}

class NotificationsBar extends StatefulWidget {
  @override
  _NotificationsBarState createState() => _NotificationsBarState();
}

class _NotificationsBarState extends State<NotificationsBar> {
  int selectedPage = 0;
  int flag = 1;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Monteserat'),
          home: NotificationPage(),
          debugShowCheckedModeBanner: false,
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => NotificationService())
        ]);
  }
}
