package com.gotchaslots.slots.data.machine.paylines.payline
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	
	import flash.utils.Dictionary;
	
	public class Payline5Data extends BasePaylineData
	{
		// properties
		public override function get ColumnsCount():int
		{
			return 5;
		}
		
		// class
		public function Payline5Data(id:int, paylinePngClass:Class, payboxPngClass:Class, color:int, payboxes:Vector.<PayboxData>, paybox0:int, paybox1:int, paybox2:int, paybox3:int, paybox4:int)
		{
			super(id, paylinePngClass, payboxPngClass, color, payboxes);
			
			_payboxes = new Vector.<PayboxData>();
			_payboxes.push(payboxes[paybox0]);
			_payboxes.push(payboxes[paybox1]);
			_payboxes.push(payboxes[paybox2]);
			_payboxes.push(payboxes[paybox3]);
			_payboxes.push(payboxes[paybox4]);
		}
		
		// methods
		public override function CenterSymbol(resultMatrix:Dictionary):BaseSymbolData
		{
			return Main.Instance.ActiveMachine.LobbyMachine.Symbols.Symbols[resultMatrix[_payboxes[2].ID]];
		}
		public override function IsSymetricValuable(resultMatrix:Dictionary):Boolean
		{
			return resultMatrix[_payboxes[0].ID] == resultMatrix[_payboxes[4].ID] && resultMatrix[_payboxes[1].ID] == resultMatrix[_payboxes[3].ID];
		}
	}
}