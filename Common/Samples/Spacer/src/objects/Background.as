package objects
{
	import core.Assets;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Background extends Sprite
	{
		private var sky1:Image;
		private var sky2:Image;
		
		public function Background()
		{
			sky1 = new Image(Assets.skyTexture);
			sky1.blendMode = BlendMode.NONE;
			addChild(sky1);
			
			sky2 = new Image(Assets.skyTexture);
			sky2.blendMode = BlendMode.NONE;
			sky2.y = -800;
			addChild(sky2);			
		}
		
		public function update():void
		{
			sky1.y += 4;
			if(sky1.y == 800)
				sky1.y = -800;
			sky2.y += 4;
			if(sky2.y == 800)
				sky2.y = -800;
		}
	}
}