import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:polling_app/app/data/helper/snackbar_notification.dart';
import 'dart:io';

import 'package:polling_app/app/routes/app_pages.dart';

class PostController extends GetxController {
  var imageFile = Rx<File?>(null);
  var isLoading = false.obs;
  final picker = ImagePicker();
  TextEditingController description = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  Future<String?> uploadImage() async {
    if (imageFile.value != null) {
      try {
        String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(imageFile.value!);

        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        debugPrint(
            'Image uploaded SUCCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS: $imageUrl');
        return imageUrl;
      } catch (e) {
        debugPrint('Error uploading image: $e');
        snackbarNotification(message: 'Failed to upload image');
        isLoading.value = false;
        return null;
      }
    } else {
      snackbarNotification(message: 'Please select an image');
      return null;
    }
  }

  Future<void> createPost() async {
    if (description.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String? imageUrl = await uploadImage();

        await FirebaseFirestore.instance.collection('posts').add({
          'description': description.text,
          'imageUrl': imageUrl,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        Get.offAllNamed(Routes.HOME);

        snackbarNotification(
          message: 'Post created successfully',
          backgroundColor: Colors.green,
        );

        // Reset form
        description.clear;
        imageFile.value = null;
      } catch (e) {
        snackbarNotification(message: 'Failed to create post: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      snackbarNotification(message: 'Please provide a description');
    }
  }
}
