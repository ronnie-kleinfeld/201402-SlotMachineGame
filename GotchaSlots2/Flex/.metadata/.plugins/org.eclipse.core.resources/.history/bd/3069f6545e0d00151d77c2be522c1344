package com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem
{
	import com.gotchaslots.common.data.application.prices.PriceOptionData;
	import com.gotchaslots.common.data.application.prices.PriceOptionsData;
	import com.gotchaslots.common.data.application.prices.ProductID;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields.BuyChipsButtonTextField;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields.BuyChipsChipsTextField;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields.BuyChipsMessageTextField;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields.BuyChipsPriceTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class BuyChipsItem extends BaseClickableButton
	{
		// members
		private var _priceOptions:PriceOptionsData;
		private var _priceOption:PriceOptionData;
		private var _buyChipsButton:BuyChipsButtonTextField;
		
		// class
		public function BuyChipsItem(priceOptions:PriceOptionsData, priceOption:PriceOptionData, normalPng:Bitmap)
		{
			super(112, 187, null, "", normalPng);
			
			_priceOptions = priceOptions;
			_priceOption = priceOption;
			
			addChild(new BuyChipsChipsTextField(FormatterHelper.NumberToMoney(_priceOption.Chips, 0, 0)));
			addChild(new BuyChipsPriceTextField("$" + FormatterHelper.NumberToMoney(ProductID.PriceByProductID(_priceOption.ProductID), 2)));
			addChild(new BuyChipsMessageTextField(_priceOption.Description));
			
			_buyChipsButton = new BuyChipsButtonTextField("Buy");
			addChild(_buyChipsButton);
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
			dispatchEvent(new BuyChipsItemEvent(BuyChipsItemEvent.Clicked, _priceOption));
		}
	}
}