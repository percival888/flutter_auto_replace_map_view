import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StaticGoogleMapIconView extends StatelessWidget {
  const StaticGoogleMapIconView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mapKey = "***";
    double lat = 31.067207;
    double lnt = 121.5266216;
    double width = 375;
    double height = 300;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('谷歌地图'),
      ),
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            imageUrl:
                "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lnt&zoom=15&language=zh-CH&scale=2&size=${width.toInt()}x${height.toInt()}&key=$mapKey",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
