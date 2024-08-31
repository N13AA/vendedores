import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class homecontroller extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();
  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsenabled;
  bool get gpsenabled => _gpsenabled;
  StreamSubscription? _gpssubscription, _positionsubscription;
  Position? _initialposition;
  Position? _currentPosition;
  double? latitude;
  double? longitude;
  bool isRecording = false;
  List<Map<String, dynamic>> _coordenadas = [];
  List<LatLng> _routeCoordinates = [];
  Polyline? _routePolyline;

  List<Map<String, dynamic>> get coordenadas => _coordenadas;

  CameraPosition get initialCameraPosition => CameraPosition(
        target: LatLng(_initialposition!.latitude, _initialposition!.longitude),
        zoom: 16,
      );

  Set<Polyline> get polylines {
    if (_routePolyline != null) {
      return { _routePolyline! };
    }
    return {};
  }

  homecontroller() {
    _init();
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  Future<void> _init() async {
    _gpsenabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    _gpssubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsenabled = status == ServiceStatus.enabled;
        if (_gpsenabled) {
          _initlocationupdates();
        }
      },
    );
    _initlocationupdates();
  }

  Future<void> _initlocationupdates() async {
    bool initialized = false;
    await _positionsubscription?.cancel();
    _positionsubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        if (!initialized) {
          _getposition(position);
          initialized = true;
        }
        if (isRecording) {
          _routeCoordinates.add(LatLng(position.latitude, position.longitude));
          _updatePolyline();
        }
        notifyListeners();
      },
      onError: (e) {
        if (e is LocationServiceDisabledException) {
          _gpsenabled = false;
          notifyListeners();
        }
      },
    );
  }

  Future<void> _getposition(Position position) async {
    if (_gpsenabled && _initialposition == null) {
      _initialposition = position;
    }
    _currentPosition = position;
  }

  Future<void> toggleRecording() async {
    if (isRecording) {
      // Stop recording and save the final position
      isRecording = false;
      await _savePosition(_currentPosition!, 'final');
    } else {
      // Start recording and save the initial position
      isRecording = true;
      _routeCoordinates.clear();
      await _savePosition(_currentPosition!, 'initial');
    }
    notifyListeners();
  }

  Future<void> _savePosition(Position position, String type) async {
    final db = await DBHelper.db();
    await db.insert('coordenadas', {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'type': type,
    });
  }

  void _updatePolyline() {
    _routePolyline = Polyline(
      polylineId: PolylineId('route'),
      points: _routeCoordinates,
      color: Colors.blue,
      width: 5,
    );
  }

  Future<void> loadPositions() async {
    final db = await DBHelper.db();
    _coordenadas = await db.query('coordenadas');
    notifyListeners();
  }

  @override
  void dispose() {
    _positionsubscription?.cancel();
    _gpssubscription?.cancel();
    super.dispose();
  }
  
void onMapCreated(GoogleMapController controller) {
    // Aquí puedes manejar la creación del mapa
  }
}

class DBHelper {
  static Future<Database> db() async {
    final dbPath = join(await getDatabasesPath(), 'coordenadas.db');

    // Opcional: Eliminar la base de datos existente para garantizar la creación de una nueva
    await deleteDatabase(dbPath);

    return openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE coordenadas('
          'id INTEGER PRIMARY KEY, '
          'latitude REAL, '
          'longitude REAL, '
          'type TEXT'
          ')',
        );
      },
      version: 1,
    );
  }
}