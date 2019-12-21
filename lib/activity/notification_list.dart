import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationList extends StatefulWidget {
  @override
  NotificationListState createState() => NotificationListState();
}

class NotificationListState extends State<NotificationList> {
  String reply = "", status = "";
  String items = "true";
  List<NotificationModel> lis = List();
  var isLoading = false;

  @override
  Future initState() {
    super.initState();
    getData();
  }

  void getData() {
    try{
      setState(() {
        isLoading = true;
      });

      Firestore.instance
          .collection("notification")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) =>
            lis.add(NotificationModel(title: f.data['title'],description: f.data['description'] )));



        setState(() {
          isLoading = false;

        });
      });

    }catch(e){
      print(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    /*  if(lis.length != 0){*/
    return
        Scaffold(
          appBar: AppBar(

            title: Text(Constants.APPLICATION_NAME),
            centerTitle: true,
            backgroundColor: Colors.green,          ),
            body: new Container(
              child:isLoading ? Center(
                  child: new Container(
                    child:
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 5.0,
                      semanticsLabel: 'is Loading',),
                  )
              ):
              ListView.builder(
                  itemCount: lis.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      child: Container(
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          child: Card(
                            child: new Container(
                              margin: EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
                              child: new Row(
                                children: <Widget>[
                                  /*new Container(
                                    child: new Icon(Icons.notifications,
                                    color: Colors.green,),
                                    width: 50.0,
                                    height: 50.0,
                                  ),*/
                                  new Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              '${lis[index].title}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          new Container(
                                            margin:
                                            EdgeInsets.fromLTRB(5.0, 2.0, 0.0, 0.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                             '${lis[index].description}',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),

                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
    );

  }
}
