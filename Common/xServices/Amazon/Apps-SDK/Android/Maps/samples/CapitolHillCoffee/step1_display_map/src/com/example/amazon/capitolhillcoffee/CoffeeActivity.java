package com.example.amazon.capitolhillcoffee;

import com.amazon.geo.maps.MapActivity;
import com.amazon.geo.maps.MapView;

import android.os.Bundle;

/**
 *
 * Activity class for coffee shop app.
 *
 */
public class CoffeeActivity extends MapActivity {
    private MapView mMapView;

    /**
     * Upon creation, this demo app:
     *      - creates a stock mapview and turns on the zoom control widget
     */
    @Override
    public void onCreate(final Bundle icicle) {
        super.onCreate(icicle);

        setContentView(R.layout.main);

        // Extract a reference to the map view
        mMapView = (MapView) findViewById(R.id.mapview);

        // Turn on the zoom control widget
        mMapView.setBuiltInZoomControls(true);

    }

    // Override required by interface
    @Override
    protected boolean isRouteDisplayed() {
        return false;
    }
}
