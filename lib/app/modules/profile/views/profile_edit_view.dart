import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/data/constant/color.dart';
import 'package:polling_app/app/modules/profile/controllers/profile_controller.dart';

import 'password_profile_edit_view.dart';

class ProfileEditView extends GetView<ProfileController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          Column(
            children: [
              Obx(
                () => Material(
                  elevation: 5,
                  shadowColor: textPrimary,
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    controller: controller.usernameInput,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: textSecondary,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: controller.errorUsername.value == null
                            ? Colors.grey.shade600
                            : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      errorText: controller.errorUsername.value,
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (value) => controller.validateUsername(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () => Get.to(() => const PasswordProfileEditView()),
                title: const Text(
                  "Ganti Kata Sandi",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: textPrimary,
                  size: 25,
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    controller.isLoading.value ? 'Loading...' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
