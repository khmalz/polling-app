import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/data/constant/color.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primary,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 100,
              child: Icon(
                Icons.poll,
                size: 100,
              ),
            ),
            SizedBox(height: 80),
            CircularProgressIndicator(
              color: Colors.white,
              strokeAlign: 5,
            ),
          ],
        ),
      ),
    );
  }
}
