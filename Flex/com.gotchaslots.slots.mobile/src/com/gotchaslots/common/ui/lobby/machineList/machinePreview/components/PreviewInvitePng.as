package com.gotchaslots.common.ui.lobby.machineList.machinePreview.components
{
	import com.gotchaslots.common.assets.machinesList.MachinesListEmbed;
	import com.gotchaslots.common.data.machine.CommonMachineDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	
	import flash.events.Event;
	
	public class PreviewInvitePng extends BasePng
	{
		// members
		private var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		// class
		public function PreviewInvitePng(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			super(60, 60, new MachinesListEmbed.FacebookInvite());
			
			_lobbyMachine = lobbyMachine;
			
			visible = !_lobbyMachine.IsOpen && !_lobbyMachine.IsCommingSoon;
			_lobbyMachine.addEventListener(CommonMachineDataEvent.IsOpenChanged, OnIsOpenChanged);
		}
		public override function Dispose():void
		{
			_lobbyMachine.removeEventListener(CommonMachineDataEvent.IsOpenChanged, OnIsOpenChanged);
			
			super.Dispose();
		}
		
		// events
		protected function OnIsOpenChanged(event:Event):void
		{
			visible = !_lobbyMachine.IsOpen && !_lobbyMachine.IsCommingSoon;
		}
	}
}