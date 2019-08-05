package com.gotchaslots.common.data.session.base
{
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	public class BaseIOData extends EventDispatcherEx
	{
		// members
		protected var _initialized:Boolean;
		
		// properteis
		protected function get Key():String
		{
			throw new MustOverrideError();
		}
		
		// class
		public function BaseIOData()
		{
			super();
		}
		protected function Init():void
		{
			throw new MustOverrideError();
		}
		
		// io
		public function Load():void
		{
			try
			{
				var storedValue:ByteArray = EncryptedLocalStore.getItem(Key);
				if (storedValue)
				{
					Deserialize(storedValue.readObject());
				}
				else
				{
					Init();
					Save();
				}
			}
			catch (error:Error)
			{
				Init();
			}
		}
		public function Save():void
		{
			if (_initialized)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(Serialize());
				EncryptedLocalStore.setItem(Key, bytes);
			}
		}
		
		// serialize
		public function Deserialize(object:Object):void
		{
			throw new MustOverrideError();
		}
		public function Serialize():Object
		{
			throw new MustOverrideError();
		}
	}
}