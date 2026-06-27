import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/controllers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ME Digital',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: appController.themeMode.value,
        initialRoute: AppRoutes.signIn,
        routes: AppRoutes.routes,
      ),
    );
  }
}
