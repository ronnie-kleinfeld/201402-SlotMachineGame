package com.gotchaslots.common.ui.notifications.popup.base
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.MainEvent;
	import com.gotchaslots.slots.data.machine.SlotsMachineData;
	
	import flash.events.Event;
	
	public class BaseMachinePopup extends BasePopup
	{
		// members
		protected var _machine:SlotsMachineData;
		
		// class
		public function BaseMachinePopup(onClose:Function)
		{
			super(onClose);
			
			_machine = Main.Instance.ActiveMachine;
			
			Main.Instance.addEventListener(MainEvent.RemoveActiveMachineView, OnRemoveActiveMachineView);
		}
		public override function Dispose():void
		{
			Main.Instance.removeEventListener(MainEvent.RemoveActiveMachineView, OnRemoveActiveMachineView);
			
			super.Dispose();
		}
		
		// events
		protected function OnRemoveActiveMachineView(event:Event):void
		{
			DoRemove();
		}
	}
}