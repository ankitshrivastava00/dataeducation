import 'package:data_application/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:data_application/common/UserPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'activity/home.dart';
import 'activity/login.dart';
import 'activity/splash_screen.dart';

var flutterLocalNotificationsPlugin;

void main() async {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green,
        primaryColorBrightness: Brightness.dark,
      ),

    routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => new Login(),
      '/home': (BuildContext context) => new Home()
  },
  )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String login_status = 'FALSE',rout='/login';
  SharedPreferences prefs;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getSharedPreferences();

    firebaseCloudMessaging_Listeners();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }


  Future _showNotification(String title,String message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '${title}', '${message}', platformChannelSpecifics,
        payload: 'item x');
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      login_status = prefs.getString(UserPreferences.LOGIN_STATUS);
      if (login_status=='TRUE'){
        rout='/home';
      }else if(login_status=='FALSE'){
        rout='/login';
      }
    }
    );
  }

  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
 Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new Home(),
                ),
              );

            },
          )
        ],
      ),
    );
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print('token_print '+token);

      prefs.setString(UserPreferences.USER_FCM, token);

    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var notification = message['notification'];
        String title = notification['title'];
        String body = notification['body'];
 /* for(var data in message){

      }*/


        _showNotification(title,body);
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        //  _navigateToItemDetail(message);
/*  Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new HomePage(0),
          ),
        );*/

      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        //      _navigateToItemDetail(message);
      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }


  @override
  Widget build(BuildContext context) {

    /*final user = Provider.of<User>(context);
    if(user == null){
      return Center(child:  new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: '/login',
        imageBackground: new AssetImage("images/splash.jpg"),
        backgroundColor: Colors.white,
        photoSize: 100.0,

      ),
        //  loaderColor: Colors.red,
      );
    }else{*/
      return Center(child:  new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: rout,
        imageBackground: new AssetImage("images/splash.jpg"),
        backgroundColor: Colors.white,
        photoSize: 100.0,

      ),
        //  loaderColor: Colors.red,
      );
    }

 // }
}

