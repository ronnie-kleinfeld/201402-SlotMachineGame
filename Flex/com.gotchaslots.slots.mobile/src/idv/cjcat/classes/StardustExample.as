package idv.cjcat.classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import idv.cjcat.stardust.common.emitters.Emitter;
	
	public class StardustExample extends MovieClip
	{
		protected var container:Sprite;
		protected var emitter:Emitter;
		
		public function StardustExample()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			container = new Sprite();
			addChild(container);
			buildExtraObjects();
			buildParticleSystem();
			
			addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		protected function buildExtraObjects():void
		{
			//abstract method
		}
		protected function buildParticleSystem():void
		{
			//abstract method
		}
		protected function mainLoop(e:Event):void
		{
			//abstract method
		}
		
		private function init(e:Event):void
		{
			//set stage scale mode
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//set root scroll rect
			root.scrollRect = new Rectangle(0, 0, 640, 480);
		}
	}
}