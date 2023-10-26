package com.amazon.sample.maa.artstudio;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import com.amazon.device.associates.AssociatesAPI;
import com.amazon.device.associates.PurchaseResponse;
import com.amazon.device.associates.ServiceStatusResponse;
import com.amazon.device.associates.ShoppingListener;
import com.amazon.device.associates.ReceiptsResponse;
import com.amazon.device.associates.SearchByIdResponse;
import com.amazon.device.associates.SearchResponse;

public class MainActivity extends Activity implements ShoppingListener {

    private static final String TAG = MainActivity.class.getSimpleName();

    private GlobalPurchasingListener globalListener;

    /*
     * This map instance maps asin to id of the corresponding textView of the item in the layout class 
     */
    private Map<String, Integer> asinLayoutIdMap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        asinLayoutIdMap = new HashMap<String, Integer>();
        asinLayoutIdMap.put(Constants.EASEL_ASIN, R.id.easelValue);
        asinLayoutIdMap.put(Constants.DESK_ASIN, R.id.deskValue);
        asinLayoutIdMap.put(Constants.GUITAR_ASIN, R.id.guitarValue);
        asinLayoutIdMap.put(Constants.BRUSH_ASIN, R.id.brushValue);
        asinLayoutIdMap.put(Constants.PENCIL_ASIN, R.id.pencilValue);
        asinLayoutIdMap.put(Constants.STRING_ASIN, R.id.stringValue);

        globalListener = GlobalPurchasingListener.getInstance();
        globalListener.setContext(this);
        
