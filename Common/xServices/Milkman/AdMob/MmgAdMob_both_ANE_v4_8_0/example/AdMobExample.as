package  
{
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import com.milkmangames.nativeextensions.*;
import com.milkmangames.nativeextensions.events.*;

/** AdMobExample App */
public class AdMobExample extends Sprite
{
	//
	// Instance Variables
	//
	
	/** Status */
	private var txtStatus:TextField;
	
	/** Buttons */
	private var buttonContainer:Sprite;
	
	/** Visibility */
	private var adIsVisible:Boolean;
	
	//
	// Public Methods
	//
	
	/** Create New AdMobExample */
	public function AdMobExample() 
	{		
		adIsVisible=true;
		createUI();
		
		if (!AdMob.isSupported)
		{
			log("AdMob is not supported on this platform.");
			removeChild(buttonContainer);
			return;
		}
		
		log("initializing AdMob...");		
		
		// for the AdMob for Android or AdMob for iOS Extension:
		AdMob.init("your ad unit id here!");
		
		// for the AdMob for Android AND iOS Extension:
		// AdMob.init("your_android_p_id","your_ios_id");
		
		log("AdMob v"+AdMob.VERSION+" Initialized!");
		
		// during TESTING, activate test IDs.  You want to REMOVE this before publishing your final application.
		AdMob.enableTestDeviceIDs(AdMob.getCurrentTestDeviceIDs());
		
		AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD,onFailedReceiveAd);
		AdMob.addEventListener(AdMobEvent.RECEIVED_AD,onReceiveAd);
		AdMob.addEventListener(AdMobEvent.SCREEN_PRESENTED,onScreenPresented);
		AdMob.addEventListener(AdMobEvent.SCREEN_DISMISSED,onScreenDismissed);
		AdMob.addEventListener(AdMobEvent.LEAVE_APPLICATION,onLeaveApplication);
		
		
	}
	
	/** Destroy Banner Ad */
	public function destroyAd():void
	{
		log("Destroying ad.");
		AdMob.destroyAd();
		log("->ad destroyed");
	}
	
	/** Show Smart Banner Ad */
	public function showSmartBanner():void
	{
		log("->display smart banner.");
		AdMob.showAd(AdMobAdType.SMART_BANNER, AdMobAlignment.LEFT, AdMobAlignment.BOTTOM);
		log("Requested show smart banner.");
	}
	
	/** Show Ad */
	public function showAdTopLeft():void
	{
		log("->display ad top left...");
		AdMob.showAd(AdMobAdType.BANNER, AdMobAlignment.LEFT, AdMobAlignment.TOP);
		log("Requested show ad top left.");
	}
	
	/** Show Ad */
	public function showAdTopRight():void
	{
		log("->display ad top right...");
		AdMob.showAd(AdMobAdType.BANNER, AdMobAlignment.RIGHT, AdMobAlignment.TOP);
		log("Requested show ad top right.");
	}
	
	/** Show Ad */
	public function showAdBottomCenter():void
	{
		log("->display ad bottom center...");
		AdMob.showAd(AdMobAdType.BANNER, AdMobAlignment.CENTER, AdMobAlignment.BOTTOM);
		log("Requested show ad bottom center.");
	}
	
	/** Refresh Ad */
	public function refreshAd():void
	{
		log("Refreshing banner ad.");
		AdMob.refreshAd();
	}
	
	/** Toggle Ad Visibility */
	public function toggleAdVisibility():void
	{
		adIsVisible=!adIsVisible;
		log("Toggle visibility.");
		try
		{
			AdMob.setVisibility(adIsVisible);
		}
		catch (e:Error)
		{
			log("cant change visibility - do you have an ad loaded?");
			adIsVisible=!adIsVisible;
		}
	}
	
	/** Load Interstitial Ad, with automatic display */
	public function showInterstitialAd():void
	{
		log("Loading interstitial..");
		
		// you can't load an interstitial until the last interstitial is gone- if you try
		// there will be an error thrown.  if you want to load them in succession,
		// wait for either SCREEN_DISMISSED or FAILED_TO_RECEIVE_AD (with isInterstitial=true)
		// before loading the next one.		
		try
		{
			AdMob.loadInterstitial("interstitial ad unit id here", true);
		}
		catch (e:Error)
		{
			log("Can't load right now- did you wait for the old interstitial to finish?");
			return;
		}
		
		// if you are targeting ios and android with the same code, and have an ad unit id
		// for each platform, put the ios one last
		//AdMob.loadInterstitial("android interstitial ad unit id here", true, "ios interstitial ad unit id here");
		
		log("Waiting for interstitial to auto-show.");		
	}
	
	/** Preload an interstitial ad */
	public function preloadInterstitialAd():void
	{
		log("Preoading interstitial..");
		
		// you can't preload an interstitial until the last interstitial is gone- if you try
		// there will be an error thrown.  if you want to load them in succession,
		// wait for either SCREEN_DISMISSED or FAILED_TO_RECEIVE_AD (with isInterstitial=true)
		// before loading the next one.
		
		try
		{
			AdMob.loadInterstitial("interstitial ad unit id here", false);
		} 
		catch (e:Error)
		{
			log("Can't load right now- did you wait for the old interstitial to finish?");
			return;
		}
		// if you are targeting ios and android with the same code, and have an ad unit id
		// for each platform, put the ios one last
		//AdMob.loadInterstitial("android interstitial ad unit id here", false, "ios interstitial ad unit id here");
		
		log("Waiting for interstitial to preload.");		
	}	
	
	/** Show Pending Interstitial */
	public function showPendingInterstitial():void
	{
		var isInterstitialReady:Boolean=AdMob.isInterstitialReady();
		if (!isInterstitialReady)
		{
			log("The interstitial is not yet preloaded!");
			return;
		}
		
		log("Showing preloaded interstitial.");
		AdMob.showPendingInterstitial();
	}
	
	//
	// Events
	//
	
	/** On Failed Receive Ad */
	private function onFailedReceiveAd(e:AdMobErrorEvent):void
	{
		log("ERROR receiving ad, reason: '"+e.text+"'");
	}
	
	/** On Receive Ad */
	private function onReceiveAd(e:AdMobEvent):void
	{
		log("Received ad:"+e.isInterstitial+":"+e.dimensions);
	}
	
	/** On Screen Presented */
	private function onScreenPresented(e:AdMobEvent):void
	{
		log("Screen Presented.");
	}
	
	/** On Screen Dismissed */
	private function onScreenDismissed(e:AdMobEvent):void
	{
		log("Screen Dismissed.");
	}
	
	/** On Leave Application */
	private function onLeaveApplication(e:AdMobEvent):void
	{
		log("Leave Application.");
	}
	
	
	//
	// Impelementation
	//
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[AdMobExample] "+msg);
		txtStatus.text=msg;
	}
	
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",10);
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
		layout.addButton(new SimpleButton(new Command("Show Smart Banner", showSmartBanner)));
		layout.addButton(new SimpleButton(new Command("Show Ad TopLeft",showAdTopLeft)));
		layout.addButton(new SimpleButton(new Command("Show Ad TopRight",showAdTopRight)));
		layout.addButton(new SimpleButton(new Command("Show Ad BtmCenter", showAdBottomCenter)));
		layout.addButton(new SimpleButton(new Command("Show Interstitial", showInterstitialAd)));
		layout.addButton(new SimpleButton(new Command("Preload Interstitial", preloadInterstitialAd)));
		layout.addButton(new SimpleButton(new Command("Show Pending Interstitial", showPendingInterstitial)));
		layout.addButton(new SimpleButton(new Command("Refresh Banner",refreshAd)));
		layout.addButton(new SimpleButton(new Command("Destroy Banner",destroyAd)));
		layout.addButton(new SimpleButton(new Command("Toggle Visibility",toggleAdVisibility)));
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