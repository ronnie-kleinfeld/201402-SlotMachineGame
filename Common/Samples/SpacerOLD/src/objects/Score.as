package objects
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class Score extends Sprite
	{
		private var score:TextField;
		
		public function Score()
		{
			score = new TextField(300, 100, "0", "KomikaAxis", 32, 0xFFFFFF);
			score.hAlign = "right";
			addChild(score);
		}
		
		public function addScore(amt:Number):void
		{
			score.text = (parseInt(score.text) + amt).toString();
		}
	}
}