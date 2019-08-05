package com.gotchaslots.common.ui.lobby.machineList.machinePreview.components
{
	import com.gotchaslots.common.assets.machinesList.MachinesListEmbed;
	import com.gotchaslots.common.data.session.machines.CommonMachineSessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	
	import flash.events.Event;
	
	public class NewPreviewPng extends BasePng
	{
		// members
		protected var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		// class
		public function NewPreviewPng(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			super(85, 75, new MachinesListEmbed.NewPreview());
			
			_lobbyMachine = lobbyMachine;
			
			visible = !_lobbyMachine.IsCommingSoon && _lobbyMachine.MachineSession.NewMachine && _lobbyMachine.IsOpen;
			
			_lobbyMachine.MachineSession.addEventListener(CommonMachineSessionDataEvent.NewMachineChanged, OnNewMachineChanged);
		}
		public override function Dispose():void
		{
			_lobbyMachine.MachineSession.removeEventListener(CommonMachineSessionDataEvent.NewMachineChanged, OnNewMachineChanged);
			
			super.Dispose();
		}
		
		// events
		protected function OnNewMachineChanged(event:Event):void
		{
			visible = !_lobbyMachine.IsCommingSoon && _lobbyMachine.MachineSession.NewMachine && _lobbyMachine.IsOpen;
		}
	}
}