package com.gotchaslots.common.ui.common.components
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class SpriteEx extends Sprite
	{
		// members
		private var _initMS:Number;
		private var _listeners:Dictionary;
		
		// properties
		public function get MSSpent():Number
		{
			return Main.Instance.XServices.InternetTime.CurrentLocalMS - _initMS;
		}
		
		// class
		public function SpriteEx()
		{
			super();
			
			try
			{
				_initMS = Main.Instance.XServices.InternetTime.CurrentLocalMS;
			}
			catch (error:Error)
			{
				_initMS = getTimer();
			}
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