// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

#import "GoogleMapController.h"
#import "messages.g.h"

NS_ASSUME_NONNULL_BEGIN

// Defines marker controllable by Flutter.
@interface FLTGoogleMapMarkerController : NSObject
@property(assign, nonatomic, readonly) BOOL consumeTapEvents;
- (instancetype)initMarkerWithPosition:(CLLocationCoordinate2D)position
                            identifier:(NSString *)identifier
                               mapView:(GMSMapView *)mapView;
- (void)showInfoWindow;
- (void)hideInfoWindow;
- (BOOL)isInfoWindowShown;
- (void)removeMarker;
@end

@interface FLTMarkersController : NSObject
- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel
                              mapView:(GMSMapView *)mapView
                            registrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)addJSONMarkers:(NSArray<NSDictionary<NSString *, id> *> *)markersToAdd;
- (void)addMarkers:(NSArray<FGMPlatformMarker *> *)markersToAdd;
- (void)changeMarkers:(NSArray<FGMPlatformMarker *> *)markersToChange;
- (void)removeMarkersWithIdentifiers:(NSArray<NSString *> *)identifiers;
- (BOOL)didTapMarkerWithIdentifier:(NSString *)identifier;
- (void)didStartDraggingMarkerWithIdentifier:(NSString *)identifier
                                    location:(CLLocationCoordinate2D)coordinate;
- (void)didEndDraggingMarkerWithIdentifier:(NSString *)identifier
                                  location:(CLLocationCoordinate2D)coordinate;
- (void)didDragMarkerWithIdentifier:(NSString *)identifier
                           location:(CLLocationCoordinate2D)coordinate;
- (void)didTapInfoWindowOfMarkerWithIdentifier:(NSString *)identifier;
- (void)showMarkerInfoWindowWithIdentifier:(NSString *)identifier
                                     error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error;
- (void)hideMarkerInfoWindowWithIdentifier:(NSString *)identifier
                                     error:(FlutterError *_Nullable __autoreleasing *_Nonnull)error;
/// Returns whether or not the info window for the marker with the given identifier is shown.
///
/// If there is no such marker, returns nil and sets error.
- (nullable NSNumber *)
    isInfoWindowShownForMarkerWithIdentifier:(NSString *)identifier
                                       error:
                                           (FlutterError *_Nullable __autoreleasing *_Nonnull)error;
@end

NS_ASSUME_NONNULL_END
