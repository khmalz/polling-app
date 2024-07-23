import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/models/user_model.dart' as model;

class ProfileController extends GetxController {
  var coba = "aha";
  Rx<model.User> _authData = model.User().obs;

  model.User get authData => _authData.value;

  @override
  void onReady() {
    super.onReady();
    debugPrint("jalan ga kocak");

    getUser();
  }

  Future<model.User?> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final User? user = auth.currentUser;

      if (user == null) {
        return Future.error('User not found');
      }

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data()! as Map<String, dynamic>;
        userData['id'] = user.uid;

        model.User userM = model.User.fromJson(userData);

        debugPrint(userM.toString());

        _authData.value = userM;

        return userM;
      } else {
        return Future.error('User not found');
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }
}
