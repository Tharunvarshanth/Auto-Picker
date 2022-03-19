import 'package:auto_picker/components/pages/splash_page.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/notification_service_imple.dart';
import 'package:auto_picker/services/push_messaging_service.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get_it/get_it.dart';
import 'services/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var firebaseMessagingService = PushMessagingSerivce();
  firebaseMessagingService.mainFCMDeviceToken();
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingService.backgroundMessageListener());

//Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("9118dd3d-282d-42e6-b3a2-78b5bee6c5a0");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  HydratedBlocOverrides.runZoned(() => runApp(MyApp()), storage: storage);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MyAppBoot();
  }
}

class MyAppBoot extends StatefulWidget {
  @override
  _MyAppBootState createState() => _MyAppBootState();
}

class _MyAppBootState extends State<MyAppBoot> {
  final _notificationService = NotificationServiceImpl();

  void initState() {
    super.initState();
    _notificationService.init(_onDidReceiveLocalNotification);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print("foreground ${message.notification.body}");
    });
  }

  Future<dynamic> _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(title ?? ''),
                content: Text(body ?? ''),
                actions: [
                  TextButton(
                      child: Text("Ok"),
                      onPressed: () async {
                        _notificationService
                            .handleApplicationWasLaunchedFromNotification(
                                payload ?? '');
                      })
                ]));
  }

  void showNotification() {}
  void _onClearNotifications() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      initialRoute: RouteGenerator.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: RouteGenerator.key,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', 'LK')],
      title: 'Auto Picker',
      theme: ThemeData(
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 72.0,
                fontWeight: FontWeight.bold),
            headline6:
                TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w500),
            bodyText2:
                TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Mulish'),
          ),
          fontFamily: 'Mulish',
          primaryColor: AppColors.primaryVariant),
      home: SplashScreen(),
    );
  }
}
