package com.example.amazon.capitolhillcoffee;

import com.amazon.geo.maps.GeoPoint;

import java.util.List;

/**
 *
 * Fetches coffee shops details.
 *
 */
public class CoffeeFetcher {

    private static final CoffeeShop[] COFFEE_SHOPS = {
            new CoffeeShop(
                    "Joe Bar Cafe",
                    "810 East Roy Street",
                    "(206) 324-0407",
                    new GeoPoint(47625148, -122321623)),
            new CoffeeShop(
                    "Roy Street Coffee and Tea",
                    "700 Broadway Ave East",
                    "(206) 325-2211",
                    new GeoPoint(47625206, -122321108)),
            new CoffeeShop(
                    "Vivace Espresso Bar",
                    "532 Broadway Ave East",
                    "(206) 860-2722",
                    new GeoPoint(47623749, -122320861)),
            new CoffeeShop(
                    "Dilettante Mocha Cafe",
                    "538 Broadway Ave East",
                    "(206) 329-6463",
                    new GeoPoint(47623922, -122320861)),
            new CoffeeShop(
                    "Starbucks",
                    "700 Broadway Ave East",
                    "(206) 325-2211",
                    new GeoPoint(47625495, -122321287)),
            new CoffeeShop(
                    "Starbucks",
                    "434 Broadway Ave East",
                    "(206) 323-7888",
                    new GeoPoint(47623058, -122320792)),
            new CoffeeShop(
                    "Cafe Canape",
                    "700 Broadway Ave East",
                    "(206) 708-1210",
                    new GeoPoint(47625401,-122320791)),
    };

    /**
     * Updates the list of coffee shops.
     *
     * This demo uses a hard-coded set of coffee shops, regardless of the current map view.
     *
     * In a production application, the coffee shop data would be obtained from a webservice.
     * The webservice query would take the map view bounds and only return coffee shops in view.
     */
    public static void fetchCoffee(
            final GeoPoint mapCenter,
            final int zoomLevel,
            final List<CoffeeShop> shops) {

        // Ignore map view bounds and just return static set of shops
        for (final CoffeeShop shop : COFFEE_SHOPS) {
            shops.add(shop);
        }
    }

}
