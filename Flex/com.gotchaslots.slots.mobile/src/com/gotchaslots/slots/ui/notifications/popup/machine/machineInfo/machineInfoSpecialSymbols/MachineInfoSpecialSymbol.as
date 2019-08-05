package com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoSpecialSymbols
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	import com.gotchaslots.slots.ui.machine.Symbol;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoSpecialSymbols.textFields.MachineInfoSpecialSymbolDescriptionTextField;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class MachineInfoSpecialSymbol extends BaseBG
	{
		// properties
		protected override function get HasFrame():Boolean
		{
			return false;
		}
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		// class
		public function MachineInfoSpecialSymbol(lobbyMachine:SlotsBaseLobbyMachineData, symbol:BaseSymbolData)
		{
			super(383, 130, 0xffa8cb);
			
			var png:Symbol = symbol.GetSymbol(lobbyMachine.Paylines.Payboxes[0].Rect);
			png.x = 8;
			png.y = 8;
			png.width = 100;
			png.height = 100;
			addChild(png);
			
			if (symbol.Description != "")
			{
				var description:MachineInfoSpecialSymbolDescriptionTextField = new MachineInfoSpecialSymbolDescriptionTextField(275, 30, symbol.Description);
				description.x = 108;
				description.y = 3;
				addChild(description);
			}
			
			if (symbol.Note != "")
			{
				var textField:TextField = Main.Instance.TextFields.MachineInfoSpecialSymbolPayout;
				textField.x = 108;
				textField.y = 35;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.width = 275;
				textField.height = 72;
				textField.text = symbol.Note;
				addChild(textField);
			}
		}
	}
}