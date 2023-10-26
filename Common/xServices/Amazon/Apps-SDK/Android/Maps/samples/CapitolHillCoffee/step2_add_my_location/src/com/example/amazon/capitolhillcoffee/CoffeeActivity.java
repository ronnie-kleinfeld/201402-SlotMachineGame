package com.example.amazon.capitolhillcoffee;

import com.amazon.geo.maps.GeoPoint;
import com.amazon.geo.maps.MapActivity;
import com.amazon.geo.maps.MapController;
import com.amazon.geo.maps.MapView;
import com.amazon.geo.maps.MyLocationOverlay;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.Toast;

/**
 *
 * Activity class for coffee shop app.
 *
 */
public class CoffeeActivity extends MapActivity {
    // Zoom used when displaying user's location
    private static final int FINDME_ZOOM = 18;

    private MapView mMapView;
    private MyLocationOverlay mLocationOverlay;

    /**
     * Upon creation, this demo app:
     *      - creates a stock mapview and turns on the zoom control widget
     *      - adds one navigation button to find user's location
     *      - adds my location overlay to display the user's location
     */
    @Override
    public void onCreate(final Bundle icicle) {
        super.onCreate(icicle);

        setContentView(R.layout.main);

        // Extract a reference to the map view
        mMapView = (MapView) findViewById(R.id.mapview);

        // Turn on the zoom control widget
        mMapView.setBuiltInZoomControls(true);

        // Add 'find me' button to top right corner
        final ImageView image = (ImageView)findViewById(R.id.find_me);
        // When the user clicks, navigate to my location (if known)
        image.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                findMe();
            }
        });

        // Create my location overlay
        mLocationOverlay = new MyLocationOverlay(this, mMapView);
        // Turn my location overlay on, so that it displays user's location (if any)
        mLocationOverlay.enableMyLocation();
        // Add my location overlay to list of overlays
        mMapView.getOverlays().add(mLocationOverlay);
    }

    /**
     *  Set center and zoom to the user's location
     */
    private void findMe() {
        // Obtain the last known location
        final LocationManager locationManager =
                (LocationManager) getSystemService(LOCATION_SERVICE);
        final String bestProvider = locationManager.getBestProvider(new Criteria(), false);
        final Location location = locationManager.getLastKnownLocation(bestProvider);
        // Note: we might want to ignore 'stale' location readings

        if (location == null) {
            Toast.makeText(this, "Could not obtain location", Toast.LENGTH_LONG).show();
        } else {
            final MapController controller = mMapView.getController();
            final GeoPoint myLocation = new GeoPoint(
                    (int)Math.round(location.getLatitude() * 1E6),
                    (int)Math.round(location.getLongitude() * 1E6));
            controller.animateTo(myLocation);
            controller.setZoom(FINDME_ZOOM);
        }
    }

    // Override required by interface
    @Override
    protected boolean isRouteDisplayed() {
        return false;
    }
}
