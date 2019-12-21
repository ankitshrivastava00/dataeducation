import 'package:data_application/activity/login.dart';
import 'package:data_application/activity/notification_list.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  String name,email,id,token;
  AuthService auth = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();

  }
  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString(UserPreferences.USER_EMAIL);
      id = prefs.getString(UserPreferences.USER_ID);
       token= prefs.getString(UserPreferences.USER_FCM);

    }
    );
  }
  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
    return new Scaffold(
      appBar: AppBar(
     actions: <Widget>[
       IconButton(
         icon: Icon(Icons.notification_important),
         onPressed: () {
           Navigator.push(context,
               new MaterialPageRoute(builder: (BuildContext context) => NotificationList()));         },
       ),
       IconButton(
         icon: Icon(Icons.power_settings_new),
         onPressed: () async{
           await auth.signOut();
           prefs = await SharedPreferences.getInstance();
           prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
           Navigator.pushReplacement(context,
               new MaterialPageRoute(builder: (BuildContext context) => Login()));         },
       )

     ],
        automaticallyImplyLeading: false,
        title: Text(Constants.APPLICATION_NAME),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body:
         Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Center(
            child:new Text('Welcome ${Constants.APPLICATION_NAME}')),
      ),
    );
  }
}