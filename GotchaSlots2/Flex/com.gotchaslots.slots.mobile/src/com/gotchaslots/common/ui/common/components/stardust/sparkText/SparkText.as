package com.gotchaslots.common.ui.common.components.stardust.sparkText
{
	import com.gotchaslots.slots.assets.notifications.animation.sparkTextAnimation.SparkTextAnimationHandler;
	import com.gotchaslots.common.ui.common.components.stardust.base.BaseStardust;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.twoD.handlers.DisplayObjectHandler;
	
	public class SparkText extends BaseStardust
	{
		// members
		private var _sparkMask:Sprite = new SparkTextAnimationHandler._sparkMask();
		private var _text:Sprite;
		
		private var sparkMask:BitmapData;
		
		// class
		public function SparkText(text:Sprite)
		{
			_text = text;
			
			super();
			
			_sparkMask.visible = false;
		}
		
		// methods
		protected override function buildParticleSystem():void
		{
			addChildAt(_text, 0);
			
			var degradationStep:int = 2;
			
			sparkMask = new BitmapData(_text.width / degradationStep, _text.height / degradationStep, true, 0x00000000);
			emitter = new UpdatableBitmapZoneEmitter(new SteadyClock(3), _sparkMask.x, _sparkMask.y, degradationStep, degradationStep);
			emitter.particleHandler = new DisplayObjectHandler(container);
		}
		
		// events
		protected override function mainLoop(event:Event):void
		{
			sparkMask.fillRect(sparkMask.rect, 0x00000000);
			sparkMask.draw(_sparkMask, new Matrix(0.5, 0, 0, 0.5));
			UpdatableBitmapZoneEmitter(emitter).update(sparkMask);
			emitter.step();
		}
	}
}