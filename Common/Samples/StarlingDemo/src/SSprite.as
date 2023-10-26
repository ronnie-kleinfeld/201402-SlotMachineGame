package
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class SSprite extends Sprite
	{
		public function SSprite()
		{
			super();
			
			var textField:TextField = new TextField(100, 200, "starling text field");
			textField.x = 200;
			textField.y = 200;
			addChild(textField);
		}
	}
}