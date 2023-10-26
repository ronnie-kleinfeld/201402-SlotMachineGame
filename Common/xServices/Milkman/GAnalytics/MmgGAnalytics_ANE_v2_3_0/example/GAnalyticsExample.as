package  
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import com.milkmangames.nativeextensions.*;

/** GAnalyticsExample App */
public class GAnalyticsExample extends Sprite
{
	//
	// Definitions
	//
	
	/** Google Analytics Tracking ID 
	 * change YOUR:TRACKING_ID to your actual google analytics tracking id!
	 * */
	//private static const GOOGLE_ANALYTICS_TRACKING_ID:String="UA-00000000-0";
	private static const GOOGLE_ANALYTICS_TRACKING_ID:String=YOUR::TRACKING_ID;
	
	//
	// Instance Variables
	//
	
	/** Status */
	private var txtStatus:TextField;
	
	/** Buttons */
	private var buttonContainer:Sprite;
	
	//
	// Public Methods
	//
	
	/** Create New GAnalyticsExample */
	public function GAnalyticsExample() 
	{		
		createUI();		

		if (!GAnalytics.isSupported())
		{
			log("GAnalytics is not supported on this platform.");
			removeChild(buttonContainer);
			return;
		}
		
		log("initializing GAnalytics...");		
		
		GAnalytics.create(GOOGLE_ANALYTICS_TRACKING_ID);
		
		// at the start of your app, you usually want to track a view to start the session.
		GAnalytics.analytics.defaultTracker.trackScreenView("home screen");

		log("GAnalytics v"+GAnalytics.VERSION+" Initialized!");

	}
	
	// Tracking Examples
	
	/** Track a Screen View */
	public function trackScreenView():void
	{
		// when the user goes to a new screen in your app, you can track it by name
		GAnalytics.analytics.defaultTracker.trackScreenView("screen test");
		log("Tracked 'home screen' view.");
	}
	
	/** Track a button click */
	public function trackButton1Event():void
	{
		// events can be used to track any kind of action in your app or game.
		// in this example, we record a "click" in the "uiEvents" category of
		// a button labeled "Button 1"
		GAnalytics.analytics.defaultTracker.trackEvent("uiEvents", "click", "Button 1");
		log("Tracked button 1 event.");
	}
	
	/** Track a button click */
	public function trackButton2Event():void
	{
		// events can be used to track any kind of action in your app or game.
		// in this example, we record a "click" in the "uiEvents" category of
		// a button labeled "Button 2"
		GAnalytics.analytics.defaultTracker.trackEvent("uiEvents", "click", "Button 2");
		log("Tracked button 2 event.");
	}
	
	/** Track a game attack event */
	public function trackAttackEvent():void
	{
		// events can be used to track any kind of action in your app or game.
		// in this example, we record a "magic" spelled used in the "fightingMoves" 
		// category with a label "Magic Spell" and 3000 magical power hit points
		GAnalytics.analytics.defaultTracker.trackEvent("fightingMoves", "magic", "Magic Spell", 3000);
		log("Tracked magic event.");
	}
	
	/** Track an in-app purchase */
	public function trackPurchaseEvent():void
	{
		// when an in-app purchase is completed, you can track it by calling trackTransaction
		// followed by trackItem.  Both should use the same transactionId propert (in this 
		// example case, "abc-def-ghi") that is unique to this particular purchase.		
		GAnalytics.analytics.defaultTracker.trackTransaction("abc-def-ghi", "App Store", 1.99);
		GAnalytics.analytics.defaultTracker.trackItem("abc-def-ghi", "Test Item", "testitemsku", 1.99);
		log("Tracked purchase.");
	}
	
	/** Track a social network interaction */
	public function trackSocialEvent():void
	{
		// you can track interactions with social media services.  In this example, we report
		// that the user has done the action "shareLink" with "Facebook", and that the relevant
		// content was "http://www.milkmangames.com/test"
		GAnalytics.analytics.defaultTracker.trackSocial("Facebook", "shareLink", "http://www.milkmangames.com/test");
		log("Tracked social event.");
	}
	
	/** Track a timed occurence */
	public function trackTiming():void
	{
		// you can track how long it takes things to happen in your game and app.
		// the following example tracks a timing of 2500 milliseconds for
		// "startup" event in the "loadtimes" category, with a label of "Startup Label"
		GAnalytics.analytics.defaultTracker.trackTiming("loadtimes", 2500, "startup", "Startup Label");
		log("Tracked load timing.");
	}
	
	/** Track an error */
	public function trackException():void
	{
		// you can track errors and exceptions in your app with google analytics.
		// in this example, we make call that which will cause an 
		// error in actionscript.  we the report that error to analytics.
		// the 'false' indicates that it's not a fatal error.
		try
		{
			var object:Object=null;
			object.invalidCall();
		} 
		catch (e:Error)
		{
			log("Reporting exception: "+e.message);
			GAnalytics.analytics.defaultTracker.trackException(e.message, false);
		}
		
	}	
	
