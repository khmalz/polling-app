import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polling_app/app/data/helper/diff_for_human.dart';
import '../controllers/timeline_controller.dart';

class TimelineView extends GetView<TimelineController> {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TimelineController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return Obx(() {
              if (controller.actions.isEmpty && controller.posts.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  var post = controller.posts[index];
                  var action = controller.actions.firstWhere(
                    (action) => action['postId'] == post.id,
                    orElse: () => {},
                  );

                  bool isLiked = action['isLiked'] ?? false;
                  bool isUnliked = action['isUnliked'] ?? false;

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
                        Text(
                          post.userName ?? 'Guest',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[900],
                          ),
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.likePost(post.id ?? '');
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: isLiked ? Colors.blue : Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.unlikePost(post.id ?? '');
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color:
                                        isUnliked ? Colors.blue : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(children: [
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
                            ])
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }
}
