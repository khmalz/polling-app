import 'package:get/get.dart';
import 'package:polling_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:polling_app/app/modules/timeline/controllers/timeline_controller.dart';
import 'package:polling_app/app/modules/post/controllers/post_controller.dart';

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
    if (index == 0) {
      Get.put(TimelineController());
    } else if (index == 1) {
      Get.put(PostController());
    } else if (index == 2) {
      Get.put(ProfileController());
    }
  }

  void onTabChanged(int index) {
    if (currentIndex.value != index) {
      if (currentIndex.value == 0) {
        Get.delete<TimelineController>();
      } else if (currentIndex.value == 1) {
        Get.delete<PostController>();
      } else if (currentIndex.value == 2) {
        Get.delete<ProfileController>();
      }
      initController(index);
    }

    currentIndex.value = index;
  }
}
