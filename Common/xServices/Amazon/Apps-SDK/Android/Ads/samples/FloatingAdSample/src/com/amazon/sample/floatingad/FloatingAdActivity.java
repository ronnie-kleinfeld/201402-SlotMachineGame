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

package com.amazon.sample.floatingad;

import com.amazon.device.ads.*;

import android.app.Activity;
import android.os.Bundle;
import android.view.*;
import android.view.animation.*;
import android.view.animation.Animation.AnimationListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.*;
import android.widget.FrameLayout.LayoutParams;
import android.util.*;

/**
 * This is a simple app for testing ad loading capabilities of the Amazon Mobile Ads API. 
 * This app demonstrates how to load an ad that floats in from the bottom of the screen.
 */
public class FloatingAdActivity extends Activity implements AdListener {
    
    private static final String APP_KEY = "sample-app-v1_pub-2"; // Sample Application Key. Replace this variable with your Application Key
    private static final String LOG_TAG = "FloatingAdSample"; // Tag used to prefix all log messages
    
    private ViewGroup adViewContainer; // View group to which the ad view will be added
    private AdLayout currentAdView; // The ad that is currently visible to the user
    private AdLayout nextAdView; // A placeholder for the next ad so we can keep the current ad visible while the next ad loads
        
    /**
     * When the activity starts, load an ad and set up the button click event to load another ad when it's clicked.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        adViewContainer = (ViewGroup)findViewById(R.id.root_layout);
        
        // For debugging purposes enable logging, but disable for production builds
        AdRegistration.enableLogging(true);
        // For debugging purposes flag all ad requests as tests, but set to false for production builds
        AdRegistration.enableTesting(true);
        
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
        
        // Load the webview. This webview is used to illustrate how the floating ad overlays
        // the view's content.
        WebView webview = (WebView) findViewById(R.id.webview);
        webview.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }
        });
        webview.loadUrl("http://www.amazon.com");
        
        // Load the ad when the activity starts.
        LoadAd();
    }

    /**
     * Clean up all ad view resources when destroying the activity.
     */
    @Override
    public void onDestroy() {
        super.onDestroy();
        if (currentAdView != null)
            this.currentAdView.destroy();
        if (nextAdView != null)
            this.nextAdView.destroy();
    }
    
    /**
     * Loads a new ad. Keeps the current ad visible while the next ad loads.
     */
    private void LoadAd() {
        if (nextAdView == null) { // Create and configure a new ad if the next ad doesn't currently exist
            nextAdView = new AdLayout(this);
            LayoutParams layoutParams = new FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT,
            		LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
            
            // Note: The above implementation is for an auto-sized ad in an AdLayout of width MATCH_PARENT and
            // height WRAP_CONTENT. If you instead want to give the ad a fixed size, you will need to factor in
            // the phone's scale when setting up the AdLayout dimensions. See the example below for 320x50 dpi:
            //    nextAdView = new AdLayout(this, AdSize.SIZE_320x50);
            //    float scale = this.getApplicationContext().getResources().getDisplayMetrics().density;
            //    LayoutParams layoutParams = new FrameLayout.LayoutParams((int) (320 * scale),
            //	          (int) (50 * scale), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
            
            nextAdView.setLayoutParams(layoutParams);
            // Register our ad handler that will receive call-backs for state changes during the ad life cycle        
            nextAdView.setListener(this);
        }
                
        // Load the ad with the appropriate ad options.
        AdTargetingOptions adOptions = new AdTargetingOptions();
        nextAdView.loadAd(adOptions);
    }
    
    /**
     * Shows the ad that is in the current ad view to the user.
     */
    private void ShowCurrentAd() {
        adViewContainer.addView(currentAdView);
        Animation slideUp = AnimationUtils.loadAnimation(FloatingAdActivity.this, R.anim.slide_up);
        currentAdView.startAnimation(slideUp);
    }
    
    /**
     * Shows the ad that is in the next ad view to the user.
     */
    private void ShowNextAd() {
        adViewContainer.removeView(currentAdView);
        AdLayout tmp = currentAdView;
        currentAdView = nextAdView;
        nextAdView = tmp;
        ShowCurrentAd();
    }
    
    /**
     * Hides the ad that is in the current ad view, and then displays the ad that is in the next ad view.
     */
    private void SwapCurrentAd() {
                
        Animation slideDown = AnimationUtils.loadAnimation(FloatingAdActivity.this, R.anim.slide_down);
        slideDown.setAnimationListener(new AnimationListener() {

            public void onAnimationEnd(Animation animation) {
               ShowNextAd();
            }

            public void onAnimationRepeat(Animation animation) {
                
            }
            public void onAnimationStart(Animation animation) {
                
            }
            
        });
        currentAdView.startAnimation(slideDown);
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
        // If there is an ad currently being displayed, swap the ad that just loaded
        // with ad currently being displayed, else display the ad that just loaded.
        if (currentAdView != null) {
            SwapCurrentAd();
        } else {
            // This is the first time we're loading an ad, so set the
            // current ad view to the ad we just loaded and set the next to null
            // so that we can load a new ad in the background.
            currentAdView = nextAdView;
            nextAdView = null;
            ShowCurrentAd();
        }
    }

    /**
     * This event is called after a rich media ad expands.
     */
    @Override
    public void onAdExpanded(AdLayout view) {
        Log.d(LOG_TAG, "Ad expanded.");
    }
}
