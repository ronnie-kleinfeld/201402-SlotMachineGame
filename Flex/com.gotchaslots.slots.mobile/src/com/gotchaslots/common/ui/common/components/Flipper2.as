package com.gotchaslots.common.ui.common.components
{
	import com.gotchaslots.common.utils.ex.TimerEx;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class Flipper2 extends SpriteEx
	{
		// members
		private var _timer:TimerEx;
		private var _limit:int;
		
		// class
		public function Flipper2(interval:int, limit:int, pngs:Vector.<Bitmap>)
		{
			super();
			
			_limit = limit;
			
			_timer = new TimerEx(interval, limit);
			_timer.delay = interval;
			_timer.addEventListener(TimerEvent.TIMER, OnTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
			
			if (pngs && pngs.length > 0)
			{
				pngs[0].visible = true;
				addChild(pngs[0]);
				
				pngs[1].visible = false;
				addChild(pngs[1]);
			}
		}
		public override function Dispose():void
		{
			if (_timer)
			{
				_timer.Dispose();
				_timer = null;
			}
			
			super.Dispose();
		}
		
		// methods
		public function Start():void
		{
			_timer.reset();
			_timer.start();
		}
		public function Stop():void
		{
			_timer.stop();
		}
		
		// events
		private function OnTimer(event:Event):void
		{
			if (_timer.currentCount / numChildren == int(_timer.currentCount / numChildren))
			{
				getChildAt(0).visible = true;
				getChildAt(1).visible = false;
			}
			else
			{
				getChildAt(0).visible = false;
				getChildAt(1).visible = true;
			}
		}
		protected function OnTimerComplete(event:Event):void
		{
			_timer.stop();
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}