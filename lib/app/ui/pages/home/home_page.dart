import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app/app/ui/pages/home/home_controller.dart'; // Asegúrate de importar la página de la tabla
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<homecontroller>(
      create: (_) => homecontroller(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.table_chart),
              onPressed: () {
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Selector<homecontroller, bool>(
              selector: (_, controller) => controller.loading,
              builder: (context, loading, loadingWidget) {
                if (loading) {
                  return loadingWidget!;
                }
                return Consumer<homecontroller>(
                  builder: (_, controller, gpsenable) {
                    if (!controller.gpsenabled) {
                      return gpsenable!;
                    }
                    return GoogleMap(
                      onMapCreated: controller.onMapCreated, // Asegúrate de usar 'onMapCreated'
                      initialCameraPosition: controller.initialCameraPosition,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      markers: controller.markers,
                      polylines: controller.polylines,
                    );
                  },
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              child: const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: Consumer<homecontroller>(
                  builder: (context, controller, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        await controller.toggleRecording();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: controller.isRecording ? Colors.red : Colors.orange,
                      ),
                      child: Text(
                        controller.isRecording ? 'STOP' : 'START',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}