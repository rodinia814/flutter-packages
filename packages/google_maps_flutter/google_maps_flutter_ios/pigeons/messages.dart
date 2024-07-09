// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  objcHeaderOut: 'ios/Classes/messages.g.h',
  objcSourceOut: 'ios/Classes/messages.g.m',
  objcOptions: ObjcOptions(prefix: 'FGM'),
  copyrightHeader: 'pigeons/copyright.txt',
))

/// Pigeon representation of a CameraUpdate.
class PlatformCameraUpdate {
  PlatformCameraUpdate(this.json);

  /// The update data, as JSON. This should only be set from
  /// CameraUpdate.toJson, and the native code must intepret it according to the
  /// internal implementation details of the CameraUpdate class.
  // TODO(stuartmorgan): Update the google_maps_platform_interface CameraUpdate
  //  class to provide a structured representation of an update. Currently it
  //  uses JSON as its only state, so there is no way to preserve structure.
  //  This wrapper class exists as a placeholder for now to at least provide
  //  type safety in the top-level call's arguments.
  final Object json;
}

/// Pigeon equivalent of the Circle class.
class PlatformCircle {
  PlatformCircle(this.json);

  /// The circle data, as JSON. This should only be set from
  /// Circle.toJson, and the native code must intepret it according to the
  /// internal implementation details of that method.
  // TODO(stuartmorgan): Replace this with structured data. This exists only to
  //  allow incremental migration to Pigeon.
  final Object json;
}

/// Pigeon equivalent of the Marker class.
class PlatformMarker {
  PlatformMarker(this.json);

  /// The marker data, as JSON. This should only be set from
  /// Marker.toJson, and the native code must intepret it according to the
  /// internal implementation details of that method.
  // TODO(stuartmorgan): Replace this with structured data. This exists only to
  //  allow incremental migration to Pigeon.
  final Object json;
}

/// Pigeon equivalent of the Polygon class.
class PlatformPolygon {
  PlatformPolygon(this.json);

  /// The polygon data, as JSON. This should only be set from
  /// Polygon.toJson, and the native code must intepret it according to the
  /// internal implementation details of that method.
  // TODO(stuartmorgan): Replace this with structured data. This exists only to
  //  allow incremental migration to Pigeon.
  final Object json;
}

/// Pigeon equivalent of the Polyline class.
class PlatformPolyline {
  PlatformPolyline(this.json);

  /// The polyline data, as JSON. This should only be set from
  /// Polyline.toJson, and the native code must intepret it according to the
  /// internal implementation details of that method.
  // TODO(stuartmorgan): Replace this with structured data. This exists only to
  //  allow incremental migration to Pigeon.
  final Object json;
}

/// Pigeon equivalent of the TileOverlay class.
class PlatformTileOverlay {
  PlatformTileOverlay(this.json);

  /// The tile overlay data, as JSON. This should only be set from
  /// TileOverlay.toJson, and the native code must intepret it according to the
  /// internal implementation details of that method.
  // TODO(stuartmorgan): Replace this with structured data. This exists only to
  //  allow incremental migration to Pigeon.
  final Object json;
}

