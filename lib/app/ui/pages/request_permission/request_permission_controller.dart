import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionController {
  final Permission _LocationPermission;
  RequestPermissionController(this._LocationPermission);
  final _streamcontroller = StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get onStatusChanged => _streamcontroller.stream;
Future <PermissionStatus> check() async{
final status = await _LocationPermission.status;
return status;
}
Future<void>  request() async {
    final status = await _LocationPermission.request();
    _notify(status);
  }
  void _notify(PermissionStatus status){
if(_streamcontroller.isClosed && _streamcontroller.hasListener){
_streamcontroller.sink.add(status);

}
  }

  void dispose() {
    _streamcontroller.close();
  }
}
