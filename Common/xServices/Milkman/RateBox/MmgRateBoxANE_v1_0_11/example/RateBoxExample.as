package  
{
import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import com.milkmangames.nativeextensions.*;
import com.milkmangames.nativeextensions.events.*;

/** RateBox Example App */
public class RateBoxExample extends Sprite
{
	//
	// Definitions
	//

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
	
	/** Create New RateBoxExample */
	public function RateBoxExample() 
	{		
		createUI();
		
		if (!RateBox.isSupported())
		{
			log("RateBox is not supported on this platform (not android or ios!)");
			return;
		}
		
		/** Initializing Ratebox */
		
		// start RateBox by calling RateBox.create().  The parameters shown below are as follows, in order:
		// 1: iOS Numeric app id, from the app's page on iTunes Connect.  If you're not supporting iOS, you can enter "" or null.
		// 2: Title to show on the rating prompt message box.
		// 3: The message to display to the user when asking them to rate the app
		// 4: OPTIONAL: The label for the 'rate now' button (default: "Rate Now")
		// 5: OPTIONAL: the label for the 'ask me later' button (default: "Not Now")
		// 6: OPTIONAL: the label for the 'never ask again' button, which will disable RateBox (default: "Don't ask again")
		// 7: OPTIONAL: number of times app must be launched before the rating dialog is shown (default: 3 times)
		// 8: OPTIONAL: number of times a custom event must be triggered before rating dialog is shown (default: 0 times)
		// 9: OPTIONAL: number of days since install that must pass before the rating dialog is shown (deafault: 0 days)
		// 10: OPTIONAL: number of days that must pass after the user presses 'not now' to a rating prompt before it may be shown again (default: 1 day)
	
		// So, the following example will display the RateBox after a custom event has been triggered 3 times.		
		RateBox.create("123456","Rate This App","If you like this app, please rate it!","Rate Now","Ask Me Later","Don't ask again",0,3,0);
		
		// this would show the rating prompt after the app has been installed for 3 days:
		// RateBox.create("123456","Rate This App","If you like this app, please rate it!","Rate Now","Ask Me Later","Don't ask again",0,0,3);
		
		// this would show the rate prompt after the app has been launched 3 times:
		// RateBox.create("123456","Rate This App","If you like this app, please rate it!","Rate Now","Ask Me Later","Don't ask again",3,0,0);
		
		// you can mix and match these values if you want.  this would show the rate box if the app has been launched at least 3 times,
		// and been installed for 5 days.
		// RateBox.create("123456","Rate This App","If you like this app, please rate it!","Rate Now","Ask Me Later","Don't ask again",3,0,5);
		
		/** Using Test Mode */
		
		// by calling useTestMode(), ratebox will send the user to an existing app on the store when you press the rate button,
		// (because your own app may not yet be published.)  remember to REMOVE this call before publishing to the app store.
		RateBox.rateBox.useTestMode();
		
		/** Targeting the Amazon App Store for Google Android */
		// *IF* this build is for the Amazon App Store for Android (not Google Play) call this method.
		// (The extension automatically does this on Kindle Fire devices)
		//RateBox.rateBox.useAmazonAppStore();
		
		/** Handling the Application Launch Event */
		// always call 'RateBox.rateBox.onLaunch()' at the start of your app to trigger an increment in the launch counter.
		// here, we call it in the NativeApplication's Event.ACTIVATE listener- because most app's run in the
		// background indefinitely, this way each time the user switches back to the app it counts as a launch.		
		NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,onActivate);		

		/** Optional Event Listeners */
		
		// optional event listeners- dispatched when the user has clicked a button in the rating dialog
		RateBox.rateBox.addEventListener(RateBoxEvent.RATE_SELECTED,onDidRate);
		RateBox.rateBox.addEventListener(RateBoxEvent.LATER_SELECTED,onDeclinedToRate);
		RateBox.rateBox.addEventListener(RateBoxEvent.NEVER_SELECTED,onWillNeverRate);
		// optional event listeners- dispatched when the rating prompt is shown, or can't be shown due to a network issue
		RateBox.rateBox.addEventListener(RateBoxEvent.NETWORK_UNAVAILABLE,onRateNotDisplayed);
		RateBox.rateBox.addEventListener(RateBoxEvent.PROMPT_DISPLAYED, onRateDisplayed);
		
		log("RateBox v"+RateBox.VERSION);
	}
	
	/** Increment the custom event counter */
	public function incrementEventCounter():void
	{
		RateBox.rateBox.incrementEventCount();
		log("incremented event count.");
	}
	
	/** Force the rating dialog to be displayed right now.  Useful if you want to design your own custom rate box display rules. */
	public function showRatingDialog():void
	{
		log("Showing dialog...");
		RateBox.rateBox.showRatingPrompt("Rate This App","Please rate my app if you like it!");
	}
	
	/** Force the internal counters for rating to be reset.  This also resets the users preference for 'never show again'. */
	public function resetRateBox():void
	{
		RateBox.rateBox.resetConditions();
		log("Reset ratebox.");
	}
	
	/** Print current state of extension */
	public function showInfo():void
	{
		log("did rate this="+RateBox.rateBox.didRateCurrentVersion()+",Conditions met="+RateBox.rateBox.areRatingConditionsMet());
	}

	//
	// Events
	//	
	
	/** App Launched */
	private function onActivate(e:Event):void
	{
		RateBox.rateBox.onLaunch();
	}
	
	/** User Rated */
	private function onDidRate(e:RateBoxEvent):void
	{
		log("User did rate!");
	}
	
	/** User Declined to rate, for now */
	private function onDeclinedToRate(e:RateBoxEvent):void
	{
		log("user declined to rate.");
	}
	
	/** User will never rate */
	private function onWillNeverRate(e:RateBoxEvent):void
	{
		log("user will never rate!");
	}
	
	/** Prompt was shown to user */
	private function onRateDisplayed(e:RateBoxEvent):void
	{
		log("Prompt is showing");
	}
	
	/** Prompt not displayed */
	private function onRateNotDisplayed(e:RateBoxEvent):void
	{
		log("Prompt could not be shown (internet connection?)");
	}

	//
	// Impelementation
	//
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",25);
		txtStatus.width=stage.stageWidth;
		txtStatus.height=200;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		addChild(txtStatus);
		
		if (buttonContainer)
		{
			removeChild(buttonContainer);
			buttonContainer=null;
		}
		
		buttonContainer=new Sprite();
		buttonContainer.y=txtStatus.height;
		addChild(buttonContainer);
		
		var uiRect:Rectangle=new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var layout:ButtonLayout=new ButtonLayout(uiRect,14);
		layout.addButton(new SimpleButton(new Command("Show Rate Box",showRatingDialog)));
		layout.addButton(new SimpleButton(new Command("Custom Event",incrementEventCounter)));
		layout.addButton(new SimpleButton(new Command("Reset Conditions", resetRateBox)));
		layout.addButton(new SimpleButton(new Command("Show Info", showInfo)));

		layout.attach(buttonContainer);
		layout.layout();	
	}
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[RBExample] "+msg);
		txtStatus.text=msg;
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
		txtLabel.defaultTextFormat=new TextFormat("Arial",32,0xFFFFFF);
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