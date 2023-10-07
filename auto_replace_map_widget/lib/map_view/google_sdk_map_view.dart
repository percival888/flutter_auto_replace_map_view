import 'package:auto_replace_map_widget/auto_replace_google_map_view/auto_replace_google_map_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleSdkMapView extends StatelessWidget {
  const GoogleSdkMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('谷歌地图'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 50),
            Text('谷歌sdk地图'),
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(31.067207, 121.5266216),
                  zoom: 15,
                ),
                buildingsEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
              ),
            ),
            SizedBox(height: 50),
            Text('谷歌sdk地图替换成图片'),
            SizedBox(
              height: 300,
              child: AutoReplaceGoogleMapView(
                initialCameraPosition: CameraPosition(
                  target: LatLng(31.067207, 121.5266216),
                  zoom: 15,
                ),
                buildingsEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
