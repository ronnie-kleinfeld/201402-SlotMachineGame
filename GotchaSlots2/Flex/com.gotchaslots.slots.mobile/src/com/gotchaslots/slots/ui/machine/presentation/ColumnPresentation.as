package com.gotchaslots.slots.ui.machine.presentation
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.spline.SplinesData;
	import com.gotchaslots.slots.data.machine.valuator.column.ColumnValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.column.ColumnValuatorsData;
	import com.gotchaslots.common.ui.common.components.Flipper2;
	import com.gotchaslots.common.ui.common.components.stardust.moneyTrail.MoneyTrail;
	import com.gotchaslots.slots.ui.machine.SlotsMachineView;
	import com.gotchaslots.slots.ui.machine.presentation.base.BasePresentation;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.Event;
	
	public class ColumnPresentation extends BasePresentation
	{
		// properties
		protected override function get ValuatorClass():Class
		{
			return ColumnValuatorsData;
		}
		protected override function get RemoveByTween():Boolean
		{
			return true;
		}
		
		// class
		public function ColumnPresentation(onClick:Function, onClose:Function, view:SlotsMachineView)
		{
			super(306, onClick, onClose, view);
		}
		
		// methods
		protected override function DoFlipper2():void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Machine_Sequence_Column_Flipper2);
			
			var flipper2:Flipper2;
			for (var i:int = 0; i < _valuatorsHandler.Column.ColumnValuators.length; i++)
			{
				flipper2 = new Flipper2(150, 10, Main.Instance.ActiveMachine.LobbyMachine.ColumnFramePngs);
				flipper2.x = -2 + _valuatorsHandler.Column.ColumnValuators[i].Payboxes[0].Rect.x;
				flipper2.y = -2 + _valuatorsHandler.Column.ColumnValuators[i].Payboxes[0].Rect.y + 48;
				if (i == _valuatorsHandler.Column.ColumnValuators.length - 1)
				{
					flipper2.addEventListener(Event.COMPLETE, OnFlipper2Complete);
				}
				
				addChild(flipper2);
				flipper2.Start();
			}
		}
		private function OnFlipper2Complete(event:Event):void
		{
			DoPostFlipper2();
		}
		
		protected override function DoMoneyTrails():void
		{
			var length:int = _valuatorsHandler.Column.ColumnValuators.length;
			for (var i:int = 0; i < length; i++)
			{
				var columnValuator:ColumnValuatorData = _valuatorsHandler.Column.ColumnValuators[i];
				var moneyTrail:MoneyTrail = new MoneyTrail(length, columnValuator.Payboxes[0].Center, columnValuator.Payboxes[2].Center, SplinesData.WinPoint);
				moneyTrail.y = 48;
				if (i == length - 1)
				{
					moneyTrail.addEventListener(Event.COMPLETE, OnMoneyTrailsComplete);
				}
				addChild(moneyTrail);
			}
			
			Main.Instance.ActiveMachine.Win += _valuatorsHandler.Column.Chips;
			Main.Instance.Application.Ticker.PushMessage("You Won: " + FormatterHelper.NumberToMoney(Main.Instance.ActiveMachine.Win), "Column: +" + FormatterHelper.NumberToMoney(_valuatorsHandler.Column.Chips), true, 920 / length);
		}
		private function OnMoneyTrailsComplete(event:Event):void
		{
			var moneyTrail:MoneyTrail = MoneyTrail(event.currentTarget);
			moneyTrail.removeEventListener(Event.COMPLETE, OnMoneyTrailsComplete);
			DoPostMoneyTrails();
		}
	}
}