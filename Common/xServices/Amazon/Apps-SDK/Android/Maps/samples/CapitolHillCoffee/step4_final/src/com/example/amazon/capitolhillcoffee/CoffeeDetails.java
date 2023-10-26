package com.example.amazon.capitolhillcoffee;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.SpannableString;
import android.text.style.UnderlineSpan;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.TextView;

/**
 *
 * Displays details about a given coffee shop in a dismissable popup.
 *
 */
public class CoffeeDetails {
    private static PopupWindow mPopup;
    private static Context mContext;

    private static final int POPUP_WIDTH_DIPS = 270;
    private static final int POPUP_HEIGHT_DIPS = 350;

    /**
     *  Display popup with coffee shop details
     */
    public final static void display(final Context context, final CoffeeShop shop) {
        mContext = context;

        // Inflate the layout
        final LayoutInflater inflater = (LayoutInflater)
                mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View layout = inflater.inflate(R.layout.shop_details, null);

        // Add title
        TextView textView = (TextView) layout.findViewById(R.id.shop_title);
        textView.setText(shop.getTitle());

        // Add clickable phone number
        textView = (TextView) layout.findViewById(R.id.shop_phone);
        final SpannableString phone = new SpannableString(shop.getPhone());
        phone.setSpan(new UnderlineSpan(), 0, phone.length(), 0);
        textView.setText(phone);
        textView.setOnClickListener(phoneListener);

        // Add address
        textView  = (TextView) layout.findViewById(R.id.shop_address);
        textView.setText(shop.getAddress());

        // Add OK button
        final Button dismissButton = (Button) layout.findViewById(R.id.dismiss_button);
        dismissButton.setOnClickListener(dismissListener);

        // Convert dips to actual pixels
        final float widthPx = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, POPUP_WIDTH_DIPS,
                mContext.getResources().getDisplayMetrics());
        final float heightPx = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, POPUP_HEIGHT_DIPS,
                mContext.getResources().getDisplayMetrics());
        // Display popup
        mPopup = new PopupWindow(layout, (int)widthPx, (int)heightPx, true);
        mPopup.showAtLocation(layout, Gravity.CENTER, 0, 0);
    }

    /**
     * Call coffee shop when user clicks on phone number
     */
    private static final OnClickListener phoneListener = new OnClickListener() {
        @Override
        public void onClick(final View v) {
            final Intent callIntent = new Intent(Intent.ACTION_CALL);
            callIntent.setData(Uri.parse("tel:" + ((TextView)v).getText()));
            mContext.startActivity(callIntent);
        }
    };

    /**
     *  Dismiss popup when user clicks "OK"
     */
    private static final OnClickListener dismissListener = new OnClickListener() {
        @Override
        public void onClick(final View v) {
            mPopup.dismiss();
        }
    };
}
