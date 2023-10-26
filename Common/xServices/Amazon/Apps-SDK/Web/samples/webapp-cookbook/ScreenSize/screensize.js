function reportOrientationChange() {
    var orientation = (Math.abs(window.orientation) === 90 ? "landscape" : "portrait");
    
    $("#report").html("Orientation: " + orientation + "<br/>" + 
                      "Width: " + screen.width + "<br/>" + 
                      "Height: " + screen.height + "<br/>" + 
                      "AvailWidth: " + screen.availWidth + "<br/>" + 
                      "AvailHeight: " + screen.availHeight + "<br/>" +                       
                      "InnerWidth: " +  window.innerWidth + "<br/>" +
                      "InnerHeight: " +  window.innerHeight + "<br/>" +
                      "DevicePixelRatio: " + window.devicePixelRatio + "<br/>"
                      );
}

function init() {
    var orientationEvent = "resize";
    if ("onorientationchange" in window) {
        orientationEvent = "orientationchange";        
    } else if ("ondeviceorientation" in window) {
        orientationEvent = "deviceorientation";
    }
    console.log("Using " + orientationEvent);

    $(window).bind(orientationEvent, function() { setTimeout(function() { reportOrientationChange(); }, 500)} );
    
    reportOrientationChange();
}

$(init);
