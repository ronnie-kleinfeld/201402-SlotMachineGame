package com.gotchaslots.common.ui.notifications.popup.dailyBonus
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.spline.SplinesData;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.DailyBonusItemView;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.DailyBonusItemEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DailyBonusPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.BigPopup;
		}
		protected override function get Width():int
		{
			return 640;
		}
		protected override function get Height():int
		{
			return 300;
		}
		
		protected override function get AutoCloseTimeout():int
		{
			return 30000; 
		}
		
		protected override function get Title():String
		{
			return "Daily Bonus!";
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function DailyBonusPopup(onClose:Function)
		{
			super(onClose);
			
			Main.Instance.Session.Rare.ValidateDailyBonusCollected();
		}
		
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "Pick your daily bonus");
			for (var i:int = 0; i < 5; i++)
			{
				var dailyBonusItem:DailyBonusItemView = new DailyBonusItemView(i);
				dailyBonusItem.addEventListener(DailyBonusItemEvent.Clickable2Clicked, OnClickable2Clicked);
				dailyBonusItem.addEventListener(DailyBonusItemEvent.Close2TooSoon, OnClose2TooSoon);
				dailyBonusItem.x = 8 + i * (120 + 6);
				dailyBonusItem.y = 86;
				addChild(dailyBonusItem);
			}
		}
		
		// money trail
		protected override function DoPostMoneyTrails():void
		{
			Main.Instance.Session.Rare.DailyBonusCollected();
			DoRemove();
		}
		
		// events
		protected function OnClickable2Clicked(event:DailyBonusItemEvent):void
		{
			DoMoneyTrails(new Point(event.StageX - X, event.StageY - Y), new Point(SplinesData.BalancePoint.x - X, SplinesData.BalancePoint.y - Y + 48));
		}
		protected function OnClose2TooSoon(event:DailyBonusItemEvent):void
		{
			return;
			for (var i:int = 0; i < numChildren; i++)
			{
				var o:Object = getChildAt(i);
				if (o is DailyBonusItemView)
				{
					var dailyBonusItem:DailyBonusItemView = DailyBonusItemView(o);
					if (dailyBonusItem.Index == event.Index)
					{
						dailyBonusItem.SetTooSoonDailyBonusItem();
					}
				}
			}
		}
		private function OnCloseClick(event:Event):void
		{
			DoRemove();
		}
	}
}