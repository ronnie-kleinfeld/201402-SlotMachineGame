package com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoSpecialSymbols
{
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.common.ui.common.components.freeActionScript.scrollable.BaseVScrollbar;
	
	public class MachineInfoSpecialSymbols extends BaseVScrollbar
	{
		// members
		private var _lobbyMachine:SlotsBaseLobbyMachineData;
		private var _symbols:SymbolsData;
		
		// properties
		protected override function get Content():BaseComponent
		{
			var content:BaseComponent = new BaseComponent(421, 100 * _symbols.SpecialSymbols.length);
			
			var i:int;
			var symbol:BaseSymbolData;
			var currentY:int;
			
			for (i = 0; i < _symbols.SpecialSymbols.length; i++)
			{
				symbol = _symbols.SpecialSymbols[i];
				
				var machineInfoSpecialSymbol:MachineInfoSpecialSymbol = new MachineInfoSpecialSymbol(_lobbyMachine, symbol);
				machineInfoSpecialSymbol.y = currentY;
				currentY += machineInfoSpecialSymbol.height + 2;
				
				content.addChild(machineInfoSpecialSymbol);
			}
			
			return content;
		}
		
		// class
		public function MachineInfoSpecialSymbols(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			_lobbyMachine = lobbyMachine;
			_symbols = lobbyMachine.Symbols;
			
			super(421, 260);
		}
	}
}