package com.gotchaslots.slots.ui.lobby.machinesList.machinePreview.components
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.data.session.machines.SlotsMachineSessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.common.ui.common.components.gradientBG.RadialGradientBG;
	
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.text.TextField;
	
	public class BonusGamePendingTextField extends BaseTextField
	{
		// members
		protected var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		// properties
		protected override function get BGFilters():Array
		{
			return [new BevelFilter(3, 45, 0xffffff, 1, 0)];
		}
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.LobbyMachinePreviewBonusGame;
		}
		
		// class
		public function BonusGamePendingTextField(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			_lobbyMachine = lobbyMachine;
			
			addChild(new RadialGradientBG(150, 50, 15, 0x00adf9, 0x53f0fb));
			
			super(120, 25, "Bonus Game");
			
			visible = _lobbyMachine.MachineSession.FreeSpinsPendingCount == 0 && _lobbyMachine.IsOpen && _lobbyMachine.MachineSession.IsBonusGamePending;
			
			_lobbyMachine.MachineSession.addEventListener(SlotsMachineSessionDataEvent.BonusGameChanged, OnBonusGameChanged);
		}
		public override function Dispose():void
		{
			_lobbyMachine.MachineSession.removeEventListener(SlotsMachineSessionDataEvent.BonusGameChanged, OnBonusGameChanged);
			
			super.Dispose();
		}
		
		// events
		protected function OnBonusGameChanged(event:Event):void
		{
			visible = _lobbyMachine.MachineSession.FreeSpinsPendingCount == 0 && _lobbyMachine.IsOpen && _lobbyMachine.MachineSession.IsBonusGamePending;
		}
	}
}