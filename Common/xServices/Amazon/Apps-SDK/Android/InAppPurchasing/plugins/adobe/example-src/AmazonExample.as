package  
{
import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.text.TextField;
import com.amazon.nativeextensions.android.*;
import com.amazon.nativeextensions.android.events.*;

/** Amazon Example App 
 * 
 * 
 * This sample app is built for two in-app-items: my_levelpack, an entitlement, and
 * my_spell, a consumable item.  For these to work, see the PDF on how to set up products.
 * 
 * 
 * */
public class AmazonExample extends Sprite
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
	
	/** Shared Object */
	private var sharedObject:SharedObject;
	
	/** Showing what you own */
	private var txtInventory:TextField;
	
	//
	// Public Methods
	//
	
	/** Create New AmazonExample */
	public function AmazonExample() 
	{		
		createUI();
		showFullUI();
		
		if (!AmazonPurchase.isSupported())
		{
			log("Amazon Purchase is not supported on this platform (not android)");
			return;
		}
		
		log("initializing AmazonPurchase...");		
		AmazonPurchase.create();
		log("AmazonPurchase Initialized!");

		// initialize the saved state.  this is a very simple example implementation
		// and you probably want a more robust one in a real application.  you may
		// also consider obfuscating the data, and/or using an SQL database instead
		// of a shared object.
		this.sharedObject=SharedObject.getLocal("amazonPurchases");
		
		// check if the application has been loaded before.
		if (sharedObject.data["inventory"]==null)
		{
			// we also create an 'inventory' object in the save state to use later.
			sharedObject.data["inventory"]=new Object();
		}
		
		// add listeners here
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.ITEM_DATA_LOADED,onItemDataLoaded);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.ITEM_DATA_FAILED,onItemDataFailed);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_ALREADY_ENTITLED,onAlreadyEntitled);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_FAILED,onPurchaseFailed);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_SKU_INVALID,onInvalidSku);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASES_UPDATE_FAILED,onUpdateFailed);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASES_UPDATED,onPurchasesUpdate);
		AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.SDK_AVAILABLE,onSdkAvailable);		
		
	}
	
	public function loadItemData():void
	{
		log("requesting item data...");
		AmazonPurchase.amazonPurchase.loadItemData(["my_levelpack","my_spell","my_subscription.1mo","my_fakething"]);
	}
	
	public function purchaseLevelPack():void
	{
		// for this to work, you must have added 'my_levelpack' in your amazon.sdktester.json file and pushed it to the device for testing,
		// and put the same data into developers.amazon.com
		log("start purchase of item 'my_levelpack'...");
		
		// we won't let you purchase it if its already in your inventory!
		var inventory:Object=sharedObject.data["inventory"];
		if (inventory["my_levelpack"]!=null)
		{
			log("You already have a level pack!");
			return;
		}		
		
		AmazonPurchase.amazonPurchase.purchaseItem("my_levelpack");
	}
	
	public function purchaseSubscription():void
	{
		// for this to work, you must have added 'my_subscription' in your amazon.sdktester.json file and pushed it to the device for testing,
		// and put the same data into developers.amazon.com
		log("start purchase of item 'my_subscription.1mo'...");
		

		
		AmazonPurchase.amazonPurchase.purchaseItem("my_subscription.1mo");		
	}
	
	public function purchaseSpell():void
	{
		// for this to work, you must have added 'my_spell' in your amazon.sdktester.json file and pushed it to the device for testing,
		// and put the same data into developers.amazon.com
		log("start purchase of item 'my_spell'...");
		AmazonPurchase.amazonPurchase.purchaseItem("my_spell");
	}
	
	public function restoreTransactions():void
	{
		log("Restoring transactions...");
		AmazonPurchase.amazonPurchase.restoreTransactions();
		log("transactions restored.");
	}

	//
	// Events
	//	

	/** Dispatched when an item is successfully purchased */
	private function onPurchaseSuccess(e:AmazonPurchaseEvent):void
	{
		log("Successful purchase of '"+e.itemSku+"'");
		
		// update our sharedobject with the state of this inventory item.
		// this is just an example to make the process clear.  you will
		// want to make your own inventory manager class to handle these
		// types of things.
		var inventory:Object=sharedObject.data["inventory"];
		switch(e.itemSku)
		{
			case "my_levelpack":
				inventory["my_levelpack"]="purchased";
				break;
			case "my_subscription.1mo":
				inventory["my_subscription.1mo"]="purchased";
				break;
			case "my_spell":
				if (inventory["my_spell"]==null)
				{
					inventory["my_spell"]=0;
				}
				inventory["my_spell"]++;
				break;
			default:
				// we don't do anything for unknown items.
		}
		
		// save state!
		sharedObject.flush();
		
		// update the message on screen
		updateInventoryMessage();
		
		// display receipts
		var receiptStr:String="rct=[";
		for each(var receipt:AmazonPurchaseReceipt in e.receipts)
		{
			receiptStr+="{"+receipt.toString()+"},";
		}
		
		log(receiptStr);
	}
	
	/** Dispatched after a call to loadItemData */
	private function onItemDataLoaded(e:AmazonPurchaseEvent):void
	{
		var validStr:String="";
		for each(var item:AmazonItemData in e.itemDatas)
		{
			validStr+=item.sku+",";
		}
		log("Loaded "+e.itemDatas.length+"items,invalid=["+e.unavailableSkus.join(",")+"],valid=["+validStr+"]");	
		

	}
	
	/** Dispatched when an error occurs loading item data */
	private function onItemDataFailed(e:AmazonPurchaseEvent):void
	{
		log("Error loading item data.");
	}
	
	/** Dispatched when you try to purchase a non-consumable you already own */
	private function onAlreadyEntitled(e:AmazonPurchaseEvent):void
	{
		log("already entitled to item "+e.itemSku);
	}
	
	/** Dispatched when a purchase fails due to user cancelling or unknown error. */
	private function onPurchaseFailed(e:AmazonPurchaseEvent):void
	{
		log("failed to purchase "+e.itemSku);
	}
	
	/** Dispatched when attempting to purchase an invalid sku */
	private function onInvalidSku(e:AmazonPurchaseEvent):void
	{
		log("sku was invalid- "+e.itemSku);
	}
	
	/** Can be fired any time after initialization, if a purchase update has failed. */
	private function onUpdateFailed(e:AmazonPurchaseEvent):void
	{
		log("failed to update.");
	}
	
	/** this event can happen at any time after initialization.
	 *  it's a good practice to update your statuses here, 
	 *	in case a purchase has been canceled or refunded etc.
	 * */
	private function onPurchasesUpdate(e:AmazonPurchaseEvent):void
	{
		var inventory:Object=sharedObject.data["inventory"];

		// we can only care about non-consumables, of which this app
		// has one, the level pack.
		//
		// we set it to false first, assuming it was never purchased.
		// then loop through the receipts, if theres a receipt, set it to true (purchased).
		
		inventory["my_levelpack"]=null;
		for each(var receipt:AmazonPurchaseReceipt in e.receipts)
		{	
			if (receipt.sku=="my_levelpack")
			{
				//log("found receipt");
				
				inventory["my_levelpack"]="purchased";
			}
		}
		
		// save state!
		sharedObject.flush();
		
		// update the message on screen
		updateInventoryMessage();		
	}
	
	/** This Event is fired shortly after initialization.  the isSandboxMode property will be 'true',
	 * if you're in test mode and not the real store.
	 * */
	private function onSdkAvailable(e:AmazonPurchaseEvent):void
	{
		log("SDK loaded, sandbox="+e.isSandboxMode);
	}

	//
	// Impelementation
	//
	
	/** Update Inventory Message */
	public function updateInventoryMessage():void
	{
		var inventory:Object=sharedObject.data["inventory"];
		
		var hasLevelpack:Boolean;
		var numberOfSpells:int;
		// if the value is set to something, you have it
		if (inventory["my_levelpack"]!=null)
		{
			hasLevelpack=true;
		}
		else
		{
			hasLevelpack=false;
		}
		
		// for the spells, we store an int of how many you own
		// if there's no value there at all, we just use 0
		if (inventory["my_spell"]==null)
		{
			numberOfSpells=0;
		}
		else
		{
			numberOfSpells=inventory["my_spell"];
		}
		
		txtInventory.text="Has Levelpack? "+hasLevelpack+", Spells Owned: "+numberOfSpells;
	}
	
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
		
		txtInventory=new TextField();
		txtInventory.defaultTextFormat=new flash.text.TextFormat("Arial",25);
		txtInventory.width=stage.stageWidth;
		txtInventory.multiline=true;
		txtInventory.wordWrap=true;
		txtInventory.text="Inventory:";
		txtInventory.y=stage.stageHeight-txtInventory.textHeight*1.1;
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
		layout.addButton(new SimpleButton(new Command("Get Item Data",loadItemData)));
		layout.addButton(new SimpleButton(new Command("Buy Level Pack",purchaseLevelPack)));
		layout.addButton(new SimpleButton(new Command("Buy subscription",purchaseSubscription)));
		layout.addButton(new SimpleButton(new Command("Buy spell",purchaseSpell)));
		layout.addButton(new SimpleButton(new Command("Restore Transactions",restoreTransactions)));

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