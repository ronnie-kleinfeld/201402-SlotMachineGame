// This is a simple model view controller setup to deal with
// the fact that the onPurchaseResponse can get called at any
// time.
//
// The fact that responses can come at any time is important to
// understand when using the API. Your web app could have been
// shut down prior to a receipt being delivered for instance. The
// next time your application runs the receipt will be delivered
// upon initializing the API in this case.

// Model Data
var state = {
    clicksLeft: 10,
    activeButton: "",
    hasRedButton: false,
    hasGreenButton: false,
    hasBlueButton: false,
    lastPurchaseCheckTime: null
}

// Make the view (HTML) look like the model

function refreshPageState() {
    $("#clicksLeft").text(state.clicksLeft);

    var button = $("#theButton");
    var redButton = $("#redButton");
    var greenButton = $("#greenButton");
    var blueButton = $("#blueButton");

    setClass(redButton, "locked", !state.hasRedButton);
    setClass(greenButton, "locked", !state.hasGreenButton);
    setClass(blueButton, "locked", !state.hasBlueButton);

    setClass(redButton, "active", state.activeButton == "red");
    setClass(greenButton, "active", state.activeButton == "green");
    setClass(blueButton, "active", state.activeButton == "blue");

    if (state.activeButton != "") {
        button.css("background-color", state.activeButton);
    } else {
        button.css("background-color", "gray");
    }
    persistPageState();
}

// Saves the state to localStorage so the next time the app
// runs it's the same as it was last run. Most important
// is remembering it IAP status including the lastPurchaseCheckTime
// which is passed to getPurchaseUpdates.
function persistPageState() {
    localStorage.setItem("state", JSON.stringify(state));
}

// Restore the state from localStorage
function loadPageState() {
    if ("state" in localStorage) {
        // If this is the first run then the defaults we
        // set earlier are what we're going to run with.
        state = JSON.parse(localStorage.getItem("state"));
    }
}

function setClass(element, className, condition) {
    if (condition) {
        element.addClass(className);
    } else {
        element.removeClass(className);
    }
}

// Controller

// Excercises consumables
function buttonPressed() {
    if (state.clicksLeft > 0) {
        state.clicksLeft--;
    } else {
        buyClicks();
    }
    refreshPageState();
}

// Excercises entitlements
function redButtonPressed() {
    if (state.hasRedButton) {
        state.activeButton = "red";
    } else {
        buyButton("sample.redbutton");
    }
    refreshPageState();
}

// Excercises entitlements
function greenButtonPressed() {
    if (state.hasGreenButton) {
        state.activeButton = "green";
    } else {
        buyButton("sample.greenbutton");
    }
    refreshPageState();
}

// Excercises subscriptions
function blueButtonPressed() {
    if (state.hasBlueButton) {
        state.activeButton = "blue";
    } else {
        // You need to buy the specific subscription (complete with term)
        buyButton("sample.bluebutton.subscription.1mo");
    }
    refreshPageState();
}

function buyClicks() {
    if (amzn_wa.IAP == null) {
        alert("You are out of clicks, however Amazon In-App-Purchasing works only with Apps from the Appstore.");
    } else if (confirm("Buy more clicks?")) {
        amzn_wa.IAP.purchaseItem("sample.clicks");
    }
}

function buyButton(buttonName) {
    if (amzn_wa.IAP == null) {
        alert("You cannot buy this button, Amazon In-App-Purchasing works only with Apps from the Appstore.");
    } else {
        amzn_wa.IAP.purchaseItem(buttonName);
    }
}

// Handler functions that are called from the callbacks

// purchaseItem will cause a purchase response with one receipt
function onPurchaseResponse(e) {
    if (e.purchaseRequestStatus == amzn_wa.IAP.PurchaseStatus.SUCCESSFUL) {
        handleReceipt(e.receipt);
    } else if (e.purchaseRequestStatus == amzn_wa.IAP.PurchaseStatus.ALREADY_ENTITLED) {
        // Somehow we are out of sync with the server, let's refresh from the
        // beginning of time.
        amzn_wa.IAP.getPurchaseUpdates(amzn_wa.IAP.Offset.BEGINNING)
    }
    refreshPageState();
}

// getPurchaseUpdates will return an array of receipts
function onPurchaseUpdatesResponse(e) {
    for (var i = 0; i < e.receipts.length; i++) {
        handleReceipt(e.receipts[i]);
    }
    state.lastPurchaseCheckTime = e.offset;
    refreshPageState();
    if (e.isMore) {
        // In case there is more updates that did not
        // get sent with this response, make sure that
        // we get the rest of them.
        amzn_wa.IAP.getPurchaseUpdates(state.lastPurchaseCheckTime);
    }
}

// In either case, the contents of the receipt are handled in the same way
function handleReceipt(receipt) {
    if (receipt.sku == "sample.redbutton") {
        // Entitlement
        state.hasRedButton = true;
    } else if (receipt.sku == "sample.greenbutton") {
        // Entitlement
        state.hasGreenButton = true;
    } else if (receipt.sku.substring(0, 30) == "sample.bluebutton.subscription") {
        // Subscriptions sometimes return the parent's ID so we compare to the
        // parent's ID
        if (receipt.subscriptionPeriod != null) {
            if (receipt.subscriptionPeriod.endDate == null) {
                // endDate is null if we are in the current period
                state.hasBlueButton = true;
            }
        }
    } else if (receipt.sku == "sample.clicks") {
        // Consumable
        state.clicksLeft += 10;
    }
}

// Setup

function initialize() {
    loadPageState();
    amzn_wa.enableApiTester(amzn_wa_tester);
    refreshPageState();

    // Setup button press handlers
    $("#theButton").click(function() { buttonPressed(); });
    $("#redButton").click(function() { redButtonPressed(); });
    $("#greenButton").click(function() { greenButtonPressed(); });
    $("#blueButton").click(function() { blueButtonPressed(); });

    // Ensure we can call the IAP API
    if (amzn_wa.IAP == null) {
        console.log("Amazon In-App-Purchasing only works with Apps from the Appstore");
    } else {
        // Registers the appropriate callback functions
        amzn_wa.IAP.registerObserver({
                 // Called the the IAP API is available
                'onSdkAvailable': function(resp) {
                    if (resp.isSandboxMode) {
                        // In a production application this should trigger either
                        // shutting down IAP functionality or redirecting to some
                        // page explaining that you should purchase this application
                        // from the Amazon Appstore.
                        //
                        // Not checking can leave your application in a state that
                        // is vulnerable to attacks. See the supplied documention
                        // for additional information.
                        alert("Running in test mode");
                    }

                    // You should call getPurchaseUpdates to get any purchases
                    // that could have been made in a previous run.
                    amzn_wa.IAP.getPurchaseUpdates(state.lastPurchaseCheckTime != null ?
                            state.lastPurchaseCheckTime : amzn_wa.IAP.Offset.BEGINNING);
                },

                // Called as response to getUserId
                'onGetUserIdResponse': function(resp) {},

                // Called as response to getItemData
                'onItemDataResponse': function(data) {},

                // Called as response to puchaseItem
                'onPurchaseResponse': function(data) { onPurchaseResponse(data); },

                // Called as response to getPurchaseUpdates
                'onPurchaseUpdatesResponse': function(resp) { onPurchaseUpdatesResponse(resp);
            }
        });
    }
}

$(function() {
    initialize();
});
