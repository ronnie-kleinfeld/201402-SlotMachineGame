////////////////////////////////////////////////////////////////////////////
//
// Provides a way to force an application to run in only a single
// orientation. You may use the included images as part of your
// application.
// 
// This has been tested on iOS, generic Android and Kindle Fire.
//
////////////////////////////////////////////////////////////////////////////

// Orientation forcing
var forcedOrientation = "landscape";  // Valid options are portrait and landscape
var disabled = false;
function forceOrientation() {
    var orientation = (Math.abs(window.orientation) === 90 ? "landscape" : "portrait");
    if (orientation !== forcedOrientation) {
        if (!disabled) {
            disabled = true;
            $("#forcerotation").show();
        }
    } else {
        if (disabled) {
            $("#forcerotation").hide();
            disabled = false;
        }
    }
}

// Orientation reporting -- You can substitute this method in the
// call to bind if you want to experiment without blocking the application.
// This can also serve as a start of a framework to applying a new layout
// to your application based on orientation changing.
var lastOrientation = (Math.abs(window.orientation) === 90 ? "landscape" : "portrait");
function reportOrientationChange() {
    var orientation = (Math.abs(window.orientation) === 90 ? "landscape" : "portrait");
    if (lastOrientation != orientation) {
        alert("Rotated. Now we are running in " + orientation);
    }
    lastOrientation = orientation;
}

function init() {
    if (window.orientation) {
        var orientationEvent = "resize";
        if ("onorientationchange" in window) {
            orientationEvent = "orientationchange";        
        } else if ("ondeviceorientation" in window) {
            orientationEvent = "deviceorientation";
        }
        console.log("Using " + orientationEvent);
        $(window).bind(orientationEvent, forceOrientation);
    } else {
        console.log("No orientation supported");        
    }
}

$(init);