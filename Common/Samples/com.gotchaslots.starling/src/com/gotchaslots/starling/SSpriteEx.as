package com.gotchaslots.starling
{
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	
	public class SSpriteEx extends Sprite
	{
		// members
		private var _listeners:Dictionary;
		
		// class
		public function SSpriteEx()
		{
			super();
			
			_listeners = new Dictionary();
		}
		public function Dispose():void
		{
			removeChildren();
			DisposeListeners();
			super.dispose();
		}
		private function DisposeListeners(): void
		{
			try
			{
				for (var key:Object in _listeners)
				{
					removeEventListener(key.type, _listeners[key]);
					_listeners[key] = null;
				}
			}
			catch (error:Error)
			{
			}
		}
		
		// events
		public override function addEventListener(type:String, listener:Function):void
		{
			var key:Object = new Object();
			key.useCapture = type;
			
			if (_listeners[key])
			{
				removeEventListener(type, _listeners[key]);
				_listeners[key] = null;
			}
			_listeners[key] = listener;
			
			super.addEventListener(type, listener);
		}
	}
}