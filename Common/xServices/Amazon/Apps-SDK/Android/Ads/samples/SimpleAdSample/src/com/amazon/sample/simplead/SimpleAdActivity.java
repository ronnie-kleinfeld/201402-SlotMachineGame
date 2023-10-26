/**
 * Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at http://aws.amazon.com/apache2.0/
 * or in the "license" file accompanying this file.
 * This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. 
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.amazon.sample.simplead;

import com.amazon.device.ads.*;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

/**
 * This is a simple app for testing ad loading capabilities of the Amazon Mobile Ads API. 
 * This app demonstrates ad loading, expanding and collapsing along with device rotation.
 */
public class SimpleAdActivity extends Activity implements AdListener
{
    private AdLayout adView; // The ad view used to load and display the ad.
    private static final String APP_KEY = "sample-app-v1_pub-2"; // Sample Application Key. Replace this variable with your Application Key
    private static final String LOG_TAG = "SimpleAdSample"; // Tag used to prefix all log messages
    
    /**
     * When the activity starts, load an ad and set up the button click event to load another ad when it's clicked.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        // For debugging purposes enable logging, but disable for production builds
        AdRegistration.enableLogging(true);
        // For debugging purposes flag all ad requests as tests, but set to false for production builds
        AdRegistration.enableTesting(true);
        
        adView = (AdLayout)findViewById(R.id.ad_view);
        adView.setListener(this);
        
        try {
            AdRegistration.setAppKey(APP_KEY);
        } catch (Exception e) {
            Log.e(LOG_TAG, "Exception thrown: " + e.toString());
            return;
        }
                
        // Assign an onclick handler to the button that will load our ad.
        Button button = (Button) findViewById(R.id.load_ad_button);
        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                LoadAd();
            }
        });
        
        // Calling load ad in the Activity's onCreate method allows a new ad to be loaded 
        // when the application starts and also when the device is rotated.
        LoadAd();
    }
    
    /**
     * Load a new ad.
     */
    public void LoadAd() { 
        // Load the ad with the appropriate ad targeting options.
        AdTargetingOptions adOptions = new AdTargetingOptions();
        adView.loadAd(adOptions);
    }
    
    /**
     * This event is called after a rich media ads has collapsed from an expanded state.
     */
    @Override
    public void onAdCollapsed(AdLayout view) {
        Log.d(LOG_TAG, "Ad collapsed.");
    }

    /**
     * This event is called if an ad fails to load.
     */
    @Override
    public void onAdFailedToLoad(AdLayout view, AdError error) {
        Log.w(LOG_TAG, "Ad failed to load. Code: " + error.getCode() + ", Message: " + error.getMessage());
    }

    /**
     * This event is called once an ad loads successfully.
     */
    @Override
    public void onAdLoaded(AdLayout view, AdProperties adProperties) {
        Log.d(LOG_TAG, adProperties.getAdType().toString() + " Ad loaded successfully.");
    }

    /**
     * This event is called after a rich media ad expands.
     */
    @Override
    public void onAdExpanded(AdLayout view) {
        Log.d(LOG_TAG, "Ad expanded.");
    }
}
