package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;

interface GroundOverlayOptionsSink {
    void setConsumeTapEvents(boolean consumeTapEvents);

    void setVisible(boolean visible);

    void setZIndex(float zIndex);

    void setLocation(LatLng location, float width, float height, LatLngBounds bounds);

    void setBitmapDescriptor(BitmapDescriptor bd);

    void setBearing(float bearing);

}