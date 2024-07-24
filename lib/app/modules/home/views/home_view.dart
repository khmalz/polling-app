import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/modules/post/views/post_view.dart';
import 'package:polling_app/app/modules/profile/views/profile_view.dart';
import 'package:polling_app/app/modules/timeline/views/timeline_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return const TimelineView();
          case 1:
            return const PostView();
          case 2:
            return const ProfileView();
          default:
            return const TimelineView();
        }
      }),
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

            /// Create Post
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.add_box_outlined,
                size: 30,
              ),
              title: const Text("Add Post"),
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
