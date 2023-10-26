package  
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import com.milkmangames.nativeextensions.*;
import com.milkmangames.nativeextensions.events.*;

/** CoreMobileExample App */
public class CoreMobileExample extends Sprite
{
	//
	// Definitions
	//
	
	/** Unique ID For a Local Notification.  */
	private static const NOTIFICATION_ID:int=6000;
	
	/** Unique ID for a Repeating Local Notificaiton. */
	private static const REPEATING_NOTIFICATION_ID:int=6001;
	
	//
	// Instance Variables
	//
	
	/** Status */
	private var txtStatus:TextField;
	
	/** Buttons */
	private var buttonContainer:Sprite;
	
	/** 3d Plane */
	private var plane3D:Sprite;
	
	//
	// Public Methods
	//
	
	/** Create New CoreMobileExample */
	public function CoreMobileExample() 
	{		
		createUI();
		
		if (!CoreMobile.isSupported())
		{
			log("CoreMobile is not supported on this platform.");
			removeChild(buttonContainer);
			return;
		}
		
		log("initializing CoreMobile...");		
		
		CoreMobile.create();
		
		// IF YOU ARE USING Local Notifications, this ensures iOS will be able to display them.
		// don't call it if you're not using Local Notifications or you'll see the popup
		// asking for notification permissions.
		log("Registering for notifications...");
		CoreMobile.mobile.registerForNotifications();

		// this event is dispatched when the internet connection is lost or gained
		CoreMobile.mobile.addEventListener(CMNetworkEvent.NETWORK_REACHABILITY_CHANGED, onNetworkChanged);
		// this event is dispatched when a local notification occurs while the app is running
		CoreMobile.mobile.addEventListener(CMLocalNotificationEvent.LOCAL_NOTIFICATION_RECEIVED, onNotification);
		// this event is dispatched when the app is resumed or started because of a local notification click
		CoreMobile.mobile.addEventListener(CMLocalNotificationEvent.RESUMED_FROM_LOCAL_NOTIFICATION, onNotification);
		
		// use the dark theme on android.
		CoreMobile.mobile.setAndroidTheme(CMAndroidTheme.THEME_DARK);
		
		log("CoreMobile v"+CoreMobile.VERSION+" Initialized!");

	}
	
	/** Start Monitoring Motion */
	public function startMonitoringMotion():void
	{
		if (!CoreMobile.mobile.isDeviceMotionAvailable())
		{
			log("Device motion not available!");
			return;
		}
		
		// once you call this, CoreMobile.mobile.getDeviceMotionData() can
		// return smooth orientation info based on the gyroscope
		CoreMobile.mobile.startMonitoringDeviceMotion();
		
		// games only render on frame events, so we'll check for new
		// gyro data every frame.
		stage.addEventListener(Event.ENTER_FRAME, onFrame);
		log("Started monitoring..");
	}
	
	/** Stop Monitoring Motion */
	public function stopMonitoringMotion():void
	{
		if (!CoreMobile.mobile.isDeviceMotionAvailable())
		{
			log("Device motion not available!");
			return;
		}
		CoreMobile.mobile.stopMonitoringDeviceMotion();
		stage.removeEventListener(Event.ENTER_FRAME, onFrame);	
		log("Stopped monitoring.");
	}
	
	/** Vibrate */
	public function vibrate():void
	{
		log("Bzzz!");
		// if the device has a motor, it will vibrate.
		CoreMobile.mobile.vibrate();
	}
	
	/** Check Internet Connection */
	public function checkNetworkAvailable():void
	{
		var networkType:int=CoreMobile.mobile.getNetworkType();
		var typeString:String;
		switch(networkType)
		{
			case CMNetworkType.NONE:
				typeString="none";
				break;
			case CMNetworkType.MOBILE:
				typeString="mobile";
				break;
			case CMNetworkType.WIFI:
				typeString="wifi";
				break;
				
		}
		log("Internet reachable? "+CoreMobile.mobile.isNetworkReachable()+", type: "+typeString);
	}
	
