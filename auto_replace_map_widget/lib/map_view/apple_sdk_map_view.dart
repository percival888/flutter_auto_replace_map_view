import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:auto_replace_map_widget/auto_replace_apple_map_view/auto_replace_apple_map_view.dart';
import 'package:flutter/material.dart';

class AppleSdkMapView extends StatelessWidget {
  const AppleSdkMapView({Key? key}) : super(key: key);

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
            Text('苹果sdk地图'),
            SizedBox(
              height: 300,
              child: AppleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(31.067207, 121.5266216),
                  zoom: 15,
                ),
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
              ),
            ),
            SizedBox(height: 50),
            Text('苹果sdk地图替换成图片'),
            SizedBox(
              height: 300,
              child: AutoReplaceAppleMapView(
                initialCameraPosition: CameraPosition(
                  target: LatLng(31.067207, 121.5266216),
                  zoom: 15,
                ),
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
