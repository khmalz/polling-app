import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/data/constant/color.dart';
import 'package:polling_app/app/routes/app_pages.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primary,
      ),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 100,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 15, right: 20, left: 20, top: 30),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: textSecondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    shadowColor: textPrimary,
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      // controller: controller.emailLoginInput,
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
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          // color: controller.errorLoginEmail.value == null
                          //     ? Colors.grey.shade600
                          //     : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        // errorText: controller.errorLoginEmail.value,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      // onChanged: (value) => controller.validateLoginEmail(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    elevation: 5,
                    shadowColor: textPrimary,
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      // controller: controller.usernameRegisInput,
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
                        labelStyle: const TextStyle(
                          // color: controller.errorRegisUsername.value == null
                          //     ? Colors.grey.shade600
                          //     : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        // errorText: controller.errorRegisUsername.value,
                      ),
                      keyboardType: TextInputType.name,
                      // onChanged: (value) => controller.validateRegisUsername(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Material(
                      elevation: 5,
                      shadowColor: textPrimary,
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        obscureText: controller.isHidePassword.value,
                        // controller: controller.passwordLoginInput,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: controller.isHidePassword.value
                              ? IconButton(
                                  onPressed: () =>
                                      controller.isHidePassword.value = false,
                                  icon: const Icon(Icons.visibility_off),
                                )
                              : IconButton(
                                  onPressed: () =>
                                      controller.isHidePassword.value = true,
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
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            // color: controller.errorLoginPassword.value == null
                            //     ? Colors.grey.shade600
                            //     : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          // errorText: controller.errorLoginPassword.value,
                        ),
                        keyboardType: TextInputType.name,
                        // onChanged: (value) => controller.validateLoginPassword(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        minimumSize: const Size(150, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        controller.isLoading.value ? 'Loading...' : 'SIGN UP',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: textPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
