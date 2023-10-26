/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * This is a test application for the distriqt extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.DialogTheme;
	import com.distriqt.extension.dialog.events.DialogEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**	
	 * Sample application for using the Dialog Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestDialog extends Sprite
	{
		public static const DEV_KEY : String = "your_dev_key";
		
		/**
		 * Class constructor 
		 */	
		public function TestDialog()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Dialog.init( DEV_KEY );
				
				message( "Dialog Supported: "+ String(Dialog.isSupported) );
				message( "Dialog Version: " + Dialog.service.version );
				
				Dialog.service.addEventListener( DialogEvent.DIALOG_CLOSED, dialog_dialogClosedHandler, false, 0, true );
				Dialog.service.addEventListener( DialogEvent.DIALOG_CANCELLED, dialog_dialogCancelledHandler, false, 0, true );
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	EXAMPLE A
			//		Show an alert dialog
			//	
			
//			var titleString:String = "test";
//			var messageString:String = "";
//			var cancelLabel:String = "cancel";
//			var otherLabels:Array = ["other 1", "other 2"];
//			
//			// Add some random otherLabels
//			var extraButtonCount:int = Math.ceil( Math.random()*5 );
//			for (var i:int = 0; i < extraButtonCount; i++)
//			{
//				otherLabels.push( "button " +String(i+1) ); 
//			}
//			
//			message( "showAlertDialog("+titleString+","+messageString+","+cancelLabel+","+otherLabels.join(",")+")");
//			Dialog.service.showAlertDialog( 0, titleString+"0", messageString, cancelLabel, otherLabels );
//			
//			message( "showMultipleChoiceDialog("+titleString+","+messageString+","+otherLabels.join(",")+")");
//			Dialog.service.showMultipleChoiceDialog( 1, titleString+"1", messageString, otherLabels );
		
			var otherLabels:Array = ["1 Star", "2 Stars", "3 Stars", "4 Stars"];
			Dialog.service.showMultipleChoiceDialog(0, "How did you like the Coco Loco from Arcadia Breweing?", "",  otherLabels);
			
//			setInterval( dismissDialog, 2000 );
			
			
			
			//
			//	EXAMPLE B
			//		Progress Dialog example
			//
//			clearInterval( progressInterval );
//			Dialog.service.dismissProgressDialog(1);
//			if (Dialog.service.showProgressDialog( 1, "Loading", "", Dialog.DIALOG_PROGRESS_STYLE_DETERMINATE, true, DialogTheme.THEME_LIGHT ))
//			{
//				progress = 0;
//				progressInterval = setInterval( progressDialogIntervalHandler, 2000 );
//			}
//			else
//			{
//				message( "Progress Dialog not supported" );
//			}
		}
		
		//
		//	PROGRESS DIALOG EXAMPLE HANDLERS
		//
		
		private var progressInterval:uint;
		private var progress:Number = 0;
		
		private function progressDialogIntervalHandler():void
		{
			// Update the progress dialog
			progress += 0.01;
			Dialog.service.updateProgressDialog( 1, progress );
			
//			clearInterval( progressInterval );
//			Dialog.service.dismissProgressDialog(1);
		}
		
		
		private function dismissDialog():void
		{
			Dialog.service.dismissDialog( 2 );
		}
		
		
		//
		//	DIALOG NOTIFICATION HANDLERS
		//
		
		private function dialog_dialogClosedHandler( event:DialogEvent ):void
		{
			message( "Dialog Closed: id="+event.id +" button="+event.data );
			clearInterval( progressInterval );
		}
		
		private function dialog_dialogCancelledHandler( event:DialogEvent ):void
		{
			message( "Dialog Cancelled: id="+event.id +" data="+event.data );
			clearInterval( progressInterval );
		}
		
	}
}

