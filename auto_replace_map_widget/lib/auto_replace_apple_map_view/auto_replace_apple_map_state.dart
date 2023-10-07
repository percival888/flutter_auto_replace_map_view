import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';

class AutoReplaceAppleMapState {
  /// getX tag id
  late String tag = "";

  /// 地图key
  Key mapKey = GlobalKey();

  /// 地图控制器
  AppleMapController? mapController;

  /// 地图是否第一次出现在屏幕中
  bool isMapFirstShow = true;

  /// 是否可以截屏
  bool isMapFinishLoad = false;

  /// 地图可见度
  double mapVisibleFraction = 0;

  /// 地图是否截屏中
  bool isMapWaitSnapShot = false;

  /// 地图截屏图片
  ImageProvider? mapImage;
}
