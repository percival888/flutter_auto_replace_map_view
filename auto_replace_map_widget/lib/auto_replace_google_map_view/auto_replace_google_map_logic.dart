import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'auto_replace_google_map_state.dart';

class AutoReplaceGoogleMapLogic extends GetxController {
  final AutoReplaceGoogleMapState state = AutoReplaceGoogleMapState();

  AutoReplaceGoogleMapLogic() {
    state.tag = getUniqueId();
  }

  @override
  void onClose() {
    releaseMapController();
    super.onClose();
  }

  /// 获取唯一标识：随机数 + 时间
  static String getUniqueId({int count = 3}) {
    String randomStr = Random().nextInt(10).toString();
    for (var i = 0; i < count; i++) {
      var str = Random().nextInt(10);
      randomStr = "$randomStr$str";
    }
    final timeNumber = DateTime.now().millisecondsSinceEpoch;
    final uuid = "$randomStr$timeNumber";
    return uuid;
  }

  /// 进行截图
  void startSnapShot() async {
    debugPrint("地图开始截屏");
    state.isMapWaitSnapShot = true;
    try {
      debugPrint("开始截图 ${DateTime.now()}");
      final uin8list = await state.mapController?.takeSnapshot();
      debugPrint("完成截图 ${DateTime.now()}");
      if (uin8list != null) {
        state.mapImage = MemoryImage(uin8list);
        update();
        debugPrint("地图截屏成功，图片替换");
        releaseMapController();
      } else {
        state.isMapWaitSnapShot = false;
        debugPrint("地图截屏失败");
      }
    } catch (e) {
      debugPrint("地图截屏错误：$e");
      state.isMapWaitSnapShot = false;
    }
  }

  /// controller释放
  void releaseMapController() {
    debugPrint("地图controller释放");
    state.mapController?.dispose();
    state.mapController = null;
  }
}
