// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

#import "messages.g.h"

NS_ASSUME_NONNULL_BEGIN

// Defines ground overlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject
@property(atomic, readonly) NSString* groundOverlayId;
- (instancetype)initWithGroundOverlay:(FGMPlatformGroundOverlay *)groundOverlay
                                      mapView:(GMSMapView*)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)initWithMapView:(GMSMapView*)mapView
                callbackHandler:(FGMMapsCallbackApi *)callbackHandler
                registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToChange;
- (void)removeGroundOverlayIds:(NSArray<NSString *> *)groundOverlayIdsToRemove;
- (void)onGroundOverlayTap:(NSString*)groundOverlayId;
- (bool)hasGroundOverlayWithId:(NSString*)groundOverlayId;
@end

NS_ASSUME_NONNULL_END
