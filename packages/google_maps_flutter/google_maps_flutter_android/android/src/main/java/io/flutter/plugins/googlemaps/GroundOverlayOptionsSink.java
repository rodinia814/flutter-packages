package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

interface GroundOverlayOptionsSink {
    void setConsumeTapEvents(boolean consumeTapEvents);

    void setPosition(LatLng location, float width);
    void setPosition(LatLng location, float width, float height);
    void setPosition(LatLngBounds bounds);

    void setImage(BitmapDescriptor bd);

    void setBearing(float bearing);

    void setTransparency(float transparency);

    void setVisible(boolean visible);

    void setZIndex(float zIndex);

}