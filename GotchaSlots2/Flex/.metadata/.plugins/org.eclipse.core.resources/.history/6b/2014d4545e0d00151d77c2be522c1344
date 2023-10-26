package com.gotchaslots.common.ui.common.components
{
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class MovieClipEx extends MovieClip
	{
		// members
		private var _listeners:Dictionary;
		
		// class
		public function MovieClipEx()
		{
			super();
			
			_listeners = new Dictionary();
		}
		public function Dispose():void
		{
			visible = false;
			filters = null;
			graphics.clear();
			
			DisplayObjectHelper.SafeDisposeAllChildrens(this);
			
			DisposeListeners();
		}
		private function DisposeListeners(): void
		{
			try
			{
				for (var key:Object in _listeners)
				{
					removeEventListener(key.type, _listeners[key], key.useCapture);
					_listeners[key] = null;
				}
				_listeners = new Dictionary();
			}
			catch (error:Error)
			{
			}
		}
		
		// events
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void
		{
			var key:Object = new Object();
			key.type = useCapture;
			key.useCapture = type;
			
			if (_listeners[key])
			{
				removeEventListener(type, _listeners[key], useCapture);
				_listeners[key] = null;
			}
			_listeners[key] = listener;
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}