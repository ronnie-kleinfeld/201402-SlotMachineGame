package com.gotchaslots.common.ui.machine
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.gotchaslots.common.utils.mvc.BaseMvcController;
	import com.gotchaslots.slots.data.machine.SlotsMachineData;
	import com.gotchaslots.slots.ui.machine.SlotsMachineView;
	
	import flash.events.TimerEvent;

	public class CommonMachineController extends BaseMvcController
	{
		// members
		protected var _active:Boolean;
		protected var _activeMachine:SlotsMachineData;
		
		// class
		public function CommonMachineController()
		{
			super();
			
			_active = true;
			_activeMachine = Main.Instance.ActiveMachine;
		}
		
		public override function CreateView():void
		{
			_view = new SlotsMachineView(this);
		}
		public override function Init():void
		{
			super.Init();
			
			Main.Instance.XServices.GoogleAnalytics.TrackMachineView(_activeMachine.LobbyMachine.ID);
		}
		protected function OnPauseTimer(event:TimerEvent):void
		{
			var pauseTimer:TimerEx = TimerEx(event.currentTarget);
			if (pauseTimer)
			{
				pauseTimer.Dispose();
				pauseTimer = null;
			}
			
			DoSpin(false);
		}
		
		// methods
		public function Deactivate():void
		{
			_active = false;
		}
		
		public function DoSpin(hasSetToMaxTotalBet:Boolean):void
		{
			throw new MustOverrideError();
		}
	}
}