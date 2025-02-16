// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "GoogleMapGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"

static UIImage* ExtractBitmapDescriptor(NSObject<FlutterPluginRegistrar>* registrar, NSArray* bitmap);

static GMSCoordinateBounds* ToLatLngBounds(NSArray* data) {
  return [[GMSCoordinateBounds alloc] initWithCoordinate:[FLTGoogleMapJSONConversions locationFromLatLong:data[0]]
                                              coordinate:[FLTGoogleMapJSONConversions locationFromLatLong:data[1]]];
}

@interface FLTGoogleMapGroundOverlayController ()

  @property(strong, nonatomic) GMSGroundOverlay *groundOverlay;
  @property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGoogleMapGroundOverlayController

- (instancetype)initWithGroundOverlay:(FGMPlatformGroundOverlay*)groundOverlay
                                      mapView:(GMSMapView*)mapView {
  self = [super init];
  if (self) {
    _groundOverlay = groundOverlay;
    _mapView = mapView;
  }
  return self;
}

- (void)removeGroundOverlay {
  self.groundOverlay.map = nil;
}

- (void)setConsumeTapEvents:(BOOL)consumes {
  self.groundOverlay.tappable = consumes;
}
- (void)setVisible:(BOOL)visible {
  self.groundOverlay.map = visible ? self.mapView : nil;
}
- (void)setZIndex:(int)zIndex {
  self.groundOverlay.zIndex = zIndex;
}
- (void)setBounds:(GMSCoordinateBounds *)bounds {
  self.groundOverlay.bounds = bounds;
}
- (void)setPosition:(CLLocationCoordinate2D)position width:(CGFloat)width height:(CGFloat)height {
  self.groundOverlay.position = position;
}
- (void)setImage:(UIImage*)bd {
  self.groundOverlay.icon = bd;
}
- (void)setBearing:(CLLocationDirection)bearing {
  self.groundOverlay.bearing = bearing;
}
- (void)setOpacity:(float)opacity {
  self.groundOverlay.opacity = opacity;
}
- (void)interpretGroundOverlayOptions:(NSDictionary *)data
                                       registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents && consumeTapEvents != (id)[NSNull null]) {
    [self setConsumeTapEvents:consumeTapEvents];
  }
  NSNumber* visible = data[@"visible"];
  if (visible && visible != (id)[NSNull null]) {
    [self setVisible:[visible boolValue]];
  }
  NSNumber* zIndex = data[@"zIndex"];
  if (zIndex && zIndex != (id)[NSNull null]) {
    [self setZIndex:[zIndex intValue]];
  }
  NSNumber* transparency = data[@"transparency"];
  if (transparency != nil) {
    float opacity = 1 - [transparency floatValue];
    [self setOpacity:opacity];
  }
  NSNumber* width = data[@"width"];
  NSNumber* height = data[@"height"];
  NSArray* position = data[@"position"];
  if (position) {
    if (height != nil) {
      [self setPosition:[FLTGoogleMapJSONConversions locationFromLatLong:position] width:[width doubleValue] height:[height doubleValue]];
    } else {
      if (width != nil) {
        [self setPosition:[FLTGoogleMapJSONConversions locationFromLatLong:position] width:[width doubleValue] height:0];
      }
    }
  }
  NSArray* bounds = data[@"bounds"];
  if (bounds) {
    [self setBounds:ToLatLngBounds(bounds)];
  }
  NSNumber* bearing = data[@"bearing"];
  if (bearing && bearing != (id)[NSNull null]) {
    [self setBearing:[bearing floatValue]];
  }
  NSArray* bitmap = data[@"image"];
  if (bitmap) {
    UIImage* image = ExtractBitmapDescriptor(registrar, bitmap);
    [self setImage:image];
  }
}

