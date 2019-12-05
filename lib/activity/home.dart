import 'package:data_application/activity/login.dart';
import 'package:data_application/activity/register.dart';
import 'package:data_application/common/Connectivity.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/service/auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  String name,email,id;
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

    }
    );
  }
  @override
  Widget build(BuildContext context) {

    return new  Scaffold(
      appBar: AppBar(
     actions: <Widget>[
       FlatButton.icon(onPressed: () async{
         await auth.signOut();
         prefs = await SharedPreferences.getInstance();
         prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
         Navigator.pushReplacement(context,
             new MaterialPageRoute(builder: (BuildContext context) => Login()));

       }, icon: Icon(Icons.power_settings_new), label:Text('Logout'))
     ],
        automaticallyImplyLeading: false,

        title: Text('Home'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('${email}'),
            SizedBox(height: 48.0),
            Text('${id}'),


          ],
        )
      ),
    //  ),
    );
  }
}