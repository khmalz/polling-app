import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:polling_app/app/data/helper/diff_for_human.dart';
import 'package:polling_app/app/data/helper/modal.dart';
import 'package:polling_app/app/modules/post/controllers/post_controller.dart';

class UserPostView extends GetView<PostController> {
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Post'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.fetchUserPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            if (controller.userPosts.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            return Stack(children: [
              Obx(() {
                if (controller.isLoading.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.userPosts.length, 
                    itemBuilder: (context, index) {
                      var post = controller.userPosts[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${post.userName} (You)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[900],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      onTap: () {
                                        controller.isClickDelete.value = true;
                                        controller.postIdDelete.value =
                                            post.id!;
                                      },
                                      value: 'Delete',
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              diffForHuman(post.createdAt ?? ''),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post.description ?? 'No Description',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            if (post.imageUrl != null)
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.7,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        post.imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${post.votePercentage ?? 0}% Up-Likes',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
              Obx(() {
                if (controller.isClickDelete.value) {
                  return ModalConfirm(
                    controllerVal: controller.isClickDelete,
                    message: 'Are you sure want to delete this post?',
                    icon: Icons.delete_forever,
                    onConfirm: () {
                      controller.deletePost(controller.postIdDelete.value);
                      controller.isClickDelete.value = false;
                    },
                    onCancel: () {
                      controller.isClickDelete.value = false;
                    },
                  );
                } else {
                  return const SizedBox();
                }
              })
            ]);
          }
        },
      ),
    );
  }
}
