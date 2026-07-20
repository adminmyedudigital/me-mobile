import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/study/study_loading_view.dart';
import 'package:me_mobile/screens/study/study_screen_content.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late final StudyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<StudyController>();
    _controller.loadSubjectTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: GetBuilder<StudyController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const StudyLoadingView();
          }

          return const StudyScreenContent();
        },
      ),
    );
  }
}
