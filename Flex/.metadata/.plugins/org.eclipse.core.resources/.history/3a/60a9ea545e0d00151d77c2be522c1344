package com.gotchaslots.common.ui.lobby.machineList.machinePreview.components
{
	import com.gotchaslots.common.assets.machinesList.MachinesListEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.machine.CommonMachineDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.common.ui.common.components.gradientBG.RadialGradientBG;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class PreviewLockedPng extends BaseTextField
	{
		// members
		private var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.LobbyMachinePreviewLocked;
		}
		protected override function get TextFieldOffsetX():int
		{
			return 12;
		}
		
		// class
		public function PreviewLockedPng(lobbyMachine:SlotsBaseLobbyMachineData)
		{
			_lobbyMachine = lobbyMachine;
			
			addChild(new RadialGradientBG(150, 50, 15, 0x53f0fb, 0x00adf9));
			
			super(120, 50, "Opens on\nLevel " + FormatterHelper.NumberToMoney(_lobbyMachine.OpensOnLevel.LevelNumber, 0, 0));
			
			var locker:Bitmap = new MachinesListEmbed.Locked();
			locker.x = 0;
			locker.y = 5;
			addChild(locker);
			
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