	/** Show Picker */
	public function showPicker():void
	{
		var items:Vector.<String>=new <String>["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eigth", "Ninth", "Tenth", "Eleventh"];
		
		log("Showing picker...");
		
		// showPicker returns a dispatcher object, that you can use
		// to listen for the dismiss event of the particular picker.
		CoreMobile.mobile.showPicker(items, 3, "Done", "Cancel", 320, 320).
			addDismissListener( function(e:CMPickerEvent):void
			{
				if (e.wasCanceled)
				{
					log("Picker canceled!");
				}
				else
				{
					log("Selected picker item: "+e.selectedItemIndex+ " (value is "+(e.items[e.selectedItemIndex])+")");
				}
			});
		log("Picker showing.");
	}
	
	/** Cancel Picker */
	public function cancelPicker():void
	{
		log("Canceling...");
		CoreMobile.mobile.cancelPicker();
		log("Canceled.");
	}

	/** Show a Modal Confirmation Dialog */
	public function showModalConfirmationDialog():void
	{
		log("Showing modal confirmation dialog...");
		

		// showModalConfirmationDialog returns a dispatcher object, that you can optionally use
		// to listen for the dismiss event of the particular dialog.
		CoreMobile.mobile.showModalConfirmationDialog("Important!", "Acknowledge me now!", "OK").
			addDismissListener( function(e:CMDialogEvent):void 
			{
				log("Confirmation dismissed.");
			});
		
		log("Dialog showing.");

	}
	
	/** Show a Modal Question Dialog */
	public function showModalQuestionDialog():void
	{
		log("Showing modal question dialog...");

		// showModalQuestionDialog returns a dispatcher object, that you can optionally use
		// to listen for the dismiss event of the particular dialog.
		CoreMobile.mobile.showModalYesNoDialog("Question..", "Yes or no?", "YES!", "NO!").
			addDismissListener(function(e:CMDialogEvent):void 
			{
				if (e.selectedButtonLabel=="YES!")
				{
					log("You said yes.");
				}
				else {
					log("You said no.");
				}
			});
			
		log("Dialog showing.");
	}
	
	/** Show a Modal Input Dialog */
	public function showModalInputDialog():void
	{
		log("Showing modal input dialog...");

		// showModalInputDialog returns a dispatcher object, that you can optionally use
		// to listen for the dismiss event of the particular dialog.	
		CoreMobile.mobile.showModalInputDialog("Your Name", "Enter your name...", "OK", "Threepwood", "Cancel",CMInputType.TEXT).
			addDismissListener(function(e:CMDialogEvent):void 
			{
				if (e.selectedButtonLabel=="OK")
				{
					log("Your Name: "+e.modalUserInput);
				}
				else
				{
					log("You didn't enter a name.");
				}
			});
	
		
		log("Dialog showing.");
	}
	
	/** Show a Modal Number Input Dialog */
	public function showModalNumberInputDialog():void
	{
		log("Showing modal input dialog...");

		// showModalInputDialog returns a dispatcher object, that you can optionally use
		// to listen for the dismiss event of the particular dialog.	
		CoreMobile.mobile.showModalInputDialog("Your Number", "Enter your number...", "OK", "Your Number", "Cancel", CMInputType.NUMBER).
			addDismissListener(function(e:CMDialogEvent):void 
			{
				if (e.selectedButtonLabel=="OK")
				{
					log("Your Number: "+e.modalUserInput);
				}
				else
				{
					log("You didn't enter a number.");
				}
			});
	
		
		log("Dialog showing.");
	}
	
