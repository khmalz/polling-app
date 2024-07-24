import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/data/constant/color.dart';
import 'package:polling_app/app/modules/profile/controllers/profile_controller.dart';

class PasswordProfileEditView extends GetView<ProfileController> {
  const PasswordProfileEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganti Kata Sandi'),
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
                    obscureText: controller.isHidePasswordOld.value,
                    controller: controller.passwordOldInput,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      suffixIcon: controller.isHidePasswordOld.value
                          ? IconButton(
                              onPressed: () =>
                                  controller.isHidePasswordOld.value = false,
                              icon: const Icon(Icons.visibility_off),
                            )
                          : IconButton(
                              onPressed: () =>
                                  controller.isHidePasswordOld.value = true,
                              icon: const Icon(Icons.visibility),
                            ),
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
                      labelText: 'Old Password',
                      labelStyle: TextStyle(
                        color: controller.errorPasswordOld.value == null
                            ? Colors.grey.shade600
                            : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      errorText: controller.errorPasswordOld.value,
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(
                () => Material(
                  elevation: 5,
                  shadowColor: textPrimary,
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    obscureText: controller.isHidePasswordNew.value,
                    controller: controller.passwordNewInput,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      suffixIcon: controller.isHidePasswordNew.value
                          ? IconButton(
                              onPressed: () =>
                                  controller.isHidePasswordNew.value = false,
                              icon: const Icon(Icons.visibility_off),
                            )
                          : IconButton(
                              onPressed: () =>
                                  controller.isHidePasswordNew.value = true,
                              icon: const Icon(Icons.visibility),
                            ),
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
                      labelText: 'New Password',
                      labelStyle: TextStyle(
                        color: controller.errorPasswordNew.value == null
                            ? Colors.grey.shade600
                            : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      errorText: controller.errorPasswordNew.value,
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (value) => controller.validateNewPassword(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    controller.isLoading.value
                        ? 'Loading...'
                        : 'Change Password',
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
