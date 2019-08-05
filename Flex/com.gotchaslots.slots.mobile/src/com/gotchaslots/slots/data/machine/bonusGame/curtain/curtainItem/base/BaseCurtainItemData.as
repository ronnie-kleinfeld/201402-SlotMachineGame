package com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.base
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.dataType.BaseIDData;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class BaseCurtainItemData extends BaseIDData
	{
		// members
		private var _startRect:Rectangle;
		
		private var _mcClass:Class;
		private var _mc:MovieClip;
		
		private var _clickSound:String;
		private var _winSound:String;
		private var _loseSound:String;
		
		private var _payout:Number;
		private var _isFailure:Boolean;
		private var _selected:Boolean;
		
		// properties
		public function get ItemBoxClass():Class
		{
			throw new MustOverrideError();
		}
		
		public function get StartRectangle():Rectangle
		{
			return _startRect;
		}
		
		public function get GetMC():MovieClip
		{
			if (!_mc)
			{
				_mc = new _mcClass();
			}
			return _mc;
		}
		
		public function get ClickSound():String
		{
			return _clickSound;
		}
		public function get WinSound():String
		{
			return _winSound;
		}
		public function get LoseSound():String
		{
			return _loseSound;
		}
		
		public function get Payout():Number
		{
			return _payout;
		}
		public function get IsFailure():Boolean
		{
			return _isFailure;
		}
		
		public function get Selected():Boolean
		{
			return _selected;
		}
		public function set Selected(value:Boolean):void
		{
			_selected = value;
		}
		
		// class
		public function BaseCurtainItemData(id:int, startRect:Rectangle, mcClass:Class, clickSound:String, winSound:String, loseSound:String)
		{
			super(id);
			
			_startRect = startRect;
			
			_mcClass = mcClass;
			
			_clickSound = clickSound;
			_winSound = winSound;
			_loseSound = loseSound;
			
			_payout = Math.ceil(Math.random() * 9);
			_isFailure = Main.Instance.Device.IsMobile ? Math.random() < 0.3 : false;
		}
	}
}