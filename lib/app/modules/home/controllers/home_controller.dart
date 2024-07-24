import 'package:get/get.dart';
import 'package:polling_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:polling_app/app/modules/timeline/controllers/timeline_controller.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initController(currentIndex.value);
  }

  void setInitialIndex(int index) {
    currentIndex.value = index;
    initController(index);
  }

  void initController(int index) {
    if (!Get.isRegistered<TimelineController>() && (index == 0 || index == 1)) {
      Get.put(TimelineController());
    } else if (!Get.isRegistered<ProfileController>() && index == 2) {
      Get.put(ProfileController());
    }
  }

  void onTabChanged(int index) {
    if (currentIndex.value != index) {
      if (currentIndex.value == 0 || currentIndex.value == 1) {
        Get.delete<TimelineController>(force: true);
      } else if (currentIndex.value == 2) {
        Get.delete<ProfileController>(force: true);
      }
      initController(index);
    }

    currentIndex.value = index;
  }
}