/// Pigeon equivalent of LatLng.
class PlatformLatLng {
  PlatformLatLng({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

/// Pigeon equivalent of LatLngBounds.
class PlatformLatLngBounds {
  PlatformLatLngBounds({required this.northeast, required this.southwest});

  final PlatformLatLng northeast;
  final PlatformLatLng southwest;
}

/// Pigeon equivalent of MapConfiguration.
class PlatformMapConfiguration {
  PlatformMapConfiguration({required this.json});

  /// The configuration options, as JSON. This should only be set from
  /// _jsonForMapConfiguration, and the native code must intepret it according
  /// to the internal implementation details of that method.
  // TODO(stuartmorgan): Replace this with structured data. This exists only to
  //  allow incremental migration to Pigeon.
  final Object json;
}

/// Pigeon representation of an x,y coordinate.
class PlatformPoint {
  PlatformPoint({required this.x, required this.y});

  final double x;
  final double y;
}

/// Pigeon equivalent of GMSTileLayer properties.
class PlatformTileLayer {
  PlatformTileLayer({
    required this.visible,
    required this.fadeIn,
    required this.opacity,
    required this.zIndex,
  });

  final bool visible;
  final bool fadeIn;
  final double opacity;
  final int zIndex;
}

/// Pigeon equivalent of MinMaxZoomPreference.
class PlatformZoomRange {
  PlatformZoomRange({required this.min, required this.max});

  final double min;
  final double max;
}

/// Interface for non-test interactions with the native SDK.
///
/// For test-only state queries, see [MapsInspectorApi].
@HostApi()
abstract class MapsApi {
  /// Returns once the map instance is available.
  void waitForMap();

  /// Updates the map's configuration options.
  ///
  /// Only non-null configuration values will result in updates; options with
  /// null values will remain unchanged.
  @ObjCSelector('updateWithMapConfiguration:')
  void updateMapConfiguration(PlatformMapConfiguration configuration);

  /// Updates the set of circles on the map.
  // TODO(stuartmorgan): Make the generic type non-nullable once supported.
  // https://github.com/flutter/flutter/issues/97848
  // The consuming code treats the entries as non-nullable.
  @ObjCSelector('updateCirclesByAdding:changing:removing:')
  void updateCircles(List<PlatformCircle?> toAdd,
      List<PlatformCircle?> toChange, List<String?> idsToRemove);

  /// Updates the set of markers on the map.
  // TODO(stuartmorgan): Make the generic type non-nullable once supported.
  // https://github.com/flutter/flutter/issues/97848
  // The consuming code treats the entries as non-nullable.
  @ObjCSelector('updateMarkersByAdding:changing:removing:')
  void updateMarkers(List<PlatformMarker?> toAdd,
      List<PlatformMarker?> toChange, List<String?> idsToRemove);

  /// Updates the set of polygonss on the map.
  // TODO(stuartmorgan): Make the generic type non-nullable once supported.
  // https://github.com/flutter/flutter/issues/97848
  // The consuming code treats the entries as non-nullable.
  @ObjCSelector('updatePolygonsByAdding:changing:removing:')
  void updatePolygons(List<PlatformPolygon?> toAdd,
      List<PlatformPolygon?> toChange, List<String?> idsToRemove);

  /// Updates the set of polylines on the map.
  // TODO(stuartmorgan): Make the generic type non-nullable once supported.
  // https://github.com/flutter/flutter/issues/97848
  // The consuming code treats the entries as non-nullable.
  @ObjCSelector('updatePolylinesByAdding:changing:removing:')
  void updatePolylines(List<PlatformPolyline?> toAdd,
      List<PlatformPolyline?> toChange, List<String?> idsToRemove);

  /// Updates the set of tile overlays on the map.
  // TODO(stuartmorgan): Make the generic type non-nullable once supported.
  // https://github.com/flutter/flutter/issues/97848
  // The consuming code treats the entries as non-nullable.
  @ObjCSelector('updateTileOverlaysByAdding:changing:removing:')
  void updateTileOverlays(List<PlatformTileOverlay?> toAdd,
      List<PlatformTileOverlay?> toChange, List<String?> idsToRemove);

  /// Gets the screen coordinate for the given map location.
  @ObjCSelector('screenCoordinatesForLatLng:')
  PlatformPoint getScreenCoordinate(PlatformLatLng latLng);

  /// Gets the map location for the given screen coordinate.
  @ObjCSelector('latLngForScreenCoordinate:')
  PlatformLatLng getLatLng(PlatformPoint screenCoordinate);

  /// Gets the map region currently displayed on the map.
  @ObjCSelector('visibleMapRegion')
  PlatformLatLngBounds getVisibleRegion();

  /// Moves the camera according to [cameraUpdate] immediately, with no
  /// animation.
  @ObjCSelector('moveCameraWithUpdate:')
  void moveCamera(PlatformCameraUpdate cameraUpdate);

  /// Moves the camera according to [cameraUpdate], animating the update.
  @ObjCSelector('animateCameraWithUpdate:')
  void animateCamera(PlatformCameraUpdate cameraUpdate);

  /// Gets the current map zoom level.
  @ObjCSelector('currentZoomLevel')
  double getZoomLevel();

  /// Show the info window for the marker with the given ID.
  @ObjCSelector('showInfoWindowForMarkerWithIdentifier:')
  void showInfoWindow(String markerId);

  /// Hide the info window for the marker with the given ID.
  @ObjCSelector('hideInfoWindowForMarkerWithIdentifier:')
  void hideInfoWindow(String markerId);

  /// Returns true if the marker with the given ID is currently displaying its
  /// info window.
  @ObjCSelector('isShowingInfoWindowForMarkerWithIdentifier:')
  bool isInfoWindowShown(String markerId);

  /// Sets the style to the given map style string, where an empty string
  /// indicates that the style should be cleared.
  ///
  /// If there was an error setting the style, such as an invalid style string,
  /// returns the error message.
  @ObjCSelector('setStyle:')
  String? setStyle(String style);

  /// Returns the error string from the last attempt to set the map style, if
  /// any.
  ///
  /// This allows checking asynchronously for initial style failures, as there
  /// is no way to return failures from map initialization.
  @ObjCSelector('lastStyleError')
  String? getLastStyleError();

  /// Clears the cache of tiles previously requseted from the tile provider.
  @ObjCSelector('clearTileCacheForOverlayWithIdentifier:')
  void clearTileCache(String tileOverlayId);

  /// Takes a snapshot of the map and returns its image data.
  Uint8List? takeSnapshot();
}

/// Inspector API only intended for use in integration tests.
@HostApi()
abstract class MapsInspectorApi {
  bool areBuildingsEnabled();
  bool areRotateGesturesEnabled();
  bool areScrollGesturesEnabled();
  bool areTiltGesturesEnabled();
  bool areZoomGesturesEnabled();
  bool isCompassEnabled();
  bool isMyLocationButtonEnabled();
  bool isTrafficEnabled();
  @ObjCSelector('getInfoForTileOverlayWithIdentifier:')
  PlatformTileLayer? getTileOverlayInfo(String tileOverlayId);
  @ObjCSelector('zoomRange')
  PlatformZoomRange getZoomRange();
}
