
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/app/ui/pages/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  // ignore: use_super_parameters
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

final _controller = SplashController(Permission.locationWhenInUse);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
_controller.checkPermission();
    },
    
    );
    _controller .addListener(() {
      if(_controller.routeName!= null){
       Navigator.pushReplacementNamed(context, _controller.routeName!);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),
      )
    );
  }
}