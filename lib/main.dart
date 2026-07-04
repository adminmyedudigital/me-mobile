import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/controllers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<AuthStorageService>(
    () => AuthStorageService().init(),
    permanent: true,
  );
  AppBinding().dependencies();
  await Get.find<AuthController>().restoreSession();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<AuthController>().validateSession();
    }
  }

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
        initialRoute: appController.isAuthenticated.value
            ? AppRoutes.home
            : AppRoutes.signIn,
        routes: AppRoutes.routes,
      ),
    );
  }
}
