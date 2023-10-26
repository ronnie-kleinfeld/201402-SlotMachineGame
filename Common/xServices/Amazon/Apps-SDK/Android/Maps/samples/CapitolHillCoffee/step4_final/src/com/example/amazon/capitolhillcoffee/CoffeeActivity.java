package com.example.amazon.capitolhillcoffee;

import com.amazon.geo.maps.GeoPoint;
import com.amazon.geo.maps.MapActivity;
import com.amazon.geo.maps.MapController;
import com.amazon.geo.maps.MapView;
import com.amazon.geo.maps.MyLocationOverlay;

import android.graphics.drawable.Drawable;
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
    // Center and zoom the map so that all the coffee shops are visible
    private static final int COFFEE_LATITUDE = 47624548;
    private static final int COFFEE_LONGITUDE = -122321006;
    private static final GeoPoint COFFEE_LOCATION = new GeoPoint(COFFEE_LATITUDE, COFFEE_LONGITUDE);
    private static final int COFFEE_ZOOM = 19;

    // Zoom used when displaying user's location
    private static final int FINDME_ZOOM = 18;

    private MapView mMapView;
    private MyLocationOverlay mLocationOverlay;
    private CoffeeOverlay mCoffeeOverlay;

    /**
     * Upon creation, this demo app:
     *      - creates a stock mapview and turns on the zoom control widget
     *      - adds two navigation buttons: one to find coffee, one to find user's location
     *      - adds my location overlay to display the user's location
     *      - adds coffee shop overlay to display coffee shops
     *      - navigates the map to Capitol Hill, Seattle and displays coffee shops
     */
    @Override
    public void onCreate(final Bundle icicle) {
        super.onCreate(icicle);

        setContentView(R.layout.main);

        // Extract a reference to the map view
        mMapView = (MapView) findViewById(R.id.mapview);

        // Turn on the zoom control widget
        mMapView.setBuiltInZoomControls(true);

        // Add 'find coffee' button to top left corner
        ImageView image = (ImageView)findViewById(R.id.find_coffee);
        // When the user clicks, navigate to coffee shops
        image.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(final View v) {
                findCoffee();
            }
        });

        // Add 'find me' button to top right corner
        image = (ImageView)findViewById(R.id.find_me);
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

        // Create the coffee shop icon
        final Drawable coffeeMarker = this.getResources().getDrawable(R.drawable.coffeeshop);
        // Create coffee shop itemized overlay, using the coffee shop icon as the default marker
        mCoffeeOverlay = new CoffeeOverlay(this, coffeeMarker);
        // Add to list of overlays
        mMapView.getOverlays().add(mCoffeeOverlay);

        // After all this activity, I could use a coffee
        findCoffee();
    }

    /**
     *
     * Display coffee shops.
     *
     * For this demo app, the coffee shop data is static and only covers coffee shops in a small
     * area of Capitol Hill, Seattle. Therefore, the 'find coffee' button first moves the map to
     * display Capitol Hill and then updates the coffee shop overlay.
     *
     * In a production app, this button would instead display coffee shops within the visible
     * region of the map view. (This visible region can be determined based upon the map center,
     * map zoom level, and map view size.) It would do so by querying a custom coffee shop
     * webservice which would return coffee shop data for that visible region.
     */
    private void findCoffee() {
        // Set center and zoom so that capitol hill is visible
        final MapController controller = mMapView.getController();
        controller.animateTo(COFFEE_LOCATION);
        controller.setZoom(COFFEE_ZOOM);

        // Update the coffee shop overlay, given the current map view
        mCoffeeOverlay.update(mMapView.getMapCenter(), mMapView.getZoomLevel());
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
