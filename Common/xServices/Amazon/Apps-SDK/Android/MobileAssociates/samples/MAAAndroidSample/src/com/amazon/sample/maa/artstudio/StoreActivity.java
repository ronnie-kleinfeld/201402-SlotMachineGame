package com.amazon.sample.maa.artstudio;

import java.util.LinkedList;
import java.util.List;

import android.app.ListActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.amazon.device.associates.AssociatesAPI;
import com.amazon.device.associates.Product;
import com.amazon.device.associates.PurchaseRequest;
import com.amazon.device.associates.PurchaseResponse;
import com.amazon.device.associates.ShoppingListener;
import com.amazon.device.associates.ReceiptsResponse;
import com.amazon.device.associates.SearchByIdRequest;
import com.amazon.device.associates.SearchByIdResponse;
import com.amazon.device.associates.SearchResponse;
import com.amazon.device.associates.ServiceStatusResponse;

/*
 * This ListActivity issues a SearchById API for a set of predefined asins to be displayed in the listView
 */
public class StoreActivity extends ListActivity implements ShoppingListener {

    private static final String TAG = StoreActivity.class.getSimpleName();

    private GlobalPurchasingListener globalListener;

    private ArrayAdapter<String> adapter;
    private List<Product> productsInListView;
    private ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_store);

        globalListener = GlobalPurchasingListener.getInstance();
        globalListener.setContext(this);

        listView = (ListView) findViewById(android.R.id.list);

    }

    @Override
    protected void onResume() {
        super.onResume();

        globalListener.setLocalListener(this);
        // Set the predefined asins into the SearchByIdRequest and issue the API call
        SearchByIdRequest searchByIdRequest = new SearchByIdRequest();
        searchByIdRequest.addProductId(Constants.EASEL_ASIN);
        searchByIdRequest.addProductId(Constants.BRUSH_ASIN);
        searchByIdRequest.addProductId(Constants.DESK_ASIN);
        searchByIdRequest.addProductId(Constants.PENCIL_ASIN);
        searchByIdRequest.addProductId(Constants.GUITAR_ASIN);
        searchByIdRequest.addProductId(Constants.STRING_ASIN);
        try {
            AssociatesAPI.getShoppingService().searchById(searchByIdRequest);
        } catch (final Exception e) {
            Log.e(TAG, "Error calling ShoppingService.searchById: ", e);
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
    }

    @Override
    public void onSearchByIdResponse(SearchByIdResponse response) {
        SearchByIdResponse.Status status = response.getStatus();

        if (status == SearchByIdResponse.Status.FAILED) {
            DialogHelper.showDialog(this, "Failure",
                    "An error has occured while trying to locate the items in the store.");

        } else if (status == SearchByIdResponse.Status.NOT_SUPPORTED) {
            DialogHelper.showDialog(this, "Sorry", "Search is not supported.");

        } else {
            /*
             * Get the list of all the products in the response
             * retrieve the title and price of each item, and store them together as an element in a String List
             * set the String List that contains the product titles and prices to the adapter to be shown in the listView
             */
            productsInListView = response.getProducts();
            List<String> descriptionList = new LinkedList<String>();
            for (int i = 0; i < productsInListView.size(); i++) {
                descriptionList.add(productsInListView.get(i).getTitle() + "\n"
                        + productsInListView.get(i).getPrice().toString());
            }
            adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, descriptionList);

            /*
             * When any item in the listView is tapped, issue a purchase API call for the corresponding asin
             */
            listView.setOnItemClickListener(new ListView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    PurchaseRequest request = new PurchaseRequest(productsInListView.get(position).getProductId(),
                            view, true);
                    try {
                        AssociatesAPI.getShoppingService().purchase(request);
                    } catch (final Exception e) {
                        Log.e(TAG, "Error calling ShoppingService.purchase: ", e);
                    }
                }
            });
            listView.setAdapter(adapter);
        }
    }

    @Override
    public void onSearchResponse(SearchResponse response) {
        // TODO Auto-generated method stub

    }

}