static UIImage* scaleImage(UIImage* image, NSNumber* scaleParam) {
  double scale = 1.0;
  if ([scaleParam isKindOfClass:[NSNumber class]]) {
    scale = scaleParam.doubleValue;
  }
  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

static UIImage* ExtractBitmapDescriptor(NSObject<FlutterPluginRegistrar>* registrar, NSArray* bitmapData) {
  UIImage* image;
  if ([bitmapData.firstObject isEqualToString:@"fromAsset"]) {
    if (bitmapData.count == 2) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapData[1]]];
    } else {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapData[1]
                                                   fromPackage:bitmapData[2]]];
    }
  } else if ([bitmapData.firstObject isEqualToString:@"fromAssetImage"]) {
    if (bitmapData.count == 3) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapData[1]]];
      NSNumber* scaleParam = bitmapData[2];
      image = scaleImage(image, scaleParam);
    } else {
      NSString* error =
          [NSString stringWithFormat:@"'fromAssetImage' should have exactly 3 arguments. Got: %lu",
                                     (unsigned long)bitmapData.count];
      NSException* exception = [NSException exceptionWithName:@"InvalidBitmapDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  } else if ([bitmapData[0] isEqualToString:@"fromBytes"]) {
    if (bitmapData.count == 2) {
      @try {
        FlutterStandardTypedData* byteData = bitmapData[1];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        image = [UIImage imageWithData:[byteData data] scale:screenScale];
      } @catch (NSException* exception) {
        @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                       reason:@"Unable to interpret bytes as a valid image."
                                     userInfo:nil];
      }
    } else {
      NSString* error = [NSString
          stringWithFormat:@"fromBytes should have exactly one argument, the bytes. Got: %lu",
                           (unsigned long)bitmapData.count];
      NSException* exception = [NSException exceptionWithName:@"InvalidByteDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  }

  return image;
}
@end


@interface FLTGroundOverlaysController ()

@property(strong, nonatomic) NSMutableDictionary *groundOverlayIdToController;
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGroundOverlaysController

- (instancetype)initWithMapView:(GMSMapView *)mapView
                callbackHandler:(FGMMapsCallbackApi *)callbackHandler
                      registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  if (self) {
    _mapView = mapView;
    _groundOverlayIdToController = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToAdd {
  for (FGMPlatformGroundOverlay* groundOverlay in groundOverlaysToAdd) {
    NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId:groundOverlay];

    FLTGoogleMapGroundOverlayController* controller =
        [[FLTGoogleMapGroundOverlayController alloc] initWithGroundOverlay:groundOverlay
                                                                         mapView:self.mapView];
    [controller interpretGroundOverlayOptions:groundOverlay registrar:self.registrar];
    self.groundOverlayIdToController[groundOverlayId] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToChange {
  for (FGMPlatformGroundOverlay* groundOverlay in groundOverlaysToChange) {
    NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId:groundOverlay];
    FLTGoogleMapGroundOverlayController* controller = self.groundOverlayIdToController[groundOverlayId];
    if (!controller) {
      continue;
    }
    [controller interpretGroundOverlayOptions:groundOverlay registrar:self.registrar];
  }
}

- (void)removeGroundOverlayIds:(NSArray*)groundOverlayIdsToRemove {
  for (NSString* groundOverlayId in groundOverlayIdsToRemove) {
    if (!groundOverlayId) {
      continue;
    }
    FLTGoogleMapGroundOverlayController* controller = self.groundOverlayIdToController[groundOverlayId];
    if (!controller) {
      continue;
    }
    [controller removeGroundOverlay];
    [self.groundOverlayIdToController removeObjectForKey:groundOverlayId];
  }
}

- (bool)hasGroundOverlayWithId:(NSString*)groundOverlayId {
  if (!groundOverlayId) {
    return false;
  }
  return self.groundOverlayIdToController[groundOverlayId] != nil;
}

- (void)onGroundOverlayTap:(NSString*)groundOverlayId {
  if (!groundOverlayId) {
    return;
  }
  FLTGoogleMapGroundOverlayController* controller = self.groundOverlayIdToController[groundOverlayId];
  if (!controller) {
    return;
  }
  [controller onGroundOverlayTap:groundOverlayId];
//  [self.methodChannel invokeMethod:@"groundOverlay#onTap" arguments:@{@"groundOverlayId" : groundOverlayId}];
}

+ (GMSCoordinateBounds*)getBounds:(NSDictionary*)groundOverlay {
  NSArray* bounds = groundOverlay[@"bounds"];
  return ToLatLngBounds(bounds);
}

+ (UIImage*)getImage:(NSDictionary*)groundOverlay registrar:(NSObject<FlutterPluginRegistrar>*) registrar {
  NSArray* image = groundOverlay[@"bitmap"];
  return ExtractBitmapDescriptor(registrar, image);
}

+ (NSString*)getGroundOverlayId:(NSDictionary*)groundOverlay {
  return groundOverlay[@"groundOverlayId"];
}

@end
