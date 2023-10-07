import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'auto_replace_google_map_logic.dart';
import 'auto_replace_google_map_state.dart';

// ** 安卓端谷歌地图截屏操作中时，进行界面跳转会导致程序崩溃，暂不建议使用 **
class AutoReplaceGoogleMapView extends StatefulWidget {
  const AutoReplaceGoogleMapView({
    Key? key,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.layoutDirection,
    this.padding = const EdgeInsets.all(0),
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.circles = const <Circle>{},
    this.onCameraMoveStarted,
    this.tileOverlays = const <TileOverlay>{},
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// The layout direction to use for the embedded view.
  ///
  /// If this is null, the ambient [Directionality] is used instead. If there is
  /// no ambient [Directionality], [TextDirection.ltr] is used.
  final TextDirection? layoutDirection;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should be in lite mode. Android only.
  ///
  /// See https://developers.google.com/maps/documentation/android-sdk/lite#overview_of_lite_mode for more details.
  final bool liteModeEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  final EdgeInsets padding;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// Tile overlays to be placed on the map.
  final Set<TileOverlay> tileOverlays;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  final CameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called every time a [GoogleMap] is tapped.
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  final bool myLocationEnabled;

  final bool myLocationButtonEnabled;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State<AutoReplaceGoogleMapView> createState() =>
      _AutoReplaceGoogleMapViewState();
}

class _AutoReplaceGoogleMapViewState extends State<AutoReplaceGoogleMapView> {
  final logic = AutoReplaceGoogleMapLogic();

  AutoReplaceGoogleMapState get state => logic.state;

  @override
  void initState() {
    super.initState();
    Get.put(logic, tag: state.tag);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutoReplaceGoogleMapLogic>(
      tag: state.tag,
      builder: (logic) {
        if (logic.state.mapImage != null) {
          return Image(image: logic.state.mapImage!);
        }
        return VisibilityDetector(
          key: state.mapKey,
          onVisibilityChanged: (VisibilityInfo info) async {
            state.mapVisibleFraction = info.visibleFraction;
            // debugPrint("地图可见度：${info.visibleFraction}");
            // 地图第一次出现的时候，延时0.6s后才进行截图，避免地图未渲染完毕，截图空白
            if (info.visibleFraction > 0 && state.isMapFirstShow) {
              state.isMapFirstShow = false;
              Future.delayed(
                const Duration(milliseconds: 600),
                () async {
                  state.isMapFinishLoad = true;
                  if (state.mapVisibleFraction > 0.2) {
                    logic.startSnapShot();
                  }
                },
              );
            }
            if (info.visibleFraction < 0.2) return;
            if (state.mapController == null ||
                !state.isMapFinishLoad ||
                state.isMapWaitSnapShot) return;
            logic.startSnapShot();
          },
          child: GoogleMap(
            initialCameraPosition: widget.initialCameraPosition,
            onMapCreated: (GoogleMapController controller) async {
              state.mapController = controller;
              if (widget.onMapCreated != null) widget.onMapCreated!(controller);
            },
            gestureRecognizers: widget.gestureRecognizers,
            compassEnabled: widget.compassEnabled,
            mapToolbarEnabled: widget.mapToolbarEnabled,
            cameraTargetBounds: widget.cameraTargetBounds,
            mapType: widget.mapType,
            minMaxZoomPreference: widget.minMaxZoomPreference,
            rotateGesturesEnabled: widget.rotateGesturesEnabled,
            scrollGesturesEnabled: widget.scrollGesturesEnabled,
            zoomControlsEnabled: widget.zoomControlsEnabled,
            zoomGesturesEnabled: widget.zoomGesturesEnabled,
            liteModeEnabled: widget.liteModeEnabled,
            tiltGesturesEnabled: widget.tiltGesturesEnabled,
            myLocationEnabled: widget.myLocationEnabled,
            myLocationButtonEnabled: widget.myLocationButtonEnabled,
            layoutDirection: widget.layoutDirection,
            padding: widget.padding,
            indoorViewEnabled: widget.indoorViewEnabled,
            trafficEnabled: widget.trafficEnabled,
            buildingsEnabled: widget.buildingsEnabled,
            markers: widget.markers,
            polygons: widget.polygons,
            polylines: widget.polylines,
            circles: widget.circles,
            onCameraMoveStarted: widget.onCameraMoveStarted,
            tileOverlays: widget.tileOverlays,
            onCameraMove: widget.onCameraMove,
            onCameraIdle: widget.onCameraIdle,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
          ),
        );
      },
    );
  }
}