	/** Show Modal Credentials Dialog */
	public function showModalCredentialsDialog():void
	{
		log("Showing modal credentials dialog...");

		// showModalCredentialsDialog returns a dispatcher object, that you can optionally use
		// to listen for the dismiss event of the particular dialog.
		
		CoreMobile.mobile.showModalCredentialsDialog("Login", "Enter email  and password:", "OK", "Cancel", CMInputType.EMAIL).
			addDismissListener( function(e:CMDialogEvent):void 
			{
				if (e.selectedButtonLabel=="OK")
				{
					log("Your u/p: "+e.modalUserName+", "+e.modalPassword);
				}
				else
				{
					log("You didn't enter credentials.");
				}
		});
		
		log("Dialog showing.");
	}
	
	/** Schedule Local Notification */
	public function scheduleNotification():void
	{
		log("Scheduling notification for one minute from now.");
		
		
		// the notification id lets us identify this particular
		// notification in the future if we want to cancel it.
		// (for instance, a game may set a local notification for 
		// 3 days from now that says "Come back and Play"- 
		// we could cancel this id on every startup, so that 
		// the play won't see it unless they've been gone 3 days.)
		
		// the optional last parameter is an hash of key/value pairs,
		// you can use this to store special game specific 
		// information that may relate to this notification.
		CoreMobile.mobile.scheduleLocalNotification(
			NOTIFICATION_ID, 
			CoreMobile.futureTimeSeconds(CoreMobile.MINUTE), 
			"It's time", 
			"It's been one minute.", 
			"Cool!", 
			{coins:50, name:"Bob"});
			
		
		log("did schedule one minute notification.");
	}
	
	/** Schedule Repeating Local Notification */
	public function scheduleRepeatingNotification():void
	{
		log("Scheduling repeating notification for every minute.");
		
		
		// the notification id lets us identify this particular
		// notification in the future if we want to cancel it.
		// (for instance, a game may set a local notification for 
		// 3 days from now that says "Come back and Play"- 
		// we could cancel this id on every startup, so that 
		// the play won't see it unless they've been gone 3 days.)
		
		// the optional last parameter is an hash of key/value pairs,
		// you can use this to store special game specific 
		// information that may relate to this notification.
		CoreMobile.mobile.scheduleRepeatingLocalNotification(
			REPEATING_NOTIFICATION_ID, 
			CoreMobile.futureTimeSeconds(CoreMobile.MINUTE),
			CoreMobile.MINUTE,
			"Repeater", 
			"Another minute passed.", 
			"Cool!", 
			{coins:20, name:"Alice"});
		
		log("did schedule repeating minute notification.");
	}
	
	/** Cancel a Local Notification */
	public function cancelLocalNotification():void
	{
		log("Canceling notification with id "+NOTIFICATION_ID);
		CoreMobile.mobile.cancelLocalNotification(NOTIFICATION_ID);
		log("Notification "+NOTIFICATION_ID+" has been canceled.");
	}
	
	/** Cancel Repeating Notification */
	public function cancelRepeatingNotification():void
	{
		log("Canceling notification with id "+REPEATING_NOTIFICATION_ID);
		CoreMobile.mobile.cancelLocalNotification(REPEATING_NOTIFICATION_ID);
		log("Notification "+REPEATING_NOTIFICATION_ID+" has been canceled.");		
	}
	
	/** Cancel all local notifications. */
	public function cancelAllNotifications():void
	{
		log("Canceling all pending local notifications...");
		CoreMobile.mobile.cancelAllLocalNotifications();
		log("All notifications canceled.");
	}
	
	/** Set Application Badge Number to zero on iOS */
	public function setBadgeNumber():void
	{
		log("Setting badge number to 0...");
		CoreMobile.mobile.setNotificationBadgeNumber(0);
		log("Zeroed badge.");
	}
	
	//
	// Events
	//
	
	/** On Network Changed */
	private function onNetworkChanged(e:CMNetworkEvent):void
	{
		var typeString:String;
		switch(e.networkType)
		{
			case CMNetworkType.NONE:
				typeString="none";
				break;
			case CMNetworkType.MOBILE:
				typeString="mobile";
				break;
			case CMNetworkType.WIFI:
				typeString="wifi";
				break;
				
		}
		
		log("Network status changed: internet reachable="+e.isNetworkReachable+"/"+typeString);
	}
	
