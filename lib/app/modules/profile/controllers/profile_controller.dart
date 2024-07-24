import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/helper/snackbar_notification.dart';
import 'package:polling_app/app/data/helper/validate_string.dart';
import 'package:polling_app/app/data/models/user_model.dart' as model;
import 'package:polling_app/app/modules/home/controllers/home_controller.dart';
import 'package:polling_app/app/modules/home/views/home_view.dart';
import 'package:polling_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  Rx<model.User> authData = model.User().obs;
  RxBool isClickLogout = false.obs;

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data()! as Map<String, dynamic>;
        userData['id'] = uid;

        model.User userM = model.User.fromJson(userData);

        authData.value = userM;
      } else {
        throw Exception('User not found');
      }
    } catch (error) {
      throw Exception('Error fetching user data: $error');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  RxBool isLoading = false.obs;
  late TextEditingController usernameInput =
      TextEditingController(text: authData.value.username);
  Rxn<String> errorUsername = Rxn<String>(null);

  bool validateUsername() {
    return validateString(
      text: usernameInput.text.trim(),
      minLength: 3,
      maxLength: 10,
      errorMessage: errorUsername,
      emptyMessage: 'Username cannot be empty',
      minLengthMessage: 'Username must be at least 3 characters',
      maxLengthMessage: 'Username must be at most 10 characters',
    );
  }

  late TextEditingController passwordOldInput = TextEditingController();
  late TextEditingController passwordNewInput = TextEditingController();
  Rxn<String> errorPasswordOld = Rxn<String>(null);
  Rxn<String> errorPasswordNew = Rxn<String>(null);

  RxBool isHidePasswordOld = true.obs;
  RxBool isHidePasswordNew = true.obs;

  bool validateNewPassword() {
    return validateString(
      text: passwordNewInput.text,
      minLength: 6,
      errorMessage: errorPasswordNew,
      emptyMessage: 'New password cannot be empty',
      minLengthMessage: 'New password must be at least 6 characters',
    );
  }

  Future<void> changePassword() async {
    String passwordOld = passwordOldInput.text.trim();
    String passwordNew = passwordNewInput.text.trim();

    User user = FirebaseAuth.instance.currentUser!;

    isLoading.value = true;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: authData.value.email!,
        password: passwordOld,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(passwordNew);

      debugPrint("Successfully changed password");

      clearInput();
      snackbarNotification(
        message: 'Password changed successfully',
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1, milliseconds: 500),
      );
    } on FirebaseAuthException catch (error) {
      String? errorMessage = error.code;
      debugPrint("Password can't be changed: ${error.code}");

      switch (error.code) {
        case "invalid-credential":
          errorMessage = "Invalid credential. Please check and try again.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

      snackbarNotification(
        message: errorMessage,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1, milliseconds: 500),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearInput() {
    usernameInput.clear();
    errorUsername.value = null;

    passwordOldInput.clear();
    passwordNewInput.clear();

    errorPasswordOld.value = null;
    errorPasswordNew.value = null;
  }
}
