import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/modules/profile/views/profile_view.dart';
import 'package:polling_app/app/modules/timeline/views/timeline_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final int initialIndex;

  const HomeView({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    controller.setInitialIndex(initialIndex);

    var listPage = <Widget>[
      const TimelineView(),
      const TimelineView(),
      const ProfileView(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: Obx(() => listPage[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.onTabChanged(index),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite),
              title: const Text("Likes"),
              selectedColor: Colors.pink,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
