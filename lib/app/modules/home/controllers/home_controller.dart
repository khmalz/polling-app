import 'package:get/get.dart';
import 'package:polling_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:polling_app/app/modules/timeline/controllers/timeline_controller.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  void setInitialIndex(int index) {
    currentIndex.value = index;
    initController(index);
  }

  void initController(int index) {
    if (index == 0) {
      Get.lazyPut(() => TimelineController());
    } else if (index == 1) {
      Get.lazyPut(() => TimelineController());
    } else if (index == 2) {
      Get.lazyPut(() => ProfileController());
    }
  }

  void onTabChanged(int index) {
    if (currentIndex.value != index) {
      if (currentIndex.value == 0) {
        Get.delete<TimelineController>();
      } else if (currentIndex.value == 1) {
        Get.delete<TimelineController>();
      } else if (currentIndex.value == 2) {
        Get.delete<ProfileController>();
      }
      initController(index);
    }

    currentIndex.value = index;
  }
}
