import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
