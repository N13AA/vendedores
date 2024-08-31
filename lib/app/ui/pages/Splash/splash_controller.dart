import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:permission_handler/permission_handler.dart';
import 'package:app/app/ui/routes/routes.dart';

class SplashController extends ChangeNotifier{
// ignore: non_constant_identifier_names
final Permission _LocationPermission;
String? _routeName;
String? get routeName => _routeName;
SplashController(this._LocationPermission);
Future <void> checkPermission () async{
final isGranted= await _LocationPermission.isGranted;
_routeName  = isGranted? Routes.HOME:Routes.PERMISSIONS;
notifyListeners();
}
}