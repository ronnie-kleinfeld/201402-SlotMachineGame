package com.gotchaslots.common.ui.common.components.stardust.base
{
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.events.Event;
	
	import idv.cjcat.stardust.common.emitters.Emitter;
	
	public class BaseStardust extends BaseComponent
	{
		protected var container:SpriteEx;
		protected var emitter:Emitter;
		
		public function BaseStardust()
		{
			super(100, 100);
			
			container = new SpriteEx();
			addChild(container);
			
			buildExtraObjects();
			buildParticleSystem();
			
			addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		public override function Dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, mainLoop);

			super.Dispose();
			
			if (emitter)
			{
				emitter.Dispose();
				emitter = null;
			}
			
			if (container)
			{
				DisplayObjectHelper.SafeRemoveAllChildrens(container);
				container = null;
			}
		}
		
		protected function buildExtraObjects():void
		{
			//abstract method
		}
		protected function buildParticleSystem():void
		{
			//abstract method
		}
		protected function mainLoop(event:Event):void
		{
			//abstract method
		}
	}
}