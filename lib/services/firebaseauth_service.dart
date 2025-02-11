import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthService {

  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  Future<User?> signIn({String? email, String? password}) async {
    try {
      UserCredential ucred = await _fbAuth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      User? user = ucred.user;
      debugPrint("Signed In successful! User ID: ${user?.uid}, User: $user.");
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      debugPrint("Error during sign in: $e");
      return null;
    }
  }

  Future<User?> signUp({String? email, String? password}) async {
    try {
      UserCredential ucred = await _fbAuth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      User? user = ucred.user;
      debugPrint('Signed Up successful! User: $user');
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      debugPrint("Error during sign up: $e");
      return null;
    }
  } 

  Future<void> signOut() async {
    try {
      await _fbAuth.signOut();
      debugPrint('Sign Out successful!');
    } catch (e) {
      debugPrint("Error during sign out: $e");
    }
  }
}
