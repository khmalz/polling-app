import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/constant/color.dart';

class ModalWarning extends StatelessWidget {
  const ModalWarning({
    super.key,
    required this.controllerVal,
    required this.message,
    required this.icon,
  });

  final RxBool controllerVal;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controllerVal.value = false,
      child: Stack(
        children: [
          // Latar belakang blur
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), // Gunakan warna transparan
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.4,
                sigmaY: 1.4,
              ), // Efek blur
              child: Container(color: Colors.transparent),
            ),
          ),
          // Konten informasi level terkunci di tengah-tengah
          Positioned.fill(
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModalConfirm extends StatelessWidget {
  const ModalConfirm({
    super.key,
    required this.controllerVal,
    required this.message,
    required this.icon,
    required this.onConfirm,
    required this.onCancel,
  });

  final RxBool controllerVal;
  final String message;
  final IconData icon;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controllerVal.value = false,
      child: Stack(
        children: [
          // Latar belakang blur
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), // Gunakan warna transparan
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.4,
                sigmaY: 1.4,
              ), // Efek blur
              child: Container(color: Colors.transparent),
            ),
          ),
          // Konten informasi level terkunci di tengah-tengah
          Positioned.fill(
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 64,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: textSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text("Yes"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: onCancel,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text("No"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
