package com.gotchaslots.slots.data.machine.valuator.base
{
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.common.utils.dataType.Location;
	
	public class BaseValuatorData extends BaseValuatorsData
	{
		// members
		protected var _payboxes:Vector.<PayboxData>;
		
		// properteis
		public function get Payboxes():Vector.<PayboxData>
		{
			return _payboxes;
		}
		public function get CenterLocations():Vector.<Location>
		{
			var result:Vector.<Location> = new Vector.<Location>();
			
			for (var j:int = 0; j < Payboxes.length; j++)
			{
				var location:Location = new Location(Payboxes[j].Center.x, Payboxes[j].Center.y + 48);
				result.push(location);
			}
			
			return result;
		}
		
		// class
		public function BaseValuatorData()
		{
			super();
			
			_payboxes = new Vector.<PayboxData>();
		}
	}
}