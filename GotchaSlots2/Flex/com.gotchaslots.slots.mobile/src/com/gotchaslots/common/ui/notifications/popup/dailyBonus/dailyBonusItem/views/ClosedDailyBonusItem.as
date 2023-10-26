package com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views
{
	import com.gotchaslots.common.assets.notifications.popup.dailyBonus.DailyBonusEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemButtonTextField;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemDayTextField;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields.DailyBonusItemPriceTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	public class ClosedDailyBonusItem extends BasePng
	{
		// class
		public function ClosedDailyBonusItem(index:int)
		{
			super(119, 198, new DailyBonusEmbed.Violet());
			
			addChild(new DailyBonusItemDayTextField("Day " + (index + 1)));
			addChild(new DailyBonusItemPriceTextField(FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelReachedBonusChips * (index + 1), 0, 0) + "\nChips"));
			addChild(new DailyBonusItemButtonTextField("Next_Day"));
		}
	}
}