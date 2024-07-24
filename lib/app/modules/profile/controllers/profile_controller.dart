import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/helper/snackbar_notification.dart';
import 'package:polling_app/app/data/helper/validate_string.dart';
import 'package:polling_app/app/data/models/user_model.dart' as model;
import 'package:polling_app/app/modules/home/controllers/home_controller.dart';
import 'package:polling_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  RxBool isClickLogout = false.obs;
  Rx<model.User> authData = model.User().obs;

  void fetchUserData(User firebaseUser) {
    authData.value = model.User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  RxBool isLoading = false.obs;
  late TextEditingController nameInput =
      TextEditingController(text: authData.value.name);
  Rxn<String> errorName = Rxn<String>(null);

  bool validateName() {
    return validateString(
      text: nameInput.text.trim(),
      minLength: 3,
      maxLength: 100,
      errorMessage: errorName,
      emptyMessage: 'Name cannot be empty',
      minLengthMessage: 'Name must be at least 3 characters',
      maxLengthMessage: 'Name must be at most 100 characters',
    );
  }

  Future<void> changeProfile() async {
    String name = nameInput.text.trim();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      isLoading.value = true;
      try {
        await user.updateDisplayName(name);
        await user.reload();
        User? updatedUser = FirebaseAuth.instance.currentUser;

        authData.value = model.User(
          id: updatedUser?.uid,
          name: updatedUser?.displayName,
          email: updatedUser?.email,
        );

        snackbarNotification(
          message: "Profile updated successfully",
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1, milliseconds: 500),
        );
      } on FirebaseAuthException catch (e) {
        snackbarNotification(
          message: e.message ?? 'An error occurred, please try again',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1, milliseconds: 500),
        );
      } finally {
        isLoading.value = false;

        Get.put(HomeController());
      }
    }
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

      Get.put(HomeController());
    }
  }

  void clearInput() {
    nameInput.clear();
    errorName.value = null;

    passwordOldInput.clear();
    passwordNewInput.clear();

    errorPasswordOld.value = null;
    errorPasswordNew.value = null;
  }
}
