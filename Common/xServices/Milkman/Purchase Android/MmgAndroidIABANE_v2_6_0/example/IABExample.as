package  
{
import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.text.TextField;
import com.milkmangames.nativeextensions.android.*;
import com.milkmangames.nativeextensions.android.events.*;

/** IABExample App 
 * 
 * You need to put in your public key in YOUR_PUBLIC_KEY_HERE.  You can find this in the Google Play control panel.  See the pdf for more information.
 * 
 * This sample app is built for three in-app-products: my_levelpack, my_spell, and my_subscription.  For these to work, see the PDF on how to set up products.
 * 
 * This is a Class.  Copy and pasting the whole thing into the flash timeline will not work!  To use it in flash, set up a new project and add the extension (read GettingStarted.pdf for details instructions.)  Then, paste this file in the directory with your fla, and in the 'Document Class' textfield, type 'IABExample' .  Then build and run on your phone. 
 * 
 * 
 * */
public class IABExample extends Sprite
{
	//
	// Definitions
	//
	
		
	/** Your Public Key */
	private static const PUBLIC_KEY:String="YOUR_PUBLIC_KEY_HERE";

	//
	// Instance Variables
	//
	
	/** Status */
	private var txtStatus:TextField;
	
	/** Buttons */
	private var buttonContainer:Sprite;
	
	/** Showing what you own */
	private var txtInventory:TextField;
	
	/** My Purchases */
	private var myPurchases:Vector.<AndroidPurchase>;
	
	//
	// Public Methods
	//
	
	/** Create New IABExample */
	public function IABExample() 
	{		
		createUI();
		hideUI();
		
		if (!AndroidIAB.isSupported())
		{
			log("Android Billing is not supported on this platform.");
			return;
		}
		
		log("initializing Android billing..");		
		AndroidIAB.create();
		log("AndroidIAB Initialized.");
		
		// listeners for billing service startup
		AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY,onServiceReady);
		AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED, onServiceUnsupported);
		
		// listeners for making a purchase
		AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
		AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, onPurchaseFailed);
		
		// listeners for player's owned items
		AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED, onInventoryLoaded);
		AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, onInventoryFailed);
		
		// listeners for consuming an item
		AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, onConsumed);
		AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.CONSUME_FAILED, onConsumeFailed);
		
		// listeners for item details
		AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.ITEM_DETAILS_LOADED, onItemDetails);
		AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.ITEM_DETAILS_FAILED, onDetailsFailed);
		
		// start the  billing service.  in onServiceReady(), we'll update everything else.
		log("starting billing service...");
		AndroidIAB.androidIAB.startBillingService(PUBLIC_KEY);
		log("Waiting for biling response...");
		
	}

	/** Dispatched when the billing service is started -now you can make other calls */
	private function onServiceReady(e:AndroidBillingEvent):void
	{
		showFullUI();
		// as soon as it starts, we load up the player's inventory to get a list of what they own
		log("Service ready. Loading inventory...");		
		AndroidIAB.androidIAB.loadPlayerInventory();
		
	}
	
	/** Do a test purchase.  This will work without charging you real money */
	public function testPurchase():void
	{
		log("starting test of a successful item purchase...");
		AndroidIAB.androidIAB.testPurchaseItemSuccess();
		log("Waiting for test purchase response...");
	}

	/** Simulate trying to buy an invalid item */
	public function testUnavailable():void
	{
		log("Start purchase unavailable item...");
		AndroidIAB.androidIAB.testPurchaseItemUnavailable();
		log("Waiting for unavailable response...");
	}
	
	/** Simulate buying an item that will be rejected by Google */
	public function testCancel():void
	{
		log("Start purchase cancel item...");
		AndroidIAB.androidIAB.testPurchaseItemCancelled();
		log("Waiting for cancel response...");		
	}
	
	/** Purchase a level pack.  Assumes you've created 'my_levelpack' in the Google Play Control Panel */
	public function purchaseLevelPack():void
	{
		// for this to work, you must have added 'my_levelpack' in the google play website
		log("start purchase of managed item 'my_levelpack'...");
		
		// check if we already own this item.  myPurchases was previously loaded by loadPlayerInventory()
		if (myPurchases)
		{
			for each(var purchase:AndroidPurchase in myPurchases)
			{
				if (purchase.itemId=="my_levelpack")
				{
					log("You already own the levelpack!");
					return;
				}
			}
		}
		
		AndroidIAB.androidIAB.purchaseItem("my_levelpack");
		log("Waiting for purchase response...");
	}
	
	/** Purchase a subscription.  Assumes you've created 'my_subscription' in the Google Play Control panel */
	public function purchaseSub():void
	{
		log("Start test subscription purchase my_subscription...");		
		AndroidIAB.androidIAB.purchaseSubscriptionItem("my_subscription");
		log("Waiting for subscription purchase response...");
	}
	
	/** Purchase a spell.  Assumes you've created 'my_spell' in the Google Play Control Panel */
	public function purchaseSpell():void
	{
		// for this to work, you must have added 'my_spell' in google play website
		log("start purchase of item 'my_spell'...");
		AndroidIAB.androidIAB.purchaseItem("my_spell");
		log("Waiting for purchase response...");
	}

	/** Consumes a spell.  If you 'consume' an item you've owned, its removed from your inventory and you can buy it again! */
	public function consumeSpell():void
	{
		log("Consuming spell...");
		AndroidIAB.androidIAB.consumeItem("my_spell");
		log("Waiting for consume response...");
	}

	/** Refresh the player's inventory from the server.  */
	public function reloadInventory():void
	{
		log("Loading inventory...");
		AndroidIAB.androidIAB.loadPlayerInventory();
		log("Waiting for inventory...");
	}
	
	/** Get details, such as price, title, description, etc.- for the given tiems */
	public function loadItemDetails():void
	{
		var allItems:Vector.<String>=new <String>["my_spell", "my_subscription", "my_levelpack"];
		log("Loading item details for "+allItems.join(","));
		AndroidIAB.androidIAB.loadItemDetails(allItems);
		log("Waiting for item details...");
	}
	
	//
	// Events
	//	

	
	/** This will be triggered if Google Play billing is not supported on the device. */
	private function onServiceUnsupported(e:AndroidBillingEvent):void
	{
		log("billing service not supported.");
	}
	
	/** Called after a successful item purchase. */
	private function onPurchaseSuccess(e:AndroidBillingEvent):void
	{
		log("Successful purchase of '"+e.itemId+"'="+e.purchases[0]);

		// every time a purchase is updated, refresh your inventory from the server.
		reloadInventory();
	}
	
	/** This is called when an error occurs trying to buy something */
	private function onPurchaseFailed(e:AndroidBillingErrorEvent):void
	{
		log("Failure purchasing '"+e.itemId+"', reason:"+e.text);
	}

	/** Callback when the player's inventory has been loaded, after calling loadPlayerInventory() */	
	private function onInventoryLoaded(e:AndroidBillingEvent):void
	{
		log("Inventory updated.");
		this.myPurchases=e.purchases;
		updateInventoryMessage();
	}
	
	/** Getting the inventory failed */
	private function onInventoryFailed(e:AndroidBillingErrorEvent):void
	{
		log("Failed loading inventory: "+e.errorID+"/"+e.text);
	}
	
	/** Details about the available items is loaded */
	private function onItemDetails(e:AndroidBillingEvent):void
	{
		log("details: ["+e.itemDetails.length+"]="+e.itemDetails.join(","));
		
		// the itemDetails property now contains the item info
		for each(var item:AndroidItemDetails in e.itemDetails)
		{
			trace("item id:"+item.itemId);
			trace("title:"+item.title);
			trace("description:"+item.description);
			trace("price:"+item.price);
		}
	}
	
	/** An error occurred loading the item details */
	private function onDetailsFailed(e:AndroidBillingErrorEvent):void
	{
		log("Error loading details: "+e.errorID+"/"+e.text);
	}
	
	/** An Item was successfully consumed */
	private function onConsumed(e:AndroidBillingEvent):void
	{
		log("Did consume item:"+e.itemId);
		// reload inventory now that it has changed
		AndroidIAB.androidIAB.loadPlayerInventory();		
	}
	
	/** Attempt to consume item has failed */
	private function onConsumeFailed(e:AndroidBillingErrorEvent):void
	{
		log("Consume spell failed:"+e.errorID+"/"+e.text);
	}

	//
	// Impelementation
	// Code beyond this point sets up the ui for the example.
	//
	
	/** Update Inventory Message */
	public function updateInventoryMessage():void
	{
		var allOwnedItemIds:Vector.<String>=new Vector.<String>();
		if (myPurchases==null)
		{
			this.txtInventory.text="Inventory: (not loaded)";
			return;
		}
		
		for each(var purchase:AndroidPurchase in myPurchases)
		{
			trace("You own the item:"+purchase.itemId);
			allOwnedItemIds.push(purchase.itemId);
		}
		
		this.txtInventory.text="Inventory: {"+allOwnedItemIds.join(", ")+"}";

	}
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",25);
		txtStatus.width=stage.stageWidth;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		addChild(txtStatus);
		
		txtInventory=new TextField();
		txtInventory.defaultTextFormat=new flash.text.TextFormat("Arial",25);
		txtInventory.width=stage.stageWidth;
		txtInventory.multiline=true;
		txtInventory.wordWrap=true;
		txtInventory.text="Inventory: (not loaded)";
		txtInventory.y=stage.stageHeight-txtInventory.textHeight*2.2;
		addChild(txtInventory);

	}
		
	/** Hide the UI */
	public function hideUI():void
	{
		if (buttonContainer)
		{
			removeChild(buttonContainer);
			buttonContainer=null;
		}
	}
	
	/** Show full UI Options (service is running) */
	public function showFullUI():void
	{
		log("show full ui");
		if (buttonContainer)
		{
			removeChild(buttonContainer);
			buttonContainer=null;
		}
		
		buttonContainer=new Sprite();
		buttonContainer.y=txtStatus.height;
		addChild(buttonContainer);
		
		var uiRect:Rectangle=new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var layout:ButtonLayout=new ButtonLayout(uiRect, 14);
		layout.addButton(new SimpleButton(new Command("Load Item Details", loadItemDetails)));
		layout.addButton(new SimpleButton(new Command("Reload Inventory", reloadInventory)));
		layout.addButton(new SimpleButton(new Command("Test Purchase Success", testPurchase)));
		layout.addButton(new SimpleButton(new Command("Test Purchase Fail", testCancel)));
		layout.addButton(new SimpleButton(new Command("Buy Level Pack",purchaseLevelPack)));
		layout.addButton(new SimpleButton(new Command("Buy spell",purchaseSpell)));
		layout.addButton(new SimpleButton(new Command("Buy subscription",purchaseSub)));
		layout.addButton(new SimpleButton(new Command("Consume (use) Spell", consumeSpell)));

		layout.attach(buttonContainer);
		layout.layout();	
	}
	
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[IABExample] "+msg);
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