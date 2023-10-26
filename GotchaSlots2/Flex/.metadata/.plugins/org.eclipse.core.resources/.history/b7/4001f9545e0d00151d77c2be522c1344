package com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views
{
	import com.gotchaslots.common.assets.notifications.popup.dailyBonus.DailyBonusEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemButtonTextField;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemDayTextField;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemPriceTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class ClickableDailyBonusItem extends BaseClickableButton
	{
		// members
		private var _index:int;
		
		// class
		public function ClickableDailyBonusItem(index:int)
		{
			super(119, 198, null, "", new DailyBonusEmbed.Green());
			
			_index = index;
			
			addChild(new DailyBonusItemDayTextField("Day " + (_index + 1)));
			addChild(new DailyBonusItemPriceTextField(FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelReachedBonusChips * (_index + 1), 0, 0) + "\nChips"));
			addChild(new DailyBonusItemButtonTextField("Collect"));
		}
		
		// events
		protected override function OnMouseDown(event:MouseEvent):void
		{
			this.filters = [new GlowFilter(0xffffff, 1, 20, 20)];
		}
		protected override function OnMouseUp(event:MouseEvent):void
		{
			this.filters = null;
		}
		protected override function OnRollOut(event:MouseEvent):void
		{
			this.filters = null;
		}
		protected override function OnClick(event:MouseEvent):void
		{
			dispatchEvent(new DailyBonusItemEvent(DailyBonusItemEvent.Clickable2Clicked, _index, event.stageX, event.stageY));
		}
	}
}