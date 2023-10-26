////////////////////////////////////////////////////////////////////////////
//
// This is a very simple way of enabling or disabling an application.
// A sophisticated user can comment out the code or call the JavaScript
// functions from a console. This is possible because the entire application
// is served to the user from the beginning and a simple flag controls
// the additional features.
//
// A better way to implement this is not serve the entire application at
// the start. Instead control some of the files for features such as
// additional levels from the server and base serving those extra features
// on verification of the in-app purchase by calling the receipt verification
// service (RVS) and checking that Amazon actually sold the entitlement. You
// can find additional documentation in the WebApp-IAP PDF.
//
////////////////////////////////////////////////////////////////////////////

// Important functions / variables / concepts are at the top of this file

// Both of these are false to start since you don't know what the state is yet.
var appEnabled = false;
var appDisabled = false;

var upgradeSkuName = "upgradeware.unlockruns"; // ** REPLACE WITH ACTUAL SKU **

var runLimit = 5;
var numberOfRuns;

// These functions are called asynchronously
function outOfRuns() {
    var choice = confirm("You must upgrade to the full version to run this application");
    if (choice) {
        amzn_wa.IAP.purchaseItem(upgradeSkuName);
    } else {
        // Still disabled, consumer messaging needs to be shown.
    }
}

function disableApplication() {
    if (appDisabled == false) {
        // Add functionality here: Perhaps make a div that blocks access to the application
        appDisabled = true;
        appEnabled = false;
    }
    $("#status").text("Disabled");
}

function enableApplication() {
    // Add functionality here
    appDisabled = false;
    appEnabled = true;
    $("#status").text("Enabled and " + (runLimit == -1 ? "unlocked" : "not yet unlocked"));
}

// The mechanics of making this work follow

function handleReceipt(receipt) {
    if (receipt.sku == upgradeSkuName) {
        runLimit = -1;
        localStorage.unlockRuns = true;
    }
}

function setupRunCount() {
    if (localStorage.unlockRuns == true) {
        runLimit = -1;
    }
    else {
        if (localStorage.numberOfRuns) {
            numberOfRuns = Number(localStorage.numberOfRuns);
        } else {
            numberOfRuns = 0;
        }
        numberOfRuns++;
        localStorage.numberOfRuns = numberOfRuns;
    }
}

// This is called when the API responds to either a purchase or update call
function verifyRunCount() {
    if (runLimit < 0) {    
        enableApplication();
    } else if (numberOfRuns > runLimit) {
        disableApplication();
        outOfRuns();
    } else {
        enableApplication();
    }    
}

function initialize_Amazon_API() {
    amzn_wa.enableApiTester(amzn_wa_tester); // Only for testing
    
    if (amzn_wa.IAP == null) {
        console.log("Amazon In-App-Purchasing only works with Apps from the Appstore");
    } else {
    	amzn_wa.IAP.registerObserver({
            'onSdkAvailable': function(resp) {
                if (resp.isSandboxMode) {
                    // In a production application this should trigger either
                    // shutting down IAP functionality or redirecting to some
                    // page explaining that you should purchase this application
                    // from the Amazon Appstore.
                    //
                    // Not checking can leave your application in a state that
                    // is vulnerable to attacks.  See the supplied documention
                    // for additional information.
                    alert("Running in test mode");                        
                }
                
                amzn_wa.IAP.getPurchaseUpdates(amzn_wa.IAP.Offset.BEGINNING);
            },
            
            'onGetUserIdResponse': function(resp) {},
            
            'onItemDataResponse': function(data) {},
            
            'onPurchaseResponse': function(data) {
                if (data.purchaseRequestStatus == amzn_wa.IAP.PurchaseStatus.SUCCESSFUL) {
                    handleReceipt(data.receipt);
                }
                verifyRunCount();
            },
            
            'onPurchaseUpdatesResponse': function(data) { 
                for (var i = 0; i < data.receipts.length; i++) {
                    handleReceipt(data.receipts[i]);
                }
                verifyRunCount();
            }
    	});
    }
}

$(function() {
    initialize_Amazon_API();        
    setupRunCount();
    $("#runcount").text(numberOfRuns + "");
});

