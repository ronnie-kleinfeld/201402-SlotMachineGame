package com.gotchaslots.slots.ui.machine.presentation
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.spline.SplinesData;
	import com.gotchaslots.common.ui.common.components.stardust.moneyTrail.MoneyTrail;
	import com.gotchaslots.slots.ui.machine.SlotsMachineView;
	import com.gotchaslots.slots.ui.machine.presentation.base.BasePresentation;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class WinToBalancePresentation extends BasePresentation
	{
		// properties
		protected override function get IsValuable():Boolean
		{
			return !_valuatorsHandler.IsValuable;
		}
		protected override function get Payout():Number
		{
			return _valuatorsHandler.Payout;
		}
		
		// class
		public function WinToBalancePresentation(onClick:Function, onClose:Function, view:SlotsMachineView)
		{
			super(306, onClick, onClose, view);
		}
		
		// money trail
		protected override function DoMoneyTrails():void
		{
			var point:Point = new Point(Math.random() * 200 + 100, Math.random() * 153 + 76.5);
			
			var moneyTrail:MoneyTrail = new MoneyTrail(1, SplinesData.WinPoint, point, SplinesData.BalancePoint);
			moneyTrail.y = 48;
			moneyTrail.addEventListener(Event.COMPLETE, OnMoneyTrailsComplete);
			addChild(moneyTrail);
		}
		private function OnMoneyTrailsComplete(event:Event):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Machine_Sequence_WinToBalance);
			
			var moneyTrail:MoneyTrail = MoneyTrail(event.currentTarget);
			moneyTrail.removeEventListener(Event.COMPLETE, OnMoneyTrailsComplete);
			DoPostMoneyTrails();
		}
		
		protected override function DoPost():void
		{
			if (_valuatorsHandler)
			{
				Main.Instance.Session.Wallet.WinToBalance(_valuatorsHandler.Chips);
			}
			DoRemove();
		}
	}
}