package io.flutter.plugins.googlemaps;

import androidx.annotation.NonNull;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.GroundOverlayOptions;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugins.googlemaps.Messages.MapsCallbackApi;

class GroundOverlaysController {

    private GoogleMap googleMap;
    private final Map<String, GroundOverlayController> groundOverlayIdToController;
    private final Map<String, String> googleMapsGroundOverlayIdToDartOverlayId;
    private final MapsCallbackApi flutterApi;

    GroundOverlaysController(MapsCallbackApi flutterApi) {
        this.flutterApi = flutterApi;
        this.groundOverlayIdToController = new HashMap<>();
        this.googleMapsGroundOverlayIdToDartOverlayId = new HashMap<>();
    }

    void setGoogleMap(GoogleMap googleMap) {
        this.googleMap = googleMap;
    }

    void addGroundOverlays(@NonNull List<Messages.PlatformGroundOverlay> groundOverlaysToAdd) {
            for (Messages.PlatformGroundOverlay groundOverlayToAdd : groundOverlaysToAdd) {
                addGroundOverlay(groundOverlayToAdd);
            }
    }

    private void addGroundOverlay(@NonNull Messages.PlatformGroundOverlay groundOverlay) {
        GroundOverlayBuilder groundOverlayBuilder = new GroundOverlayBuilder();
        String groundOverlayId = Convert.interpretGroundOverlayOptions(groundOverlay, groundOverlayBuilder);
        GroundOverlayOptions options = groundOverlayBuilder.build();
        addGroundOverlay(groundOverlayId, options, groundOverlayBuilder.consumeTapEvents());
    }

    private void addGroundOverlay(
            String groundOverlayId, GroundOverlayOptions groundOverlayOptions, boolean consumeTapEvents) {
        final GroundOverlay groundOverlay = googleMap.addGroundOverlay(groundOverlayOptions);

        GroundOverlayController controller = new GroundOverlayController(groundOverlay, consumeTapEvents);
        groundOverlayIdToController.put(groundOverlayId, controller);
        googleMapsGroundOverlayIdToDartOverlayId.put(groundOverlay.getId(), groundOverlayId);

    }

    boolean onGroundOverlayTap(String googleOverlayId) {
        String overlayId = googleMapsGroundOverlayIdToDartOverlayId.get(googleOverlayId);
        if (overlayId == null) {
            return false;
        }
        flutterApi.onGroundOverlayTap(googleOverlayId, new NoOpVoidResult());
        GroundOverlayController groundOverlayController = groundOverlayIdToController.get(overlayId);
        if (groundOverlayController != null) {
            return groundOverlayController.consumeTapEvents();
        }
        return false;
    }

    void changeGroundOverlays(List<Messages.PlatformGroundOverlay> groundOverlaysToChange) {
        if (groundOverlaysToChange != null) {
            for (Messages.PlatformGroundOverlay groundOverlayToChange : groundOverlaysToChange) {
                changeGroundOverlay(groundOverlayToChange);
            }
        }
    }

    private void changeGroundOverlay(Messages.PlatformGroundOverlay groundOverlay) {
        if (groundOverlay == null) {
            return;
        }
        String groundOverlayId = groundOverlay.getGroundOverlayId();
        GroundOverlayController groundOverlayController = groundOverlayIdToController.get(groundOverlayId);
        if (groundOverlayController != null) {
            Convert.interpretGroundOverlayOptions(groundOverlay, groundOverlayController);
        }
    }

    void removeGroundOverlays(List<String> groundOverlaysToRemove) {
        if (groundOverlaysToRemove == null) {
            return;
        }

        for (Object rawGroundOverlayId : groundOverlaysToRemove) {
            if (rawGroundOverlayId == null) {
                continue;
            }
            String groundOverlayId = (String) rawGroundOverlayId;
            final GroundOverlayController groundOverlayController = groundOverlayIdToController.remove(groundOverlayId);
            if (groundOverlayController != null) {
                groundOverlayController.remove();
                googleMapsGroundOverlayIdToDartOverlayId.remove(groundOverlayController.getGoogleMapsGroundOverlayId());
            }
        }
    }
}