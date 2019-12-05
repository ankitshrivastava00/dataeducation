import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollectiion =Firestore.instance.collection("userslist");

  Future updateUserData(String name) async{

    return await userCollectiion.document(uid).setData({
    'name':name,
    });
  }
}