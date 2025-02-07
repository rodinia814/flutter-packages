// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "GoogleMapGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"

static UIImage* ExtractBitmapDescriptor(NSObject<FlutterPluginRegistrar>* registrar, NSArray* bitmap);

static BOOL ToBool(NSNumber* data) { return [FLTGoogleMapJSONConversions toBool:data]; }

static double ToDouble(NSNumber* data) { return [FLTGoogleMapJSONConversions toDouble:data]; }

static float ToFloat(NSNumber* data) { return [FLTGoogleMapJSONConversions toFloat:data]; }

static CLLocationCoordinate2D ToPosition(NSArray* data) {
  return [FLTGoogleMapJSONConversions toLocation:data];
}

static GMSCoordinateBounds* ToLatLngBounds(NSArray* data) {
  return [[GMSCoordinateBounds alloc] initWithCoordinate:ToPosition(data[0])
                                              coordinate:ToPosition(data[1])];
}

@interface FLTGoogleMapGroundOverlayController ()

  @property(strong, nonatomic) GMSGroundOverlay *groundOverlay;
  @property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGoogleMapGroundOverlayController

- (instancetype)initGroundOverlayWithPosition:(CLLocationCoordinate2D)position
                                         icon:(UIImage*)icon
                                    zoomLevel:(CGFloat)zoomLevel
                              groundOverlayId:(NSString*)groundOverlayId
                                      mapView:(GMSMapView*)mapView {
  self = [super init];
  if (self) {
    _groundOverlay = [GMSGroundOverlay groundOverlayWithPosition:position icon:icon zoomLevel:zoomLevel];
    _mapView = mapView;
    _groundOverlayId = groundOverlayId;
    _groundOverlay.userData = @[ _groundOverlayId ];
  }
  return self;
}

- (instancetype)initGroundOverlayWithBounds:(GMSCoordinateBounds*)bounds
                                       icon:(UIImage*)icon
                            groundOverlayId:(NSString*)groundOverlayId
                                    mapView:(GMSMapView*)mapView {
  self = [super init];
  if (self) {
    _groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:bounds icon:icon];
    _mapView = mapView;
    _groundOverlayId = groundOverlayId;
    _groundOverlay.userData = @[ _groundOverlayId ];
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
  self.groundOverlay.width = width;
  self.groundOverlay.height = height;
}
- (void)setImage:(UIImage*)bd {
  self.groundOverlay.icon = bd;
}
- (void)setBearing:(CLLocationDirection)bearing {
  self.groundOverlay.bearing = bearing;
}
- (void)setTransparency:(float)transparency {
  self.groundOverlay.transparency = transparency;
}

- (void)interpretGroundOverlayOptions:(NSDictionary *)data
                                       registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents && consumeTapEvents != (id)[NSNull null]) {
    [self setConsumeTapEvents:ToBool(consumeTapEvents)];
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
    float transparency = ToFloat(transparency);
    [self setTransparency:transparency];
  }
  NSNumber* width = data[@"width"];
  NSNumber* height = data[@"height"];
  NSArray* position = data[@"position"];
  if (position) {
    if (height != nil) {
      [self setPosition:ToPosition(position) width:ToDouble(width) height:ToDouble(height)];
    } else {
      if (width != nil) {
        [self setPosition:ToPosition(position) width:ToDouble(width) height:0];
      }
    }
  }
  NSArray* bounds = data[@"bounds"];
  if (bounds) {
    [self setBounds:ToLatLngBounds(bounds)];
  }
  NSNumber* bearing = data[@"bearing"];
  if (bearing && bearing != (id)[NSNull null]) {
    [self setBearing:ToFloat(bearing)];
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
@property(strong, nonatomic) FlutterMethodChannel *methodChannel;
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGroundOverlaysController

- (instancetype)init:(FlutterMethodChannel *)methodChannel
             mapView:(GMSMapView *)mapView
           registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _groundOverlayIdToController = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}

- (void)addGroundOverlays:(NSArray*)groundOverlaysToAdd {
  for (NSDictionary* groundOverlay in groundOverlaysToAdd) {
    GMSCoordinateBounds* bounds = [FLTGroundOverlaysController getBounds:groundOverlay];
    UIImage* icon = [FLTGroundOverlaysController getImage:groundOverlay registrar:_registrar];
    NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId:groundOverlay];

    FLTGoogleMapGroundOverlayController* controller =
        [[FLTGoogleMapGroundOverlayController alloc] initGroundOverlayWithBounds:bounds
                                                                            icon:icon
                                                                 groundOverlayId:groundOverlayId
                                                                         mapView:self.mapView];
    [controller interpretGroundOverlayOptions:groundOverlay registrar:self.registrar];
    self.groundOverlayIdToController[groundOverlayId] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray*)groundOverlaysToChange {
  for (NSDictionary* groundOverlay in groundOverlaysToChange) {
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
  [self.methodChannel invokeMethod:@"groundOverlay#onTap" arguments:@{@"groundOverlayId" : groundOverlayId}];
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