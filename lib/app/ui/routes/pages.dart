// pages.dart
import 'package:flutter/widgets.dart';
import 'package:app/app/ui/pages/Splash/splash_page.dart';
import 'package:app/app/ui/routes/routes.dart'; // Importa las rutas desde routes.dart
import 'package:app/app/ui/pages/home/home_page.dart';
import 'package:app/app/ui/pages/request_permission/request_permission_page.dart';
import 'package:app/app/ui/pages/name/name_page.dart';
Map<String, Widget Function(BuildContext)> appRoutes(){
  return {
    Routes.SPLASH: (_) => const SplashPage(),
    Routes.PERMISSIONS: (_) => const RequestPermissionPage(),
    Routes.HOME: (_) => const HomePage(),
    Routes.NAME: (_) =>  Namepage(),
  };
}