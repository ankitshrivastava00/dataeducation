import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/model/user.dart';
import 'package:data_application/service/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth auth =FirebaseAuth.instance;
// Create User Model
  User _userFromFirebaseUser(FirebaseUser user){
    return user !=null ? User(uid: user.uid) : null;
  }
  // AUTH CHANGE USER STREAM
  Stream <User >get user{
    return auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //SIGN IN ANON

Future signInAnon()async{
  try{
    AuthResult result = await auth.signInAnonymously();
    FirebaseUser user =result.user;
    return  _userFromFirebaseUser(user);
  }catch(e){
    print(e.toString());
    return null;

  }
}


// SIGNIN WITH EMAIL AND PASSWORD
  Future signInWithEmailAndPassword(String email,String password) async{
    try{
      AuthResult result =await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user =result.user;

    //  await DatabaseService(uid: user.uid).updateUserData("Arjun NAth");
      return _userFromFirebaseUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }


  }
// REGISTER WITH EMAIL AND PASSWORD
  Future registerWithEmailAndPassword(String name,String email,String password,String mobile,String address1,String address2,String city
      ,String state,String country,String pincode,String institute) async{
    try{
AuthResult result =await auth.createUserWithEmailAndPassword(email: email, password: password);
FirebaseUser user =result.user;

if(user!=null) {
  Firestore.instance.collection("userlist").document(user.uid).setData({
    'name': name,
    'email': email,
    'mobile': mobile,
    'city': city,
    'address1': address1,
    'address2': address2,
    'state': state,
    'country': country,
    'pincode': pincode,
    'institute': institute,
  });
}
//await DatabaseService(uid: user.uid).updateUserData("Arjun NAth");
return _userFromFirebaseUser(user);
    }catch (e){
print(e.toString());
return null;
    }
    

  }
// SIGN OUT
Future signOut()async{
try{
return await auth.signOut();
}catch(e)
{
print(e.toString());
return null;
}
}
}