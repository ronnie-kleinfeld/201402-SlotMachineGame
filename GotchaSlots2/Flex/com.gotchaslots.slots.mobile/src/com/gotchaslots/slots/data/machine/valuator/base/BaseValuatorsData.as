package com.gotchaslots.slots.data.machine.valuator.base
{
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.common.utils.dataType.BaseIDData;
	
	public class BaseValuatorsData extends BaseIDData
	{
		// members
		protected var _isValuable:Boolean;
		private var _payout:Number;
		private var _chips:Number;
		
		// properteis
		public function get IsValuable():Boolean
		{
			return _isValuable;
		}
		
		public function get Payout():Number
		{
			return _payout;
		}
		public function set Payout(value:Number):void
		{
			if (_payout != value)
			{
				_payout = value;
				_isValuable = _payout > 0;
			}
		}
		
		public function get Chips():Number
		{
			return _chips;
		}
		public function set Chips(value:Number):void
		{
			_chips = value;
		}
		
		// class
		public function BaseValuatorsData()
		{
			super(-1);
			
			_isValuable = false;
			Payout = 0;
			Chips = 0;
		}
		
		// methods
		public function Evaluate(resultMatrix:BaseResultMatirxData):void
		{
			// might be implemented in inheriting class
		}
		public function CalculatePaylinesPayout(selectedPaylines:int, selectedBetChips:Number):void
		{
			// might be implemented in inheriting class
		}
	}
}