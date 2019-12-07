import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/activity/login.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List _fruits = ["RKDF"];
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
    setState(() {
      isLoading = true;
    });
    //setState(() {
      Firestore.instance
          .collection("insitute")
          .getDocuments()
          .then((QuerySnapshot snapshot) {

//            var data1 =snapshot.documents.forEach(f)=>;
  //          data1[0].[''];
        snapshot.documents.forEach((f) =>
           list.add( Institute(f.data['name'], f.data['name'],f.data['name'],f.data['name'],f.data['name'],f.data['name'] )));



            _dropDownMenuItems = buildAndGetDropDownMenuItems(list);

            _selectedFruit = _dropDownMenuItems[0].value;

        setState(() {
          isLoading = false;

        });
       // snapshot.documents.forEach((f) =>_fruits.add('${f.data['name']}'));


      });
    /*  if(isLoading == false){
        _dropDownMenuItems = buildAndGetDropDownMenuItems(_fruits);

        _selectedFruit = _dropDownMenuItems[0].value;

      }*/
     //    });

  }
  void _performLogin() async {

    CustomProgressLoader.showLoader(context);

    dynamic result = await _auth.registerWithEmailAndPassword(_first_name+" "+_last_name,_email, _password,_mobile,address1,address2,_city,_state,country,pincode,_selectedFruit.name) ;
    if(result== null) {
      print("NOR DAATA ");
      CustomProgressLoader.cancelLoader(context);

      Fluttertoast.showToast(
          msg:
          "Please use Diffrent email ID ,User already registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{
      CustomProgressLoader.cancelLoader(context);

      print("Logindg");
      print("asdfasdasdf "+result.uid);
      Fluttertoast.showToast(
          msg:
          "User registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      prefs = await SharedPreferences.getInstance();
      prefs.setString(UserPreferences.USER_ID, result.uid);
      prefs.setString(UserPreferences.USER_EMAIL, _mobile);
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

        title: Text('Registration'),
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
                    decoration: InputDecoration(labelText: 'First Name *'),
                    validator: (valueName) =>
                        valueName.length <= 0 ? 'Enter Your First Name' : null,
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

                    decoration: InputDecoration(labelText: 'Last Name *'),

                    validator: (valueName) =>
                        valueName.length <= 0 ? 'Enter Your Last Name' : null,
                    //   !val.contains('@') ? 'Not a valid email.' : null,
                    onSaved: (valueName) => _last_name = valueName,
                    keyboardType: TextInputType.text,
                  ),
                 //   margin: EdgeInsets.only(left:8.0),
                ),
                ),
              ]),

              TextFormField(
                decoration: InputDecoration(labelText: 'Email *'),
                validator: (valueEmail) =>
                    //valueEmail.length <= 0 ? 'Enter Your Email' : null,
                    !valueEmail.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueEmail) => _email = valueEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password *'),
                validator: (valuePassword) =>
                    valuePassword.length < 6 ? 'Password too short.' : null,
                onSaved: (valuePassword) => _password = valuePassword,
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passwordMatch,

              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password *'),
                validator: (valueConfirnmPassword) =>
                valueConfirnmPassword.trim() !=   passwordMatch.text.toString().trim()?'Password not matched' :null,
                onSaved: (valueConfirnmPassword) => _confirnm_password = valueConfirnmPassword,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile *'),
                validator: (valueMobile) =>
                    valueMobile.length < 8 ? 'Enter Correct Number' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueMobile) => _mobile = valueMobile,
                keyboardType: TextInputType.phone,
                maxLength: 15,
              ),
  TextFormField(
                decoration: InputDecoration(labelText: 'Address 1 *'),
                validator: (valueAddress) =>
                valueAddress.length <= 0 ? 'Enter Address1' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress) => address1 = valueAddress,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: 'Address 2 *'),
                validator: (valueAddress2) =>
                valueAddress2.length <= 0 ? 'Enter Address2' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress2) => address2 = valueAddress2,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: 'City *'),
                validator: (valuecity) =>
                valuecity.length <= 0 ? 'Enter City' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valuecity) => _city = valuecity,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: 'State *'),
                validator: (valueState) =>
                valueState.length <= 0 ? 'Enter State' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueState) => _state = valueState,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: 'Country *'),
                validator: (valueCountry) =>
                valueCountry.length <= 0 ? 'Enter Country' : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueCountry) => country = valueCountry,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: 'Pincode *'),
                validator: (valuePincode) =>
                valuePincode.length < 5 ? 'Enter Correct Pincode' : null,
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
                      child: new Text("REGISTER"),
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
