package com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoNormalSymbols
{
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.common.ui.common.components.freeActionScript.scrollable.BaseVScrollbar;
	
	public class MachineInfoNormalSymbols extends BaseVScrollbar
	{
		// members
		private var _lobbyMachine:SlotsBaseLobbyMachineData;
		private var _symbols:SymbolsData;
		
		// properties
		protected override function get Content():BaseComponent
		{
			var content:BaseComponent = new BaseComponent(421, 100 * _symbols.NormalSymbols.length);
			
			var i:int;
			var symbol:BaseSymbolData;
			var currentY:int;
			for (i = 0; i < _symbols.NormalSymbols.length; i++)
			{
				symbol = _symbols.NormalSymbols[i];
				
				var machineInfoNormalSymbol:MachineInfoNormalSymbol = new MachineInfoNormalSymbol(_lobbyMachine, symbol);
				machineInfoNormalSymbol.y = currentY;
				currentY += machineInfoNormalSymbol.height + 2;
				
				content.addChild(machineInfoNormalSymbol);
			}
			
			return content;
		}
		
		// class
		public function MachineInfoNormalSymbols(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			_lobbyMachine = lobbyMachine;
			_symbols = lobbyMachine.Symbols
			
			super(421, 260);
		}
	}
}