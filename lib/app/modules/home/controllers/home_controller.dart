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
      Get.lazyPut(() => TimelineController(), fenix: true);
    } else if (index == 1) {
      Get.lazyPut(() => PostController(), fenix: true);
    } else if (index == 2) {
      Get.lazyPut(() => ProfileController(), fenix: true);
    }
  }

  void onTabChanged(int index) {
    currentIndex.value = index;
    initController(index);
  }
}
