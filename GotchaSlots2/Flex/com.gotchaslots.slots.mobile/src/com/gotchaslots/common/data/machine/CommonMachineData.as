package com.gotchaslots.common.data.machine
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;

	public class CommonMachineData extends EventDispatcherEx
	{
		// members
		protected var _lobbyMachine:SlotsBaseLobbyMachineData;
		private var _bottomPanelEnabled:Boolean;
		private var _isIdle:Boolean;
		
		private var _startTime:Number;
		
		// properties
		public function get LobbyMachine():SlotsBaseLobbyMachineData
		{
			return _lobbyMachine;
		}
		
		public function get IsIdle():Boolean
		{
			return _isIdle;
		}
		public function set IsIdle(value:Boolean):void
		{
			_isIdle = value;
		}
		
		public function get StartTime():Number
		{
			return _startTime;
		}
		public function set StartTime(value:Number):void
		{
			_startTime = value;
		}
		
		// class
		public function CommonMachineData(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			super();
			
			StartTime = Main.Instance.XServices.InternetTime.CurrentLocalMS;
			
			_lobbyMachine = lobbyMachine;
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			if (_lobbyMachine && _lobbyMachine.Symbols)
			{
				_lobbyMachine.Symbols.Truncate();
			}
		}
	}
}