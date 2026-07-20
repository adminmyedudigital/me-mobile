import 'package:me_mobile/enums/app_feature.dart';

class FeatureAccessRequirement {
  const FeatureAccessRequirement({
    required this.id,
    required this.features,
    required this.isSatisfied,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.actionRoute,
  });

  final String id;
  final Set<AppFeature> features;
  final bool Function() isSatisfied;
  final String title;
  final String message;
  final String actionLabel;
  final String actionRoute;
}
