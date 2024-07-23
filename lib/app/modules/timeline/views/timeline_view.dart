import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/timeline_controller.dart';

class TimelineView extends GetView<TimelineController> {
  const TimelineView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimelineView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TimelineView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
