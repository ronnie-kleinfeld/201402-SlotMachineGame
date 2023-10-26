package com.gotchaslots.slots.data.machine.valuator.base
{
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	
	public class BasePaylineValuatorData extends BaseValuatorData
	{
		// members
		protected var _payline:BasePaylineData;										
		
		// properteis
		public function get Payline():BasePaylineData
		{
			return _payline;
		}
		
		// class
		public function BasePaylineValuatorData()
		{
			super();
		}
	}
}