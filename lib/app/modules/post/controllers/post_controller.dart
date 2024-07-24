import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostController extends GetxController {
  var imageFile = Rx<File?>(null);
  var isLoading = false.obs;
  final picker = ImagePicker();
  TextEditingController description = TextEditingController();

  @override
  void onInit() async {
    String token = await FirebaseAppCheck.instance.getToken() ?? "";
    debugPrint(token);
    super.onInit();
  }

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
        isLoading.value = true;
        String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(imageFile.value!);

        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        debugPrint(
            'Image uploaded SUCCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS: $imageUrl');
        isLoading.value = false;
        return imageUrl;
      } catch (e) {
        debugPrint('Error uploading image: $e');
        isLoading.value = false;
        return null;
      }
    } else {
      debugPrint('No image to upload');
      return null;
    }
  }

  Future<void> createPost() async {
    if (description.text.isNotEmpty) {
      String? imageUrl = await uploadImage();

      if (imageUrl != null) {
        debugPrint(
            'Post created with image SUCCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS: $imageUrl');
      } else {
        debugPrint('Post created without image');
      }

      // Reset the post creation state
      imageFile.value = null;
      description.clear();
    } else {
      debugPrint('Please provide a description');
    }
  }
}
