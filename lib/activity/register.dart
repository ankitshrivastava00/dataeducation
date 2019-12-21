import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/activity/login.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/service/auth.dart';
import 'package:data_application/service/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'home.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  AuthService _auth= AuthService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  String reply;
  TextEditingController passwordMatch = new TextEditingController();
  List<Institute> list = List();

  var isLoading = false;
  List<DropdownMenuItem<Institute>> _dropDownMenuItems;
  Institute _selectedFruit;

  SharedPreferences prefs;

  String _first_name,
      _last_name,
      _mobile,
      _email,
      _password,
      country,
      _confirnm_password,
      _city,
      address1,
      address2,
      _state,
      _lat,
      _long,
      fcm_token,
      _IEMI,
  pincode,
      _deviceId;
  var map, ownerMap;
  bool _isLoading = false;

  void _submit()  {

    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      // fetchData();
      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin();
    }
  }
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fcm_token = prefs.getString(UserPreferences.USER_FCM);
      userId = prefs.getString(UserPreferences.USER_ID);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getSharedPreferences();
  }

  List<DropdownMenuItem<Institute>> buildAndGetDropDownMenuItems(List institute) {
    List<DropdownMenuItem<Institute>> items = new List();
    for (Institute i in institute) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.name),
        ),
      );
    }

    return items;
  }

  void changedDropDownItem(Institute selectedFruit) {
    setState(() {
      _selectedFruit = selectedFruit;
    });
  }
  void getData() {
    try{
    setState(() {
      isLoading = true;
    });

    Firestore.instance
          .collection("insitute")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) =>
           list.add( Institute(id: f.data['id'],name: f.data['name'],city: f.data['city'],state:f.data['state'],country:f.data['country'],pincode:f.data['pincode'] ,address:f.data['address'] )));

            _dropDownMenuItems = buildAndGetDropDownMenuItems(list);

            _selectedFruit = _dropDownMenuItems[0].value;

        setState(() {
          isLoading = false;

        });
      });

    }catch(e){
      print(e.toString());
    }
  }

  void _performLogin() async {
try{
    CustomProgressLoader.showLoader(context);

    dynamic result = await _auth.registerWithEmailAndPassword(_first_name , _last_name,_email, _password,_mobile,address1,address2,_city,_state,country,pincode,_selectedFruit.name,fcm_token) ;
    if(result== null) {
      print("NOR DAATA ");
      CustomProgressLoader.cancelLoader(context);

      Fluttertoast.showToast(
          msg:
          Constants.USER_ALREADY,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{
      CustomProgressLoader.cancelLoader(context);

      Fluttertoast.showToast(
          msg:
          Constants.USER_REGISTER,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      prefs = await SharedPreferences.getInstance();
      prefs.setString(UserPreferences.USER_ID, result.uid);
      prefs.setString(UserPreferences.USER_EMAIL, _email);
      prefs.setString(UserPreferences.LOGIN_STATUS, "TRUE");
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => Home()));

    }
  /*  dynamic result =await _auth.signInAnon();
    if(result==null){
      print("sign in error");
    }else {
      print("sign Succes");
      print("asdfasdf " + result.uid);
    }*/

}catch(e){
print(e.toString());
}
}

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
    return  new WillPopScope(
        onWillPop: _onWillPop,
        child:new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new Login(),
          ));
        }),
        automaticallyImplyLeading: false,

        title: Text(Constants.REGISTRATION_PAGE),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
               child: new Column(
            //padding: EdgeInsets.all(25.0),
            children: <Widget>[
              new Container(
                  //      child: new Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcxx9ypeeGCqaz5GJXY6gMoGIFlfeqKRQvXltqFA66_mSNPHBkPg'),
                  ),
              //   new Image.asset('images/logo.png'),
              new Row(children: <Widget>[
                new Expanded(
                  child:Container(
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: Constants.FIRST_NAME_HINT),
                    validator: (valueName) =>
                        valueName.length <= 0 ? Constants.FIRST_NAME_VALIDATION : null,
                    //   !val.contains('@') ? 'Not a valid email.' : null,
                    onSaved: (valueName) => _first_name = valueName,
                    keyboardType: TextInputType.text,

                  ),
                    margin: EdgeInsets.only(right:8.0),
                ),
                ),
                new Expanded(

                  child:Container(
                    child: TextFormField(

                    decoration: InputDecoration(labelText: Constants.LAST_NAME_HINT),

                    validator: (valueName) =>
                        valueName.length <= 0 ? Constants.LAST_NAME_VALIDATION : null,
                    //   !val.contains('@') ? 'Not a valid email.' : null,
                    onSaved: (valueName) => _last_name = valueName,
                    keyboardType: TextInputType.text,
                  ),
                 //   margin: EdgeInsets.only(left:8.0),
                ),
                ),
              ]),

              TextFormField(
                decoration: InputDecoration(labelText: Constants.EMAIL_HINT),
                validator: (valueEmail) =>
                    //valueEmail.length <= 0 ? 'Enter Your Email' : null,
                    !valueEmail.contains('@') ? Constants.EMAIL_VALIDATION : null,
                onSaved: (valueEmail) => _email = valueEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: Constants.PASSWORD_HINT),
                validator: (valuePassword) =>
                    valuePassword.length < 6 ? Constants.PASSWORD_VALIDATION : null,
                onSaved: (valuePassword) => _password = valuePassword,
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passwordMatch,

              ),
              TextFormField(
                decoration: InputDecoration(labelText: Constants.CONFIRM_PASSWORD_HINT),
                validator: (valueConfirnmPassword) =>
                valueConfirnmPassword.trim() !=   passwordMatch.text.toString().trim()? Constants.CONFIRM_PASSWORD_VALIDATION :null,
                onSaved: (valueConfirnmPassword) => _confirnm_password = valueConfirnmPassword,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: Constants.MOBILE_HINT),
                validator: (valueMobile) =>
                    valueMobile.length < 8 ? Constants.MOBILE_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueMobile) => _mobile = valueMobile,
                keyboardType: TextInputType.phone,
                maxLength: 15,
              ),
  TextFormField(
                decoration: InputDecoration(labelText: Constants.ADDRESS1_HINT),
                validator: (valueAddress) =>
                valueAddress.length <= 0 ? Constants.ADDRESS1_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress) => address1 = valueAddress,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: Constants.ADDRESS2_HINT),
                validator: (valueAddress2) =>
                valueAddress2.length <= 0 ? Constants.ADDRESS2_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress2) => address2 = valueAddress2,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: Constants.CITY_HINT),
                validator: (valuecity) =>
                valuecity.length <= 0 ? Constants.CITY_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valuecity) => _city = valuecity,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: Constants.STATE_HINT),
                validator: (valueState) =>
                valueState.length <= 0 ? Constants.STATE_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueState) => _state = valueState,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: Constants.COUNTRY_HINT),
                validator: (valueCountry) =>
                valueCountry.length <= 0 ? Constants.COUNTRY_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueCountry) => country = valueCountry,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: Constants.PINCODE_HINT),
                validator: (valuePincode) =>
                valuePincode.length < 5 ? Constants.PINCODE_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valuePincode) => pincode = valuePincode,
                keyboardType: TextInputType.number,
    maxLength: 6,
              ),
              new Container(
                //padding:EdgeInsets.all(12.0),
                child: new SizedBox(
                    width: double.infinity,
                    //  child: new Center(
                    child:  new DropdownButton(
                      value: _selectedFruit,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    )
                  // ),
                ),
                // margin: EdgeInsets.only(left: 15.0),
              ),
              // ),
              new Container(
                  child: new SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: _submit,
                      textColor: Colors.white,
                      child: new Text(Constants.REGISTER_BUTTON_HINT),
                      color: Colors.green,
                      padding: new EdgeInsets.all(15.0),
                    ),
                  ),
                  margin: new EdgeInsets.all(15.0)),
            ],
          ),
        ),
        // ),
      ),
      ),
      ),
    );
  }
}
