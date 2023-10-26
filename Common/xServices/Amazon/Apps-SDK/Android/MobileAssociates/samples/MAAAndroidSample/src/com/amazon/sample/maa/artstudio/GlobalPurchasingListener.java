package com.amazon.sample.maa.artstudio;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.amazon.device.associates.AssociatesAPI;
import com.amazon.device.associates.ServiceStatusResponse;
import com.amazon.device.associates.ShoppingListener;
import com.amazon.device.associates.Offset;
import com.amazon.device.associates.PurchaseResponse;
import com.amazon.device.associates.Receipt;
import com.amazon.device.associates.ReceiptsRequest;
import com.amazon.device.associates.ReceiptsResponse;
import com.amazon.device.associates.SearchByIdResponse;
import com.amazon.device.associates.SearchResponse;

public class GlobalPurchasingListener implements ShoppingListener {
    private static final String TAG = "GlobalPurchasingListener.class";

    private static final GlobalPurchasingListener instance = new GlobalPurchasingListener();
    private static Context context = null;
    private static boolean isSDKInitialized = false;
    private static String userId = null;
    private static boolean canGetReceipts = false;
    private static ShoppingListener localListener = null;

    private GlobalPurchasingListener() {
    }

    public static GlobalPurchasingListener getInstance() {
        return instance;
    }

    public void setContext(Context appContext) {
        context = appContext;
    }

    public void setLocalListener(ShoppingListener listener) {
        localListener = listener;
    }

    public boolean getIsSDKInitialized() {
        return isSDKInitialized;
    }

    public String getUserId() {
        return userId;
    }

    public boolean canGetReceipts() {
        return canGetReceipts;
    }

    @Override
    public void onServiceStatusResponse(ServiceStatusResponse response) {
        Log.i(TAG, "onServiceStatusResponse: " + response);

        isSDKInitialized = true;
        userId = null;
        if (response.getUserData() != null) {
            userId = response.getUserData().getUserId();
        }

        canGetReceipts = response.canGetReceipts();
        if (true) {
            SharedPreferences sharedPreferences = context.getSharedPreferences(userId, Context.MODE_PRIVATE);
            String offset = sharedPreferences.getString(Constants.OFFSET_KEY, Offset.BEGINNING.toString());

            ReceiptsRequest request = new ReceiptsRequest(Offset.fromString(offset));
            try {
                AssociatesAPI.getShoppingService().getReceipts(request);
            } catch (final Exception e) {
                Log.e(TAG, "Error calling ShoppingService.getReceipts: ", e);
            }
        }

        /*
         *  Dispatch response to corresponding callback in localListner.
         *  
         *  You don't necessarily have to dispatch the callback,
         *  if you don't have any specific action you need to perform for that localListener.
         *  
         *  For this sample app, we didn't really have to dispatch the userData callback, 
         *  we are doing it just as an example to show you CAN
         */
        localListener.onServiceStatusResponse(response);
    }

    @Override
    public void onPurchaseResponse(PurchaseResponse response) {
        Log.i(TAG, "onPurchaseResponse: " + response);

        if (response.getStatus() != PurchaseResponse.Status.SUCCESSFUL) {
            DialogHelper.showDialog(context, "Sorry", "An error has occured while processing your order.");

        }
        /*
         *  Dispatch response to corresponding callback in localListner.
         *  
         *  You don't necessarily have to dispatch the callback,
         *  if you don't have any specific action you need to perform for that localListener.
         *  
         *  For this sample app, we didn't really have to dispatch the purchase callback, 
         *  we are doing it just as an example to show you CAN
         */
        localListener.onPurchaseResponse(response);
    }

    @Override
    public void onReceiptsResponse(ReceiptsResponse response) {
        Log.i(TAG, "onReceiptsResponse: " + response);
        if (response.getStatus() == ReceiptsResponse.Status.SUCCESSFUL) {
            Offset offset = response.getNextOffset();
            SharedPreferences sharedPreferences = context.getSharedPreferences(userId, Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putString(Constants.OFFSET_KEY, offset.toString());

            /*
             * If status is SUCCESSFUL, first retrieve the existing inventory
             * in the SharedPreferences instance that uses the userId as filename.
             * 
             * Then, one by one, update the inventory for new receipt (+1) or canceled receipt (-1),
             * and then store the updated value back into the SharedPreferences instance.
             */
            for (Receipt receipt : response.getReceipts()) {
                int tmpNumber = sharedPreferences.getInt(receipt.getProductId(), 0);
                String receiptId = receipt.getReceiptId();

                boolean receiptExists = sharedPreferences.getBoolean(receiptId, false);
                if (receiptExists && receipt.isCanceled()) {
                    tmpNumber = tmpNumber - 1;
                    editor.putBoolean(receipt.getReceiptId(), false);

                } else if (!receiptExists && !receipt.isCanceled()) {
                    tmpNumber = tmpNumber + 1;
                    editor.putBoolean(receipt.getReceiptId(), true);
                }
                editor.putInt(receipt.getProductId(), tmpNumber);
            }
            editor.commit();
        }
        localListener.onReceiptsResponse(response);
    }

    @Override
    public void onSearchByIdResponse(SearchByIdResponse response) {
        Log.i(TAG, "onSearchByIdResponse: " + response);
        localListener.onSearchByIdResponse(response);
    }

    @Override
    public void onSearchResponse(SearchResponse response) {
        Log.i(TAG, "onSearchResponse: " + response);
        localListener.onSearchResponse(response);
    }

}