import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:polling_app/app/data/helper/snackbar_notification.dart';
import 'package:polling_app/app/data/models/post_model.dart';
import 'package:polling_app/app/modules/timeline/controllers/timeline_controller.dart';
import 'dart:io';

import 'package:polling_app/app/routes/app_pages.dart';

class PostController extends GetxController {
  var imageFile = Rx<File?>(null);
  var isLoading = false.obs;
  final picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;
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
          'userId': user?.uid,
          'userName': user?.displayName,
          'description': description.text,
          'imageUrl': imageUrl,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        // Reset form
        description.clear;
        imageFile.value = null;

        snackbarNotification(
          message: 'Post created successfully',
          backgroundColor: Colors.green,
        );

        Get.offAllNamed(Routes.HOME);
        Get.put(TimelineController());
      } catch (e) {
        snackbarNotification(message: 'Failed to create post: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      snackbarNotification(message: 'Please provide a description');
    }
  }

  RxBool isClickDelete = false.obs;
  RxString postIdDelete = ''.obs;

  var userPosts = <Post>[].obs;

  Future<void> fetchUserPosts() async {
    try {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        debugPrint('User not logged in');
        return;
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      var postData = await Future.wait(snapshot.docs.map((doc) async {
        var post = Post.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        post.votePercentage = await calculateLikePercentage(doc.id);
        return post;
      }).toList());

      userPosts.assignAll(postData);
      debugPrint(userPosts.toString());
    } catch (e) {
      debugPrint('Error fetching user posts: $e');
    }
  }

  Future<double> calculateLikePercentage(String postId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('actions')
          .where('postId', isEqualTo: postId)
          .get();

      int likeCount = 0;
      int unlikeCount = 0;

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['isLiked'] == true) {
          likeCount++;
        } else if (data['isUnliked'] == true) {
          unlikeCount++;
        }
      }

      int totalActions = likeCount + unlikeCount;
      if (totalActions == 0) {
        return 0.0;
      } else {
        return (likeCount / totalActions) * 100;
      }
    } catch (e) {
      debugPrint('Error calculating like percentage: $e');
      return 0.0;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      isLoading.value = true;

      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();

      if (postSnapshot.exists) {
        Map<String, dynamic> postData =
            postSnapshot.data() as Map<String, dynamic>;
        String? imageUrl = postData['imageUrl'];

        // Delete post and associated actions
        await _deletePostAndActions(postId);

        // Delete image from Firebase Storage if it exists
        if (imageUrl != null && imageUrl.isNotEmpty) {
          await _deleteImageFromStorage(imageUrl);
        }

        // Remove post from local list
        userPosts.removeWhere((post) => post.id == postId);
        isLoading.value = false;
        update();

        debugPrint('Post deleted successfully');
        snackbarNotification(
          message: 'Post deleted successfully',
          backgroundColor: Colors.green,
        );
      } else {
        isLoading.value = false;
        debugPrint('Post not found');
        snackbarNotification(
            message: 'Post not found', backgroundColor: Colors.red);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error deleting post: $e');
      snackbarNotification(
          message: 'Error deleting post', backgroundColor: Colors.red);
    }
  }

  Future<void> _deletePostAndActions(String postId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);
    batch.delete(postRef);

    var actionsSnapshot = await FirebaseFirestore.instance
        .collection('actions')
        .where('postId', isEqualTo: postId)
        .get();

    for (var doc in actionsSnapshot.docs) {
      DocumentReference actionRef =
          FirebaseFirestore.instance.collection('actions').doc(doc.id);
      batch.delete(actionRef);
    }

    // Commit the batch
    await batch.commit();
  }

  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await imageRef.delete();
      debugPrint('Image deleted successfully');
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }
}