        try {
            AssociatesAPI.Config config = new AssociatesAPI.Config("yourApplicationKey", this);
            AssociatesAPI.initialize(config);
            AssociatesAPI.getShoppingService().setListener(globalListener);
        } catch (final Exception e) {
            Log.e(TAG, "Error initializing AssociatesAPI: ", e);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        globalListener.setLocalListener(this);
        try {
            AssociatesAPI.getShoppingService().getServiceStatus();
        } catch (final Exception e) {
            Log.e(TAG, "Error calling ShoppingService.getServiceStatus(): ", e);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    public void storeAction(View view) {
        Intent intent = new Intent(this, StoreActivity.class);
        startActivity(intent);
    }

    // This method gets called when the "Paint a portrait" button in the activity is tapped
    public void paintAction(View view) {
        String userId = globalListener.getUserId();
        /*
         * The asynchronous onUserDataResponse callback has been called or finished
         * The user tapped on the button too fast, they should try in a few seconds
         */
        if (userId == null) {
            DialogHelper.showDialog(this, "Be a little more Patient :)",
                    "The app is still loading data, please give us a few seconds and try again.");
        } else {
            /*
             * Read the current inventory for easels and brushes from the SharedPreferences instances that uses the userId as filename
             * Check if there is at least one easel and one brush, display a dialog indicating paint action has been performed
             * and one brush has been consumed. Save the updated (-1) inventory of brushes back into the SharedPreferences instance
             * 
             * If there is no easel or brush at the moment, display corresponding dialog to indicate user has to buy more 
             */
            SharedPreferences sharedPreferences = getSharedPreferences(userId, MODE_PRIVATE);
            int numOfEasel = sharedPreferences.getInt(Constants.EASEL_ASIN, 0);
            int numOfBrush = sharedPreferences.getInt(Constants.BRUSH_ASIN, 0);

            if (numOfEasel > 0 && numOfBrush > 0) {
                numOfBrush -= 1;
                SharedPreferences.Editor editor = sharedPreferences.edit();
                editor.putInt(Constants.BRUSH_ASIN, numOfBrush);
                editor.commit();

                DialogHelper.showDialog(this, "Great painting!", "Painting consumes 1 brush of yours...");
                TextView textView = (TextView) findViewById(R.id.brushValue);
                textView.setText(Integer.toString(numOfBrush));
            } else if (numOfEasel == 0) {
                DialogHelper.showDialog(this, "Sorry", "You need to have at least 1 easel to be able to paint...");
            } else {
                DialogHelper.showDialog(this, "Sorry", "You need to shop for some brushes...");
            }
        }
    }

    // This method gets called when the "Write a poem" button in the activity is tapped
    public void writeAction(View view) {
        String userId = globalListener.getUserId();
        /*
         * The asynchronous onUserDataResponse callback has been called or finished
         * The user tapped on the button too fast, they should try in a few seconds
         */
        if (userId == null) {
            DialogHelper.showDialog(this, "Be a little more Patient :)",
                    "The app is still loading data, please give us a few seconds and try again.");
        } else {
            /*
             * Read the current inventory for desks and pencils from the SharedPreferences instances that uses the userId as filename
             * Check if there is at least one desk and one pencil, display a dialog indicating write action has been performed
             * and one brush has been consumed. Save the updated (-1) inventory of pencils back into the SharedPreferences instance
             * 
             * If there is no desk or pencil at the moment, display corresponding dialog to indicate user has to buy more 
             */
            SharedPreferences sharedPreferences = getSharedPreferences(userId, MODE_PRIVATE);
            int numOfDesk = sharedPreferences.getInt(Constants.DESK_ASIN, 0);
            int numOfPencil = sharedPreferences.getInt(Constants.PENCIL_ASIN, 0);

            if (numOfDesk > 0 && numOfPencil > 0) {
                numOfPencil -= 1;
                SharedPreferences.Editor editor = sharedPreferences.edit();
                editor.putInt(Constants.PENCIL_ASIN, numOfPencil);
                editor.commit();

                DialogHelper.showDialog(this, "Great poem!", "Writing consumes 1 pencil of yours...");
                TextView textView = (TextView) findViewById(R.id.pencilValue);
                textView.setText(Integer.toString(numOfPencil));
            } else if (numOfDesk == 0) {
                DialogHelper.showDialog(this, "Sorry", "You need to have at least 1 desk to be able to write...");
            } else {
                DialogHelper.showDialog(this, "Sorry", "You need to shop for some pencils...");
            }
        }
    }

    // This method gets called when the "play guitar" button in the activity is tapped
    public void playAction(View view) {
        String userId = globalListener.getUserId();
        /*
         * The asynchronous onUserDataResponse callback has been called or finished
         * The user tapped on the button too fast, they should try in a few seconds
         */
        if (userId == null) {
            DialogHelper.showDialog(this, "Be a little more Patient :)",
                    "The app is still loading data, please give us a few seconds and try again.");
        } else {
            /*
             * Read the current inventory for guitars and strings from the SharedPreferences instances that uses the userId as filename
             * Check if there is at least one guitar and one string, display a dialog indicating play action has been performed
             * and one string has been consumed. Save the updated (-1) inventory of strings back into the SharedPreferences instance
             * 
             * If there is no guitar or string at the moment, display corresponding dialog to indicate user has to buy more 
             */
            SharedPreferences sharedPreferences = getSharedPreferences(userId, MODE_PRIVATE);
            int numOfGuitar = sharedPreferences.getInt(Constants.GUITAR_ASIN, 0);
            int numOfString = sharedPreferences.getInt(Constants.STRING_ASIN, 0);

            if (numOfGuitar > 0 && numOfString > 0) {
                numOfString -= 1;
                SharedPreferences.Editor editor = sharedPreferences.edit();
                editor.putInt(Constants.STRING_ASIN, numOfString);
                editor.commit();

                DialogHelper.showDialog(this, "Great piece!", "Playing consumes 1 string of yours...");
                TextView textView = (TextView) findViewById(R.id.stringValue);
                textView.setText(Integer.toString(numOfString));
            } else if (numOfGuitar == 0) {
                DialogHelper.showDialog(this, "Sorry", "You need to have at least 1 guitar to be able to play...");
            } else {
                DialogHelper.showDialog(this, "Sorry", "You need to shop for some strings...");
            }
        }
    }

    @Override
    public void onServiceStatusResponse(ServiceStatusResponse response) {
    }

    @Override
    public void onPurchaseResponse(PurchaseResponse response) {
    }

    @Override
    public void onReceiptsResponse(ReceiptsResponse response) {
        if (response.getStatus() == ReceiptsResponse.Status.FAILED ||
        		response.getStatus() == ReceiptsResponse.Status.NOT_SUPPORTED) {
        	for (String asinKey : Constants.ASIN_LIST) {
                int layoutId = asinLayoutIdMap.get(asinKey);
                TextView textView = (TextView) findViewById(layoutId);
                textView.setText("No Record");
            }
        	
        	if (response.getStatus() == ReceiptsResponse.Status.FAILED) {
        		DialogHelper.showDialog(this, "Failure", "An error has occured while getting your receipts.");
        	} else {
        		DialogHelper.showDialog(this, "Sorry", "Digital bundling is not supported.");
        	}
        } else { 
            String userId = globalListener.getUserId();
            SharedPreferences sharedPreferences = getSharedPreferences(userId, MODE_PRIVATE);

            for (String asinKey : Constants.ASIN_LIST) {
                int layoutId = asinLayoutIdMap.get(asinKey);
                TextView textView = (TextView) findViewById(layoutId);
                textView.setText(Integer.toString(sharedPreferences.getInt(asinKey, 0)));
            }
        }
    }

    @Override
    public void onSearchByIdResponse(SearchByIdResponse response) {
    }

    @Override
    public void onSearchResponse(SearchResponse response) {
    }

}
