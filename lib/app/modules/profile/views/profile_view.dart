import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/constant/color.dart';
import 'package:polling_app/app/data/helper/modal.dart';
import '../controllers/profile_controller.dart';
import 'profile_edit_view.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            User? user = snapshot.data;
            controller.fetchUserData(user!);

            return Obx(() {
              if (controller.authData.value.id == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ListTile(
                            onTap: () => Get.to(() => const ProfileEditView()),
                            title: Obx(
                              () => Text(
                                controller.authData.value.name ?? "Guest",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            subtitle: Obx(
                              () => Text(
                                controller.authData.value.email ?? "Guest",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.edit,
                              color: textPrimary,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          color: textPrimary,
                          height: 20,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          // onTap: controller.logout,
                          onTap: () => controller.isClickLogout.value = true,
                          leading: const Icon(
                            Icons.exit_to_app,
                            color: textPrimary,
                            size: 30,
                          ),
                          title: const Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (controller.isClickLogout.value) {
                        return ModalConfirm(
                          controllerVal: controller.isClickLogout,
                          message: "Are you sure you want to logout?",
                          icon: Icons.exit_to_app,
                          onConfirm: controller.logout,
                          onCancel: () =>
                              controller.isClickLogout.value = false,
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ],
                );
              }
            });
          } else {
            return const Center(child: Text("Login Failed"));
          }
        },
      ),
    );
  }
}
