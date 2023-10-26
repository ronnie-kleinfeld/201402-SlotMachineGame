package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import core.Game;
	
	import starling.core.Starling;
	
	[SWF(width=800, height=800, frameRate=60, backgroundColor=0x000000)]
	public class Spacer extends Sprite
	{
		public function Spacer()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var star:Starling = new Starling(Game, stage);
			star.showStats = true;
			star.start();
		}
	}
}