package io.flutter.plugins.googlemaps;


import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;


class GroundOverlayController implements GroundOverlayOptionsSink {
    private final GroundOverlay groundOverlay;
    private final String googleMapsGroundOverlayId;
    private boolean consumeTapEvents;

    GroundOverlayController(GroundOverlay groundOverlay, boolean consumeTapEvents) {
        this.groundOverlay = groundOverlay;
        this.googleMapsGroundOverlayId = this.groundOverlay.getId();
        setConsumeTapEvents(consumeTapEvents);
    }

    boolean consumeTapEvents() {
        return consumeTapEvents;
    }

    @Override
    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
        this.groundOverlay.setClickable(consumeTapEvents);
    }

    @Override
    public void setVisible(boolean visible) {
        this.groundOverlay.setVisible(visible);
    }

    @Override
    public void setZIndex(float zIndex) {
        this.groundOverlay.setZIndex(zIndex);
    }

    void remove() {
        groundOverlay.remove();
    }

    @Override
    public void setPosition(LatLng location, float width) {
        this.groundOverlay.setPosition(location);
        this.groundOverlay.setDimensions(width);
    }

    @Override
    public void setPosition(LatLng location, float width, float height) {
        this.groundOverlay.setPosition(location);
        this.groundOverlay.setDimensions(width, height);
    }

    @Override
    public void setPosition(LatLngBounds bounds) {
        this.groundOverlay.setPositionFromBounds(bounds);
    }

    @Override
    public void setImage(BitmapDescriptor bd) {
        this.groundOverlay.setImage(bd);
    }

    @Override
    public void setBearing(float bearing) {
        this.groundOverlay.setBearing(bearing);
    }

    @Override
    public void setTransparency(float transparency) {
        this.groundOverlay.setTransparency(transparency);
    }

    String getGoogleMapsGroundOverlayId() {
        return this.googleMapsGroundOverlayId;
    }
}