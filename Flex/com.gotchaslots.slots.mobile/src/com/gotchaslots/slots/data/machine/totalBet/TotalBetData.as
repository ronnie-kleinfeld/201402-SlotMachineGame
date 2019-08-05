package com.gotchaslots.slots.data.machine.totalBet
{
	public class TotalBetData
	{
		// members
		private var _paylines:int;
		private var _betIndex:int;
		private var _totalBet:Number;
		
		// properties
		public function get Paylines():int
		{
			return _paylines;
		}
		public function get BetIndex():int
		{
			return _betIndex;
		}
		public function get TotalBet():Number
		{
			return _totalBet;
		}
		
		// class
		public function TotalBetData(paylines:int, betIndex:int, totalBet:Number)
		{
			_paylines = paylines;
			_betIndex = betIndex;
			_totalBet = totalBet;
		}
	}
}