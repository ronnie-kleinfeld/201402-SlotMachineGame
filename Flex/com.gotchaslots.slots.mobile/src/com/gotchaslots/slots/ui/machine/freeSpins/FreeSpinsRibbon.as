package com.gotchaslots.slots.ui.machine.freeSpins
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.session.machines.SlotsMachineSessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.text.TextField;
	
	public class FreeSpinsRibbon extends BaseTextField
	{
		// properties
		protected override function get BGFilters():Array
		{
			return [new BevelFilter(3, 45, 0xffffff, 1, 0)];
		}
		protected override function get FrameCorner():Number
		{
			return 30;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineFreeSpinsRibbon;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 60;
		}
		
		// class
		public function FreeSpinsRibbon()
		{
			super(270, 30, " ", null, 0x8330ba);
			
			Main.Instance.ActiveMachine.LobbyMachine.MachineSession.addEventListener(SlotsMachineSessionDataEvent.FreeSpinsSpinStarted, OnFreeSpinsSpinStarted);
			Main.Instance.ActiveMachine.LobbyMachine.MachineSession.addEventListener(SlotsMachineSessionDataEvent.FreeSpinsCollectCount, OnFreeSpinsCollectCount);
			Main.Instance.ActiveMachine.LobbyMachine.MachineSession.addEventListener(SlotsMachineSessionDataEvent.FreeSpinsEndPopupClosed, OnFreeSpinsEndPopupClosed);
			
			addEventListener(MouseEvent.CLICK, OnClick);
			
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount == 0)
			{
				TweenLite.to(this, 1, {x:-245, delay:0.3, ease:Elastic.easeOut});
			}
			else
			{
				TweenLite.to(this, 1, {x:-11, delay:0.3, ease:Quart.easeOut});
			}
			Update(Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount);
		}
		public override function Dispose():void
		{
			Main.Instance.ActiveMachine.LobbyMachine.MachineSession.removeEventListener(SlotsMachineSessionDataEvent.FreeSpinsSpinStarted, OnFreeSpinsSpinStarted);
			Main.Instance.ActiveMachine.LobbyMachine.MachineSession.removeEventListener(SlotsMachineSessionDataEvent.FreeSpinsCollectCount, OnFreeSpinsCollectCount);
			Main.Instance.ActiveMachine.LobbyMachine.MachineSession.removeEventListener(SlotsMachineSessionDataEvent.FreeSpinsEndPopupClosed, OnFreeSpinsEndPopupClosed);
			TweenLite.killTweensOf(this);
			
			super.Dispose();
		}
		
		// methods
		private function Update(diffCount:int):void
		{
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount > 0)
			{
				Text = "Free Spins: " + Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount.toString();
			}
			else
			{
				Text = "Free Spins: 0";
			}
			
			if (diffCount != 0)
			{
				var bubblingFreeSpins:BubblingFreeSpinsTextField = new BubblingFreeSpinsTextField();
				bubblingFreeSpins.x = 220;
				bubblingFreeSpins.y = 362;
				bubblingFreeSpins.Text = (diffCount >= 0 ? "+" : "") + diffCount;
				if (parent)
				{
					parent.addChild(bubblingFreeSpins);
				}
				bubblingFreeSpins.Bubble(Number.NaN, 70);
			}
		}
		
		// events
		private function OnClick(event:Event):void
		{
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount == 0 && x == -245)
			{
				TweenLite.to(this, 1, {x:-11, ease:Quart.easeOut, onComplete:onClickedComplete});
			}
		}
		private function onClickedComplete():void
		{
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount == 0)
			{
				TweenLite.to(this, 1, {x:-245, delay:1, ease:Quad.easeInOut});
			}
		}
		
		protected function OnFreeSpinsSpinStarted(event:SlotsMachineSessionDataEvent):void
		{
			Update(event.FreeSpinsDiffCount);
		}
		protected function OnFreeSpinsCollectCount(event:SlotsMachineSessionDataEvent):void
		{
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount > 0)
			{
				TweenLite.to(this, 1, {x:-11, ease:Quart.easeOut});
			}
			Update(event.FreeSpinsDiffCount);
		}
		protected function OnFreeSpinsEndPopupClosed(event:Event):void
		{
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsPendingCount == 0)
			{
				TweenLite.to(this, 1, {x:-245, ease:Quad.easeInOut});
			}
			Update(0);
		}
	}
}