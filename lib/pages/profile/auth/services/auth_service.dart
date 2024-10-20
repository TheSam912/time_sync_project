import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Widgets/custom_snackbar.dart';

class AuthService {
  ///instance of firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  User? getCurrentUse() {
    return _auth.currentUser;
  }

  /// SingIn Future
  Future<UserCredential> signInWithEmailPassword(email, password, context) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      ///save user info if it's not already exist !!!
      fireStore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          customSnackBar(context, "This Email Already Taken ! Please Login In");
        } else if (error.code == "ERROR_WEAK_PASSWORD") {
          customSnackBar(context, "Your Password Not Strong Enough !!");
        } else if (error.code == "ERROR_INVALID_EMAIL") {
          customSnackBar(context, "The Email Address Not Valid !");
        } else {
          customSnackBar(context, error.message);
        }
      }
      throw Exception(error);
    }
  }

  /// SingUp Future
  Future<String?> signUpWithEmailPassword(email, password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      ///save user info in separate doc
      fireStore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential.credential?.providerId.toString();
    } on FirebaseAuthException catch (e) {
      customSnackBar(context, e.message.toString());
    }
    return null;
  }

  ///SignOut Future
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
