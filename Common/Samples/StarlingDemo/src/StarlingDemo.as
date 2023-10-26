package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import starling.core.Starling;
	
	public class StarlingDemo extends Sprite
	{
		public function StarlingDemo()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var textField:TextField = new TextField();
			textField.text = "as3 text field";
			addChild(textField);
			
			var viewPortRectangle:Rectangle = new Rectangle(0, 0, 300, 400);
			var starling:Starling = new Starling(SSprite, this.stage, viewPortRectangle);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xff0000, 0.5);
			shape.graphics.drawRect(10, 10, 100, 120);
			shape.graphics.endFill();
			addChild(shape);
		}
	}
}