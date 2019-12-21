import 'package:data_application/activity/home.dart';
import 'package:data_application/activity/register.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _auth= AuthService();

  String reply;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String  token;
  SharedPreferences prefs;
  String _mobile, _password;
  var map, ownerMap;
  bool     passwordVisible = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();
    passwordVisible = false;

  }
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        token = prefs.getString(UserPreferences.USER_FCM);
        userId = prefs.getString(UserPreferences.USER_ID);
    });
  }
  void _submitTask() async{
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      CustomProgressLoader.showLoader(context);

      dynamic result = await _auth.signInWithEmailAndPassword(_mobile, _password) ;
      if(result== null) {
        CustomProgressLoader.cancelLoader(context);

        Fluttertoast.showToast(
            msg:
            Constants.INCORRECT_PASSWORD,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);

      }else{
        CustomProgressLoader.cancelLoader(context);


        prefs = await SharedPreferences.getInstance();
        prefs.setString(UserPreferences.USER_ID, result.uid);
        prefs.setString(UserPreferences.USER_EMAIL, _mobile);
        prefs.setString(UserPreferences.LOGIN_STATUS, "TRUE");
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) => Home()));
      }

      /*try {
        String url =Constants.BASE_URL +Constants.LOGIN_URL;
        Map map = {
          "Password":_password,
          "Email":_mobile,
          "device_id":token,
        };
        print('USER_FCM ${map}');

        apiRequest(url, map);
      } catch (e) {
        print(e.toString());
      }*/
    }
  }



  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
    final createLable = FlatButton(
      child: Text(
        'create account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
          Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) => Registration()));
      },
    );
    return /*new WillPopScope(
        onWillPop: _onWillPop,

        child:*/new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
      //  leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
        /*  Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new StartScreen(),
          ));*/
     //   }),
        automaticallyImplyLeading: false,

        title: Text(Constants.LOGIN_PAGE),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                   TextFormField(
                  decoration: InputDecoration(labelText: Constants.EMAIL_HINT),
                  validator: (valueMobile) =>
              //    valueMobile.length == 0 ? 'Please Enter Email' : null,
                     !valueMobile.contains('@') ? Constants.EMAIL_VALIDATION : null,
                  onSaved: (valueMobile) => _mobile = valueMobile,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(

                  decoration: InputDecoration(labelText: Constants.PASSWORD_HINT
                 , // Here is key idea
                   ),
                  validator: (valuePassword) =>
                  valuePassword.length < 6 ? Constants.PASSWORD_VALIDATION : null,
                  onSaved: (valuePassword) => _password = valuePassword,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                   new Container(
                  child: new SizedBox(
                      width: double.infinity,
                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: _submitTask,
                      textColor: Colors.white,
                      child: new Text(Constants.LOGIN_BUTTON),
                      color: Colors.green,
                      padding: new EdgeInsets.all(20.0),
                    ),
                    ),
                    margin: new EdgeInsets.only(top: 25)
                ),
                SizedBox(height: 48.0),
                createLable
              ],
            ),
          ),
        ),
      ),
    //  ),
    );
  }
}