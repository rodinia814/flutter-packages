package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

interface GroundOverlayOptionsSink {
    void setConsumeTapEvents(boolean consumeTapEvents);

    void setVisible(boolean visible);

    void setZIndex(float zIndex);

    void setLocation(LatLng location, Float width, Float height, LatLngBounds bounds);

    void setBitmapDescriptor(BitmapDescriptor bd);

    void setBearing(float bearing);

    void setTransparency(float transparency);

}