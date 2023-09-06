// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>


// Defines ground overlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject
@property(atomic, readonly) NSString* groundOverlayId;
- (instancetype)initGroundOverlayWithPosition:(CLLocationCoordinate2D)position
                                         icon:(UIImage*)icon
                                    zoomLevel:(CGFloat)zoomLevel
                              groundOverlayId:(NSString*)groundOverlayId
                                      mapView:(GMSMapView*)mapView;
- (instancetype)initGroundOverlayWithBounds:(GMSCoordinateBounds*)bounds
                                       icon:(UIImage*)icon
                            groundOverlayId:(NSString*)groundOverlayId
                                    mapView:(GMSMapView*)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addGroundOverlays:(NSArray*)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray*)groundOverlaysToChange;
- (void)removeGroundOverlayIds:(NSArray*)groundOverlayIdsToRemove;
- (void)onGroundOverlayTap:(NSString*)groundOverlayId;
- (bool)hasGroundOverlayWithId:(NSString*)groundOverlayId;
@end