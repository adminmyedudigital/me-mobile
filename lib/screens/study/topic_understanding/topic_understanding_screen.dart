import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/topic_understanding/topic_understanding.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_understanding_content.dart';

class TopicUnderstandingScreen extends StatefulWidget {
  const TopicUnderstandingScreen({super.key});

  @override
  State<TopicUnderstandingScreen> createState() =>
      _TopicUnderstandingScreenState();
}

class _TopicUnderstandingScreenState extends State<TopicUnderstandingScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<TopicUnderstandingController>().prepare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topic understanding')),
      body: SafeArea(
        child: GetBuilder<TopicUnderstandingController>(
          builder: (controller) {
            return GetBuilder<TopicUnderstandingProgressController>(
              builder: (progressController) => TopicUnderstandingContent(
                controller: controller,
                progressController: progressController,
              ),
            );
          },
        ),
      ),
    );
  }
}
