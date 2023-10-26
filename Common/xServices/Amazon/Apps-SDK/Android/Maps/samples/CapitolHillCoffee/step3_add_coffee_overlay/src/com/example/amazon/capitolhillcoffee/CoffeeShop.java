package com.example.amazon.capitolhillcoffee;

import com.amazon.geo.maps.GeoPoint;
import com.amazon.geo.maps.OverlayItem;

/**
 * Represents a coffee shop.
 */
public class CoffeeShop {
    private final String title;
    private final String address;
    private final String phone;
    private final GeoPoint location;

    public CoffeeShop(
            final String title,
            final String address,
            final String phone,
            final GeoPoint location) {
        this.title = title;
        this.address = address;
        this.phone = phone;
        this.location = location;
    }

    public String getTitle() {
        return title;
    }

    public String getAddress() {
        return address;
    }

    public String getPhone() {
        return phone;
    }

    public GeoPoint getLocation() {
        return location;
    }

    public OverlayItem getItem() {
        return new OverlayItem(location, title, null);
    }
}
