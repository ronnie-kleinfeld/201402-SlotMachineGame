package com.example.amazon.capitolhillcoffee;

import com.amazon.geo.maps.GeoPoint;
import com.amazon.geo.maps.ItemizedOverlay;
import com.amazon.geo.maps.OverlayItem;

import android.content.Context;
import android.graphics.drawable.Drawable;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * Displays coffee shops on a map. Each coffee shop is indicated with a coffee shop
 * icon. When the user taps a coffee shop icon, details about that coffee shop are displayed.
 *
 */
public class CoffeeOverlay extends ItemizedOverlay<OverlayItem> {
    private final Context mContext;
    private final List<CoffeeShop> mShops = new ArrayList<CoffeeShop>();

    /**
     * Creates a coffee overlay with the given Drawable as the default icon.
     */
    public CoffeeOverlay(final Context context, final Drawable defaultMarker) {
        // Center of icon is bound to actual location
        super(boundCenter(defaultMarker));
        mContext = context;
    }

    /**
     * Handles user tap on a coffee shop icon. Displays details about coffee shop
     */
    @Override
    protected boolean onTap(final int index) {
        // Get shop that the user tapped on
        final CoffeeShop shop = mShops.get(index);
        // Display it
        CoffeeDetails.display(mContext, shop);
        // Return true to indicate we handled the tap event
        return true;
    }

    /**
     * Updates the coffee overlay by clearing all old shops and loading new ones,
     * based upon current map view.
     */
    void update(final GeoPoint mapCenter, final int zoomLevel) {
        // Clear old shops and load new ones
        mShops.clear();
        CoffeeFetcher.fetchCoffee(mapCenter, zoomLevel, mShops);

        // Call class's populate(), which will call this class' size() and then this class'
        // createItem() once for each item
        populate();
    }

    /**
     * Returns requested item (callback from super.populate)
     */
    @Override
    protected OverlayItem createItem(final int i) {
        return mShops.get(i).getItem();
    }

    /**
     * Returns item count (callback from super.populate)
     */
    @Override
    public int size() {
        return mShops.size();
    }

}
