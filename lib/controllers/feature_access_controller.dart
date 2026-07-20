import 'package:get/get.dart';

import 'package:me_mobile/enums/app_feature.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/models/feature_access_requirement_model.dart';

class FeatureAccessController extends GetxController {
  late final List<FeatureAccessRequirement> _requirements = [
    FeatureAccessRequirement(
      id: 'academic-history',
      features: const {
        AppFeature.dashboard,
        AppFeature.exams,
        AppFeature.analytics,
        AppFeature.createTimetable,
        AppFeature.addExamResult,
      },
      isSatisfied: () => Get.find<AuthController>().hasAcademicHistory,
      title: 'Complete your academic setup',
      message:
          'Add your academic setup to use the dashboard, exams, analytics, and planning features.',
      actionLabel: 'Complete setup',
      actionRoute: AppRoutes.academicSetup,
    ),
  ];

  bool canAccess(AppFeature feature) => unmetRequirement(feature) == null;

  FeatureAccessRequirement? unmetRequirement(AppFeature feature) {
    for (final requirement in _requirements) {
      if (requirement.features.contains(feature) &&
          !requirement.isSatisfied()) {
        return requirement;
      }
    }

    return null;
  }
}