	/** On Local Notification */
	private function onNotification(e:CMLocalNotificationEvent):void
	{
		log(e.type+": "+e.title+"/ "+e.message+" /"+JSON.stringify(e.extra));
	}
	
	/** On Frame */
	private function onFrame(e:Event):void
	{
		var data:DeviceMotionData=CoreMobile.mobile.getDeviceMotionData();
		// device data comes in radians.
		var roll:Number=data.roll; 
		var pitch:Number=data.pitch;
		var yaw:Number=data.yaw;
		
		// quaternion representation
		var qw:Number=data.qw;
		var qx:Number=data.qx;
		var qy:Number=data.qy;
		var qz:Number=data.qz;
		
		// convert to degrees, to look nice.
		var rollDegrees:Number=Math.floor(roll*180/Math.PI);
		var pitchDegrees:Number=Math.floor(pitch*180/Math.PI);
		var yawDegrees:Number=Math.floor(yaw*180/Math.PI);
		log("Motion: "+ rollDegrees+", "+ pitchDegrees+", "+yawDegrees +", q["+qw+","+qx+","+qy+","+qz+"]");
		
		// rotate the 3d plane to oppose the devices orientation
		this.plane3D.rotationX=-pitchDegrees;
		this.plane3D.rotationY=rollDegrees;
		this.plane3D.rotationZ=yawDegrees;
	
	}
	
	//
	// Impelementation
	//
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[CoreMobileEx] "+msg);
		txtStatus.text=msg;
	}
	
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",22);
		txtStatus.width=stage.stageWidth;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		addChild(txtStatus);
		
		buttonContainer=new Sprite();
		buttonContainer.y=txtStatus.height;
		addChild(buttonContainer);
		
		var uiRect:Rectangle=new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var layout:ButtonLayout=new ButtonLayout(uiRect, 12);
		layout.addButton(new SimpleButton(new Command("Start Motion Monitor", startMonitoringMotion)));
		layout.addButton(new SimpleButton(new Command("Stop Motion Monitor", stopMonitoringMotion)));
		layout.addButton(new SimpleButton(new Command("Vibrate", vibrate)));
		layout.addButton(new SimpleButton(new Command("Confirm Modal", showModalConfirmationDialog)));
		layout.addButton(new SimpleButton(new Command("Question Modal", showModalQuestionDialog)));
		layout.addButton(new SimpleButton(new Command("Input Modal", showModalInputDialog)));
		layout.addButton(new SimpleButton(new Command("Number Input Modal", showModalNumberInputDialog)));
		layout.addButton(new SimpleButton(new Command("Login Modal", showModalCredentialsDialog)));
		layout.addButton(new SimpleButton(new Command("Check Network", checkNetworkAvailable)));
		layout.addButton(new SimpleButton(new Command("Notify in One Minute", scheduleNotification)));
		layout.addButton(new SimpleButton(new Command("Repeating Min Notification", scheduleRepeatingNotification)));
		layout.addButton(new SimpleButton(new Command("Cancel Notification", cancelLocalNotification)));
		layout.addButton(new SimpleButton(new Command("Cancel Repeating Notification", cancelRepeatingNotification))); 
		layout.addButton(new SimpleButton(new Command("Cancel All Notifications", cancelAllNotifications)));
		layout.addButton(new SimpleButton(new Command("Show Picker", showPicker)));
		layout.addButton(new SimpleButton(new Command("Cancel Picker", cancelPicker)));
		layout.addButton(new SimpleButton(new Command("Zero Badge Number", setBadgeNumber)));
		
		layout.attach(buttonContainer);
		layout.layout();
		
		this.plane3D=new Sprite();
		var planeWidth:Number=200;
		var planeHeight:Number=planeWidth;
		this.plane3D.graphics.beginFill(0x0000FF, 1);
		this.plane3D.graphics.drawRect(-planeWidth*.5, -planeHeight*.5, planeWidth, planeHeight);
		this.plane3D.graphics.endFill();
		
		this.plane3D.x=stage.stageWidth*.5;
		this.plane3D.y=stage.stageHeight-(planeHeight);
		stage.addChildAt(this.plane3D,0);
		
	}
	
	
}
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/** Simple Button */
class SimpleButton extends Sprite
{
	//
	// Instance Variables
	//
	
