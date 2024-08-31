
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/app/ui/pages/request_permission/request_permission_controller.dart';
import 'package:app/app/ui/routes/routes.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({Key? key}) : super(key: key);

  @override
  _RequestPermissionPageState createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> with WidgetsBindingObserver{
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _subscription = _controller.onStatusChanged.listen(
      (status)  { 
  switch (status) {
    case PermissionStatus.granted:
      _gotohome();
      break;
    case PermissionStatus.permanentlyDenied:
    showDialog(
      context: context, 
      builder: (_)=>AlertDialog(
        title: const Text("info"),
        content: const Text("sasssasa"),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              openAppSettings;
            },
             child: const Text("Go to setting"),
             ),
             TextButton(
              onPressed:(){
                 Navigator.pop(context);
                 },
               child:const Text("Cancel"),
               )
        ],
      )
      );

     
      break;
    case PermissionStatus.denied:
      // Manejar el caso de permiso denegado
      break;
    case PermissionStatus.restricted:
      // Manejar el caso de permiso restringido
      break;
    default:
      // Manejar cualquier otro caso inesperado
      break;
  }
      },
      );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
   if(state == AppLifecycleState.resumed)
   {
    final status = await  _controller.check();
    if ( status == PermissionStatus.granted){
      _gotohome();
    }
    else if ( status == PermissionStatus.denied)
    {

    }
   }
  }
  void _gotohome(){
Navigator.pushReplacementNamed(context, Routes.HOME);
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SafeArea(
  child: Container(
  width: double.infinity,
  height: double.infinity,
  alignment: Alignment.center,
  child: ElevatedButton(child: const Text("Allow"),onPressed: (){
    _controller.request() ;
  },),
  ),),

    );
  }
}