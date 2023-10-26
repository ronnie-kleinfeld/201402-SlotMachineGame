package com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views
{
	import com.gotchaslots.common.assets.notifications.popup.dailyBonus.DailyBonusEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.MainEvent;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemButtonTextField;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemDayTextField;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemPriceTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	public class TooSoonDailyBonusItem extends BasePng
	{
		// members
		private var _index:int;
		
		protected var _dailyBonusItemDay:DailyBonusItemDayTextField;
		protected var _dailyBonusItemPrice:DailyBonusItemPriceTextField;
		protected var _dailyBonusItemButton:DailyBonusItemButtonTextField;
		
		private var _bitSprite:Sprite;
		
		// class
		public function TooSoonDailyBonusItem(index:int)
		{
			super(119, 198, new DailyBonusEmbed.Yellow());
			
			_index = index;
			
			_bitSprite = new Sprite();
			
			InitDay();
			InitPrice();
			InitButton();
			
			Main.Instance.addEventListener(MainEvent.Timer, OnTimer);
		}
		protected function InitDay():void
		{
			_dailyBonusItemDay = new DailyBonusItemDayTextField("Day " + (_index + 1));
			addChild(_dailyBonusItemDay);
		}
		protected function InitPrice():void
		{
			_dailyBonusItemPrice = new DailyBonusItemPriceTextField(FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelReachedBonusChips * (_index + 1), 0, 0) + "\nChips");
			addChild(_dailyBonusItemPrice);
		}
		protected function InitButton():void
		{
			_dailyBonusItemButton = new DailyBonusItemButtonTextField("Collect in\n" + Main.Instance.Session.Rare.DailyBonusMSLeftToCellectToString);
			addChild(_dailyBonusItemButton);
		}
		public override function Dispose():void
		{
			Main.Instance.removeEventListener(MainEvent.Timer, OnTimer);
			
			super.Dispose();
			
			_bitSprite = null;
		}
		
		// event
		protected function OnTimer(event:Event):void
		{
			if (Main.Instance.Session.Rare.DailyBonusMSLeftToCellect <= 0)
			{
				dispatchEvent(new DailyBonusItemEvent(DailyBonusItemEvent.TooSoon2Clickable, _index, -1, -1));
			}
			else
			{
				_bitSprite.x = 0;
				TweenLite.to(_bitSprite, 0.5, {x:20 , onUpdate:OnBitTweenUpdate});
				_dailyBonusItemButton.Text = "Collect in\n" + Main.Instance.Session.Rare.DailyBonusMSLeftToCellectToString;
			}
		}
		
		private function OnBitTweenUpdate():void
		{
			this.filters = [new GlowFilter(0xffffff, 1, 20 - _bitSprite.x, 20 - _bitSprite.x)];
		}
	}
}