	/** Command */
	private var cmd:Command;
	
	/** Width */
	private var _width:Number;
	
	/** Label */
	private var txtLabel:TextField;
	
	//
	// Public Methods
	//
	
	/** Create New SimpleButton */
	public function SimpleButton(cmd:Command)
	{
		super();
		this.cmd=cmd;
		
		mouseChildren=false;
		mouseEnabled=buttonMode=useHandCursor=true;
		
		txtLabel=new TextField();
		txtLabel.defaultTextFormat=new TextFormat("Arial",36,0xFFFFFF);
		txtLabel.mouseEnabled=txtLabel.mouseEnabled=txtLabel.selectable=false;
		txtLabel.text=cmd.getLabel();
		txtLabel.autoSize=TextFieldAutoSize.LEFT;
		
		redraw();
		
		addEventListener(MouseEvent.CLICK,onSelect);
	}
	
	/** Set Width */
	override public function set width(val:Number):void
	{
		this._width=val;
		redraw();
	}

	
	/** Dispose */
	public function dispose():void
	{
		removeEventListener(MouseEvent.CLICK,onSelect);
	}
	
	//
	// Events
	//
	
	/** On Press */
	private function onSelect(e:MouseEvent):void
	{
		this.cmd.execute();
	}
	
	//
	// Implementation
	//
	
	/** Redraw */
	private function redraw():void
	{		
		txtLabel.text=cmd.getLabel();
		_width=_width||txtLabel.width*1.1;
		
		graphics.clear();
		graphics.beginFill(0x444444);
		graphics.lineStyle(2,0);
		graphics.drawRoundRect(0,0,_width,txtLabel.height*1.1,txtLabel.height*.4);
		graphics.endFill();
		
		txtLabel.x=_width/2-(txtLabel.width/2);
		txtLabel.y=txtLabel.height*.05;
		addChild(txtLabel);
	}
}

/** Button Layout */
class ButtonLayout
{
	private var buttons:Array;
	private var rect:Rectangle;
	private var padding:Number;
	private var parent:DisplayObjectContainer;
	
	public function ButtonLayout(rect:Rectangle,padding:Number)
	{
		this.rect=rect;
		this.padding=padding;
		this.buttons=new Array();
	}
	
	public function addButton(btn:SimpleButton):uint
	{
		return buttons.push(btn);
	}
	
	public function attach(parent:DisplayObjectContainer):void
	{
		this.parent=parent;
		for each(var btn:SimpleButton in this.buttons)
		{
			parent.addChild(btn);
		}
	}
	
	public function layout():void
	{
		var btnX:Number=rect.x+padding;
		var btnY:Number=rect.y;
		for each( var btn:SimpleButton in this.buttons)
		{
			btn.width=rect.width-(padding*2);
			btnY+=this.padding;
			btn.x=btnX;
			btn.y=btnY;
			btnY+=btn.height;
		}
	}
}

/** Inline Command */
class Command
{
	/** Callback Method */
	private var fnCallback:Function;
	
	/** Label */
	private var label:String;
	
	//
	// Public Methods
	//
	
	/** Create New Command */
	public function Command(label:String,fnCallback:Function)
	{
		this.fnCallback=fnCallback;
		this.label=label;
	}
	
	//
	// Command Implementation
	//
	
	/** Get Label */
	public function getLabel():String
	{
		return label;
	}
	
	/** Execute */
	public function execute():void
	{
		fnCallback();
	}
}