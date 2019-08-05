package com.gotchaslots.slots.data.machine.resultMatrix
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.MainEvent;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	
	import flash.events.Event;
	
	public class ResultMatrixPool
	{
		// consts
		private const POOL_SIZE:int = 15;
		
		// members
		private var _maxPaylines:int;
		private var _paylines:BasePaylinesData;
		private var _symbols:SymbolsData;
		private var _poolSize:int;
		private var _pool:Vector.<BaseResultMatirxData>;
		private var _isFilling:Boolean;
		
		// properties
		public function get Length():int
		{
			return _pool.length;
		}
		
		// class
		public function ResultMatrixPool(maxPaylines:int, paylines:BasePaylinesData, symbols:SymbolsData)
		{
			_maxPaylines = maxPaylines;
			_paylines = paylines;
			_symbols = symbols;
			_poolSize = POOL_SIZE;
			_pool = new Vector.<BaseResultMatirxData>();
			_isFilling = false;
		}
		public function Init():void
		{
			Fill();
			Main.Instance.addEventListener(MainEvent.Timer, OnTimer);
		}
		public function Dispose():void
		{
			Main.Instance.removeEventListener(MainEvent.Timer, OnTimer);
			
			while (_pool && _pool.length > 0)
			{
				var resultMatrix:BaseResultMatirxData = _pool.pop();
				resultMatrix.Dispose();
				resultMatrix = null;
			}
			_pool = null;
		}
		
		// methods
		public function GetResultMatrix(selectedPaylines:int, selectedBetChips:Number):BaseResultMatirxData
		{
			if (_pool.length == 0)
			{
				_poolSize++;
				Fill();
			}
			
			var baseResultMatirx:BaseResultMatirxData = _pool.pop();
			baseResultMatirx.CalculatePayout(selectedPaylines, selectedBetChips);
			return baseResultMatirx;
		}
		private function Fill():void
		{
			try
			{
				if (!_isFilling)
				{
					_isFilling = true;
					
					while (_pool.length <= _poolSize)
					{
						_pool.push(new _paylines.ResultMatrixClass(_maxPaylines, _symbols, _paylines));
					}
					
					_isFilling = false;
				}
			}
			catch (error:Error)
			{
				throw new Error("Pool" + error.toString());
				_isFilling = false;
			}
		}
		
		// events
		private function OnTimer(event:Event):void
		{
			Fill();
		}
	}
}