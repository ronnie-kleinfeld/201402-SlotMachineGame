package  
{
import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.text.TextField;
import com.milkmangames.nativeextensions.ios.*;
import com.milkmangames.nativeextensions.ios.events.*;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

/** IAdExample App */
public class IAdExample extends Sprite
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
	
	/** Create New IAdExample */
	public function IAdExample() 
	{		
		createUI();		
		init();
	}

	
	/** Init */
	public function init():void
	{
		// check if IAd is supported.  note that this just determines platform support- iOS - and not
		// whether the particular version supports it.
		
		if (!IAd.isSupported())
		{
			log("IAd is not supported on this platform.");
			return;
		}
		
		IAd.create();
		log("IAd Initialized.");
		
		log("Checking os level support...");		
		
		// IAd doesn't work on iOS versions < 4.2, so always check this first!
		if (!IAd.iAd.isIAdAvailable())
		{
			log("this ios version doesn't have iAd extension.");
			removeChild(buttonContainer);
			return;
		} 
		
		// interstitials will only work for iPads, or iPhones and iPod Touches running iOS 7+.  
		var canUseInterstitial:Boolean=IAd.iAd.isInterstitialAvailable();
		if (canUseInterstitial)
		{
			showFullUI();
		}
		else
		{
			showBannerOnlyUI();
		}
		
		log("iAd is ready- v"+IAd.VERSION);
		
		// this is the complete suite of supported events.  all are optional.
		IAd.iAd.addEventListener(IAdEvent.BANNER_ACTION_BEGIN,onBannerActionBegin);
		IAd.iAd.addEventListener(IAdEvent.BANNER_ACTION_FINISHED,onBannerActionFinished);
		IAd.iAd.addEventListener(IAdEvent.BANNER_AD_LOADED,onBannerAdLoaded);
		IAd.iAd.addEventListener(IAdErrorEvent.BANNER_AD_FAILED,onBannerAdFailed);
		IAd.iAd.addEventListener(IAdEvent.INTERSTITIAL_AD_LOADED,onInterstitialAdLoaded);
		IAd.iAd.addEventListener(IAdErrorEvent.INTERSTITIAL_AD_FAILED, onInterstitialAdFailed);	
		IAd.iAd.addEventListener(IAdEvent.INTERSTITIAL_SHOWN, onInterstitialShown);
		IAd.iAd.addEventListener(IAdEvent.INTERSTITITAL_DISMISSED, onInterstitialDismissed);
	}
	
	/** Show Banner Ad Top of Screen */
	public function showBannerAdTop():void
	{
		log("about to create banner ad top...");
		// this app example runs only in landscape mode, so is using IAdContentSize.LANDSCAPE.
		// if your application runs only in portrait, you should use IAdContentSizes.PORTRAIT,
		// if it runs in BOTH orientation, use IAdContentSize.PORTRAIT_AND_LANDSCAPE.
		IAd.iAd.createBannerAd(IAdBannerAlignment.TOP,IAdContentSize.PORTRAIT_AND_LANDSCAPE);		
	}
	
	/** Show Banner Ad Bottom of Screen */
	public function showBannerAdBottom():void
	{
		log("about to create banner ad bottom...");
		// this app example runs only in landscape mode, so is using IAdContentSize.LANDSCAPE.
		// if your application runs only in portrait, you should use IAdContentSizes.PORTRAIT,
		// if it runs in BOTH orientation, use IAdContentSize.PORTRAIT_AND_LANDSCAPE.
		IAd.iAd.createBannerAd(IAdBannerAlignment.BOTTOM,IAdContentSize.PORTRAIT_AND_LANDSCAPE);
	}
	
	/** Make Banner Visible */
	public function bannerVisibilityOn():void
	{
		log("set visibility on.");
		IAd.iAd.setBannerVisibility(true,true);
	}
	
	/** Make Banner Invisible */
	public function bannerVisibilityOff():void
	{
		log("set visibility off.");
		IAd.iAd.setBannerVisibility(false,true);
	}
	
	/** Destroy Banenr Ad */
	public function destroyBannerAd():void
	{
		log("destroying banner.");
		IAd.iAd.destroyBannerAd();
	}
	
	/** Load And Show Interstitial */
	public function loadAndShowInterstitital():void
	{
		// you can't load an interstitial until the last interstitial is gone- if you try
		// there will be an error thrown.  if you want to load them in succession,
		// wait for either INTERSTITIAL_DISMISSED or INTERSTITIAL_AD_FAILED 
		// before loading the next one.
		
		try
		{
			log("showing interstitial...");
			// 'true' means it will show automatically when loaded.
			IAd.iAd.loadInterstitial(true);
			log("Waiting for interstitial to load...");
		}
		catch (e:Error)
		{
			log("Can't load right now- did you wait for the old interstitial to finish?");
			return;
		}
	}
	
	/** Preload an Interstitial to Show Later */
	public function preloadInterstitial():void
	{
		// you can't preload an interstitial until the last interstitial is gone- if you try
		// there will be an error thrown.  if you want to load them in succession,
		// wait for either INTERSTITIAL_DISMISSED or INTERSTITIAL_AD_FAILED 
		// before loading the next one.
		
		try
		{
			log("Preloading interstitial...");
			// 'false' means it will not show automatically when loaded - need to call showPendingInterstitial() later.
			IAd.iAd.loadInterstitial(false);
		} 
		catch (e:Error)
		{
			log("Can't load right now- did you wait for the old interstitial to finish?");
			return;
		}
		

		log("Waiting for interstitial to preload...");
	}
	
	/** Show a preloaded Interstitial */
	public function showPendingInterstitial():void
	{
		if (IAd.iAd.isInterstitialReady())
		{
			log("Showing pending interstitial...");
			IAd.iAd.showPendingInterstitial();
			log("Interstitial shown.");
		}
		else
		{
			log("Interstitial not yet preloaded!");
		}
	}
	
	//
	// Events
	//
	
	private function onBannerActionBegin(e:IAdEvent):void
	{
		log("banner action begin, will leave?"+e.willLeaveApplication);
	}
	
	private function onBannerActionFinished(e:IAdEvent):void
	{
		log("banner action end.");
	}
	
	private function onBannerAdLoaded(e:IAdEvent):void
	{
		log("banner ad loaded.");
	}
	
	private function onInterstitialShown(e:IAdEvent):void
	{
		log("Interstitial shown!");
	}
	
	private function onInterstitialDismissed(e:IAdEvent):void
	{
		log("Interstitial dismissed!");
	}
	
	private function onInterstitialAdLoaded(e:IAdEvent):void
	{
		log("interstitial loaded.");
	}
	

	private function onBannerAdFailed(e:IAdErrorEvent):void
	{
		log("banner ad failed, code="+e.errorID+",msg="+e.text);
	}
	
	private function onInterstitialAdFailed(e:IAdErrorEvent):void
	{
		log("interstitial load failed, code="+e.errorID+",msg="+e.text);
	}

		
	//
	// Impelementation
	//
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[IAdExample] "+msg);
		txtStatus.text=msg;
	}
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",19);
		txtStatus.width=stage.stageWidth;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		txtStatus.y=txtStatus.textHeight;
		addChild(txtStatus);
	}
	
	/** Show Banner Only UI */
	public function showBannerOnlyUI():void
	{
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
		layout.addButton(new SimpleButton(new Command("Create Banner Top",showBannerAdTop)));
		layout.addButton(new SimpleButton(new Command("Create Banner Bottom",showBannerAdBottom)));
		layout.addButton(new SimpleButton(new Command("Banner vis false",bannerVisibilityOff)));
		layout.addButton(new SimpleButton(new Command("Banner vis true",bannerVisibilityOn)));
		layout.addButton(new SimpleButton(new Command("Banner Destroy",destroyBannerAd)));

		layout.attach(buttonContainer);
		layout.layout();	
	}
	
	/** Show full UI Options  */
	public function showFullUI():void
	{
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
		layout.addButton(new SimpleButton(new Command("Create Banner Top",showBannerAdTop)));
		layout.addButton(new SimpleButton(new Command("Create Banner Bottom",showBannerAdBottom)));
		layout.addButton(new SimpleButton(new Command("Banner vis false",bannerVisibilityOff)));
		layout.addButton(new SimpleButton(new Command("Banner vis true",bannerVisibilityOn)));
		layout.addButton(new SimpleButton(new Command("Banner Destroy",destroyBannerAd)));
		layout.addButton(new SimpleButton(new Command("Interstitial Load+Show", loadAndShowInterstitital)));
		layout.addButton(new SimpleButton(new Command("Interstitial Preload", preloadInterstitial)));
		layout.addButton(new SimpleButton(new Command("Interstitial Show Pending", showPendingInterstitial)));

		layout.attach(buttonContainer);
		layout.layout();	
	}
}
}

//
// Code Below is generic code for building UI
//


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
		txtLabel.defaultTextFormat=new TextFormat("Arial",42,0xFFFFFF);
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