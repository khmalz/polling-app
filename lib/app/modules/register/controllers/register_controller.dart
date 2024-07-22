import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/helper/snackbar_notification.dart';
import 'package:polling_app/app/data/helper/validate_string.dart';

class RegisterController extends GetxController {
  RxBool isHidePassword = true.obs;
  RxBool isLoading = false.obs;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  Rxn<String> errorEmail = Rxn<String>(null);
  Rxn<String> errorPassword = Rxn<String>(null);

  bool validateEmail() {
    return validateString(
      text: email.text,
      minLength: 10,
      errorMessage: errorEmail,
      emptyMessage: 'Email cannot be empty',
      minLengthMessage: 'Email must be at least 3 characters',
    );
  }

  bool validatePassword() {
    return validateString(
      text: password.text,
      minLength: 6,
      errorMessage: errorPassword,
      emptyMessage: 'Password cannot be empty',
      minLengthMessage: 'Password must be at least 6 characters',
    );
  }

  Future<void> signUp() async {
    bool isValid = true;
    isValid &= validateEmail();
    isValid &= validatePassword();

    String? errorMessage;

    if (!isValid) return;
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      errorMessage = error.code;
      debugPrint(error.code);

      switch (error.code) {
        case "invalid-email":
          errorMessage = "Invalid email. Please check and try again.";
          break;
        case "invalid-credential":
          errorMessage = "Invalid credential. Please check and try again.";
          break;
        case "email-already-in-use":
          errorMessage = "The account already exists for that email.";
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
    }

    if (errorMessage != null) {
      snackbarNotification(message: errorMessage);
    }

    isLoading.value = false;
  }
}
