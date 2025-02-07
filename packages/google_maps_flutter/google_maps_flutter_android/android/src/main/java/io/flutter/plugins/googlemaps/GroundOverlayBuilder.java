package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;


class GroundOverlayBuilder implements GroundOverlayOptionsSink {
    private final GroundOverlayOptions groundOverlayOptions;
    private boolean consumeTapEvents;

    GroundOverlayBuilder() {
        groundOverlayOptions = new GroundOverlayOptions();
    }

    GroundOverlayOptions build() {
        return groundOverlayOptions;
    }

    boolean consumeTapEvents() {
        return consumeTapEvents;
    }

    @Override
    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
        groundOverlayOptions.clickable(consumeTapEvents);
    }

    @Override
    public void setVisible(boolean visible) {
        groundOverlayOptions.visible(visible);
    }

    @Override
    public void setZIndex(float zIndex) {
        groundOverlayOptions.zIndex(zIndex);
    }

    @Override
    public void setPosition(LatLng location, float width) {
        groundOverlayOptions.position(location, width);
    }

    @Override
    public void setPosition(LatLng location, float width, float height) {
        groundOverlayOptions.position(location, width, height);
    }

    @Override
    public void setPosition(LatLngBounds bounds) {
        groundOverlayOptions.positionFromBounds(bounds);
    }

    @Override
    public void setImage(BitmapDescriptor bd) {
        groundOverlayOptions.image(bd);
    }

    @Override
    public void setBearing(float bearing) {
        groundOverlayOptions.bearing(bearing);
    }

    @Override
    public void setTransparency(float transparency) {
        groundOverlayOptions.transparency(transparency);
    }

}