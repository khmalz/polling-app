import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/models/post_model.dart';

class TimelineController extends GetxController {
  var posts = <Post>[].obs;
  var actions = <Map<String, dynamic>>[].obs;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> fetchData() async {
    try {
      await Future.wait([fetchPosts(), fetchActions()]);
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      var postData = snapshot.docs
          .map(
              (doc) => Post.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      posts.assignAll(postData);
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    }
  }

  Future<void> fetchActions() async {
    try {
      actions.clear();
      if (userId != null) {
        QuerySnapshot snapshotAction = await FirebaseFirestore.instance
            .collection('actions')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

        var actionData = snapshotAction.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        actions.assignAll(actionData);

        debugPrint(actions.toString());
      }
    } catch (e) {
      debugPrint('Error fetching actions: $e');
    }
  }

  void likePost(String postId) {
    _handleAction(postId, true, false);
  }

  void unlikePost(String postId) {
    _handleAction(postId, false, true);
  }

  Future<void> _handleAction(
      String postId, bool isLiked, bool isUnliked) async {
    if (userId == null) {
      debugPrint('User not logged in');
      return;
    }

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var existingActionQuery = await FirebaseFirestore.instance
            .collection('actions')
            .where('postId', isEqualTo: postId)
            .where('userId', isEqualTo: userId!)
            .get();

        if (existingActionQuery.docs.isNotEmpty) {
          var existingActionDoc = existingActionQuery.docs.first;
          var existingActionData =
              existingActionDoc.data();

          if ((isLiked && existingActionData['isLiked'] != true) ||
              (isUnliked && existingActionData['isUnliked'] != true)) {
            await _updateAction(postId, isLiked, isUnliked, transaction,
                existingActionDoc.reference);
          } else {
            await _deleteAction(
                postId, userId!, transaction, existingActionDoc.reference);
          }
        } else {
          await _createAction(postId, isLiked, isUnliked, transaction);
        }
      });

      await fetchActions();
      update();
      debugPrint(actions.toString());
    } catch (e) {
      debugPrint('Error handling action in Firestore: $e');
    }
  }

  Future<void> _createAction(String postId, bool isLiked, bool isUnliked,
      Transaction transaction) async {
    var newAction = {
      'postId': postId,
      'userId': userId,
      'isLiked': isLiked,
      'isUnliked': isUnliked,
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      transaction.set(
          FirebaseFirestore.instance.collection('actions').doc(), newAction);
      actions.add(newAction);
    } catch (e) {
      debugPrint('Error saving action to Firestore: $e');
    }
  }

  Future<void> _updateAction(String postId, bool isLiked, bool isUnliked,
      Transaction transaction, DocumentReference docRef) async {
    var updatedAction = {
      'postId': postId,
      'userId': userId,
      'isLiked': isLiked,
      'isUnliked': isUnliked,
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      transaction.update(docRef, updatedAction);
      var existingActionIndex = actions.indexWhere(
          (action) => action['postId'] == postId && action['userId'] == userId);
      actions[existingActionIndex] = updatedAction;
    } catch (e) {
      debugPrint('Error updating action in Firestore: $e');
    }
  }

  Future<void> _deleteAction(String postId, String userId,
      Transaction transaction, DocumentReference docRef) async {
    try {
      transaction.delete(docRef);
      actions.removeWhere(
          (action) => action['postId'] == postId && action['userId'] == userId);
    } catch (e) {
      debugPrint('Error deleting action from Firestore: $e');
    }
  }
}