	// Configuration
	
	/** Set the user as 'opted out' of tracking */
	public function setOptOutOn():void
	{
		// if the user wants to opt out of being tracked, you can call setOptOut(true)
		GAnalytics.analytics.setOptOut(true);
		log("Opted out status:"+GAnalytics.analytics.getOptOut());
	}
	
	/** Set the user as 'opted in' to tracking */
	public function setOptOutOff():void
	{
		// if the user wants to opt IN to being tracked, you can call setOptOut(false)
		GAnalytics.analytics.setOptOut(false);
		log("Opted out status:"+GAnalytics.analytics.getOptOut());
	}	
	
	/** Enable Dry Run */
	public function setDryRunOn():void
	{
		// in 'dry run' mode, your events don't actually get sent to the sever.
		// this is useful when testing your app locally without actually
		// distorting the data in google analytics.
		GAnalytics.analytics.setDryRun(true);
		log("Dry run status:"+GAnalytics.analytics.getDryRun());
	}
	
	/** Disable Dry Run */
	public function setDryRunOff():void
	{
		// in 'dry run' mode, your events don't actually get sent to the sever.
		// this is useful when testing your app locally without actually
		// distorting the data in google analytics.
		GAnalytics.analytics.setDryRun(false);
		log("Dry run status:"+GAnalytics.analytics.getDryRun());
	}
	
	/** Force Dispatch Hits */
	public function forceDispatchHits():void
	{
		// by default, Google Analytics will batch events and send them
		// to the server perioidically.  this method forces all queued
		// hits to be sent right away.
		GAnalytics.analytics.forceDispatchHits();
		log("Forced dispatch hits.");
	}
	
	/** Set Tracker Property */
	public function setTrackerField():void
	{
		// set a field that will be used by all hits you track.
		// in this example, we're setting the user ID.
		// Make sure you are familiar with Google's 
		// user id policy (https://developers.google.com/analytics/devguides/collection/protocol/policy)
		// before using this in an app.
		GAnalytics.analytics.defaultTracker.setTrackerField("&uid", "bob@gmail.com");
		log("Set userid tracker field.");
	}
	
	/** Enable Collection of Ad ID */
	public function enableAdIdCollection():void
	{
		// setting this allows more fine-grained demographics to be collected.
		// TO USE THIS ON *IOS* YOU MUST ALSO INCLUDE GAIDFAAccess.ane.  Also note
		// that if you do that on iOS but do not have any ads in your app,
		// your application will be rejected by Apple!
		
		try
		{
			GAnalytics.analytics.defaultTracker.setAdvertisingIdCollectionEnabled(true);
		}
		catch (e:Error)
		{
			log("Can't set ad id collection: "+e.message);
			return;
		}
		
		log("Ad Id Collection is now enabled.");
	}
	
	/** Get Android Install Referrer */
	public function getAndroidInstallReferrer():void
	{
		// if the app was installed from the Google Play Store on Android with a referrer value,
		// get that value.
		var referrer:String=GAnalytics.analytics.getInstallReferrer();
		log("Referrer was: ("+referrer+")");
	}
	
	//
	// Impelementation
	//
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[GAnalyticsEx] "+msg);
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
		layout.addButton(new SimpleButton(new Command("Track Screen View", trackScreenView)));
		layout.addButton(new SimpleButton(new Command("Track Button 1 Click", trackButton1Event)));
		layout.addButton(new SimpleButton(new Command("Track Button 2 Click", trackButton2Event)));
		layout.addButton(new SimpleButton(new Command("Track Magic Attack", trackAttackEvent)));
		layout.addButton(new SimpleButton(new Command("Track In-app Purchase", trackPurchaseEvent)));
		layout.addButton(new SimpleButton(new Command("Track Social Sharing", trackSocialEvent)));
		layout.addButton(new SimpleButton(new Command("Track Timing", trackTiming)));
		layout.addButton(new SimpleButton(new Command("Track Error", trackException)));
		layout.addButton(new SimpleButton(new Command("Opt Out of Tracking", setOptOutOn)));
		layout.addButton(new SimpleButton(new Command("Opt In to Tracking", setOptOutOff)));
		layout.addButton(new SimpleButton(new Command("Enable Dry Run", setDryRunOn)));
		layout.addButton(new SimpleButton(new Command("Disable Dry Run", setDryRunOff)));
		layout.addButton(new SimpleButton(new Command("Force Dispatch Hits", forceDispatchHits))); 
		layout.addButton(new SimpleButton(new Command("Set Tracker Field", setTrackerField)));
		layout.addButton(new SimpleButton(new Command("Get Android Install Referrer", getAndroidInstallReferrer)));
		layout.addButton(new SimpleButton(new Command("Enable Ad ID", enableAdIdCollection)));
		
		layout.attach(buttonContainer);
		layout.layout();
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