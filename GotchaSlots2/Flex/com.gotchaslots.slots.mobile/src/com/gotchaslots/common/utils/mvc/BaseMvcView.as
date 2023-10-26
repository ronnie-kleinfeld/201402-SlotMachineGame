package com.gotchaslots.common.utils.mvc
{
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	import flash.events.Event;
	
	public class BaseMvcView extends SpriteEx
	{
		// members
		protected var _controller:BaseMvcController;
		
		// properties
		public function get Controller():BaseMvcController
		{
			return _controller;
		}
		
		// class
		public function BaseMvcView(controller:BaseMvcController)
		{
			super();
			
			_controller = controller;
			
			addEventListener(Event.COMPLETE, OnComplete);
		}
		public function Init():void
		{
		}
		
		// events
		protected function OnComplete(event:Event):void
		{
			Init();
		}
	}
}