package
{
	import com.adobe.nativeExtensions.Vibration;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Vibrate extends Sprite
	{
		private var tf:TextField;
		
		public function Vibrate()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			tf = new TextField();
			tf.text = "Init";
			addChild(tf);
			
			tf.addEventListener(MouseEvent.CLICK, onClick);
			
			onClick(null);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			tf.appendText("\nClicked");
			if (Vibration.isSupported)
			{
				tf.appendText("\nisSupported");
				var vb:Vibration = new Vibration();
				vb.vibrate(2000);
				tf.appendText("\nVibration");
			}
		}
	}
}