package com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo
{
	import com.gotchaslots.common.ui.notifications.popup.machine.machineInfo.CommonMachineInfoPopup;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoInformation.MachineInfoInformation;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoInformation.MachineInfoInformationEvent;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoNormalSymbols.MachineInfoNormalSymbols;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoPaylines.MachineInfoPaylines;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoSpecialSymbols.MachineInfoSpecialSymbols;
	
	import flash.events.Event;
	
	public class SlotsMachineInfoPopup extends CommonMachineInfoPopup
	{
		// properties
		public override function set MachineInfoPage(value:int):void
		{
			if (_machineInfoPage != value)
			{
				_machineInfoPage = value;
				
				switch (_machineInfoPage)
				{
					case MachineInfoPageEnum.Information:
						_back.visible = false;
						_next.visible = true;
						Slide(_lobbyMachine.MachineName);
						break;
					case MachineInfoPageEnum.NormalSymbols:
						_back.visible = true;
						_next.visible = true;
						Slide("Pay Table - Symbols");
						break;
					case MachineInfoPageEnum.SpecialSymbols:
						_back.visible = true;
						_next.visible = true;
						Slide(FormatterHelper.NumberToMoney(_lobbyMachine.Symbols.SpecialSymbols.length, 0, 0) + " Special Symbols");
						break;
					case MachineInfoPageEnum.Paylines:
						_back.visible = true;
						_next.visible = false;
						Slide(FormatterHelper.NumberToMoney(_lobbyMachine.Paylines.Paylines.length, 0, 0) + " Paylines");
						break;
					default:
						MachineInfoPage = MachineInfoPageEnum.Information;
						break;
				}
			}
		}
		
		// class
		public function SlotsMachineInfoPopup(machineInfoPage:int, lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function)
		{
			super(machineInfoPage, lobbyMachine, onClose);
		}
		protected override function InitStrip():void
		{
			super.InitStrip();
			
			var machineInfoInformation:MachineInfoInformation = new MachineInfoInformation(_lobbyMachine);
			machineInfoInformation.x = _strip.numChildren * 421;
			machineInfoInformation.addEventListener(MachineInfoInformationEvent.NormalSymbolsClicked, onNormalSymbolsClicked);
			machineInfoInformation.addEventListener(MachineInfoInformationEvent.SpecialSymbolsClicked, onSpecialSymbolsClicked);
			machineInfoInformation.addEventListener(MachineInfoInformationEvent.MaxPaylinesClicked, onMaxPaylinesClicked);
			_strip.addChild(machineInfoInformation);
			
			var machineInfoNormalSymbols:MachineInfoNormalSymbols = new MachineInfoNormalSymbols(_lobbyMachine);
			machineInfoNormalSymbols.x = _strip.numChildren * 421;
			_strip.addChild(machineInfoNormalSymbols);
			
			var machineInfoSpecialSymbols:MachineInfoSpecialSymbols = new MachineInfoSpecialSymbols(_lobbyMachine);
			machineInfoSpecialSymbols.x = _strip.numChildren * 421;
			_strip.addChild(machineInfoSpecialSymbols);
			
			var machineInfoPaylines:MachineInfoPaylines = new MachineInfoPaylines(_lobbyMachine);
			machineInfoPaylines.x = _strip.numChildren * 421;
			_strip.addChild(machineInfoPaylines);
		}
		
		// events
		protected function onNormalSymbolsClicked(event:Event):void
		{
			MachineInfoPage = MachineInfoPageEnum.NormalSymbols;
		}
		protected function onSpecialSymbolsClicked(event:Event):void
		{
			MachineInfoPage = MachineInfoPageEnum.SpecialSymbols;
		}
		protected function onMaxPaylinesClicked(event:Event):void
		{
			MachineInfoPage = MachineInfoPageEnum.Paylines;
		}
	}
}