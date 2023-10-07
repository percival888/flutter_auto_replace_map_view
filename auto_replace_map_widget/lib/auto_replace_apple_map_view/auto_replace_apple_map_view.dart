import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'auto_replace_apple_map_logic.dart';
import 'auto_replace_apple_map_state.dart';

class AutoReplaceAppleMapView extends StatefulWidget {
  const AutoReplaceAppleMapView({
    Key? key,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers,
    this.compassEnabled = true,
    this.trafficEnabled = false,
    this.mapType = MapType.standard,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.trackingMode = TrackingMode.none,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.pitchGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.padding = EdgeInsets.zero,
    this.annotations,
    this.polylines,
    this.circles,
    this.polygons,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
    this.snapshotOptions,
  }) : super(key: key);

  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should display the current traffic.
  final bool trafficEnabled;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// The mode used to track the user location.
  final TrackingMode trackingMode;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool pitchGesturesEnabled;

  /// Annotations to be placed on the map.
  final Set<Annotation>? annotations;

  /// Polylines to be placed on the map.
  final Set<Polyline>? polylines;

  /// Circles to be placed on the map.
  final Set<Circle>? circles;

  /// Polygons to be placed on the map.
  final Set<Polygon>? polygons;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or annotation clicks.
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

  /// Called every time a [AppleMap] is tapped.
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [AppleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// The padding used on the map
  ///
  /// The amount of additional space (measured in screen points) used for padding for the
  /// native controls.
  final EdgeInsets padding;

  final SnapshotOptions? snapshotOptions;

  @override
  State<AutoReplaceAppleMapView> createState() =>
      _AutoReplaceAppleMapViewState();
}

class _AutoReplaceAppleMapViewState extends State<AutoReplaceAppleMapView> {
  final logic = AutoReplaceAppleMapLogic();

  AutoReplaceAppleMapState get state => logic.state;

  @override
  void initState() {
    super.initState();
    Get.put(logic, tag: state.tag);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutoReplaceAppleMapLogic>(
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
          child: AppleMap(
            initialCameraPosition: widget.initialCameraPosition,
            onMapCreated: (AppleMapController controller) async {
              state.mapController = controller;
              if (widget.onMapCreated != null) widget.onMapCreated!(controller);
            },
            gestureRecognizers: widget.gestureRecognizers,
            compassEnabled: widget.compassEnabled,
            trafficEnabled: widget.trafficEnabled,
            mapType: widget.mapType,
            minMaxZoomPreference: widget.minMaxZoomPreference,
            trackingMode: widget.trackingMode,
            rotateGesturesEnabled: widget.rotateGesturesEnabled,
            scrollGesturesEnabled: widget.scrollGesturesEnabled,
            zoomGesturesEnabled: widget.zoomGesturesEnabled,
            pitchGesturesEnabled: widget.pitchGesturesEnabled,
            myLocationEnabled: widget.myLocationEnabled,
            myLocationButtonEnabled: widget.myLocationButtonEnabled,
            padding: widget.padding,
            annotations: widget.annotations,
            polylines: widget.polylines,
            circles: widget.circles,
            polygons: widget.polygons,
            onCameraMoveStarted: widget.onCameraMoveStarted,
            onCameraMove: widget.onCameraMove,
            onCameraIdle: widget.onCameraIdle,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            snapshotOptions: widget.snapshotOptions,
          ),
        );
      },
    );
  }
}
