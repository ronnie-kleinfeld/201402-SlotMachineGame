package com.gotchaslots.slots.ui.notifications.popup.bonusGame
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.spline.SplinesData;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.notifications.popup.base.BaseMachinePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.MainPopupButton;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BonusGameEndPopup extends BaseMachinePopup
	{
		// members
		private var _chips:Number;
		
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Congratulations:";
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new MainPopupButton("Collect", OnCollectChipsClick));
			return result;
		}
		
		protected override function get AutoCloseTimeout():int
		{
			return 0; 
		}
		
		// class
		public function BonusGameEndPopup(chips:Number, onClose:Function)
		{
			_chips = chips;
			
			super(onClose);
		}
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "You finished the");
			AddBlueMessageTextField(W, "Bonus Game");
			AddComponent(new Spacer(16));
			AddBlueMessageTextField(W, "You Won");
			AddBlueMessageTextField(W, FormatterHelper.NumberToMoney(_chips) + " Chips");
		}
		
		// money trail
		protected override function DoPostMoneyTrails():void
		{
			Main.Instance.Session.Wallet.CollectBonusGameEnd(_chips);
			DoRemove();
		}
		
		// events
		private function OnCollectChipsClick(event:MouseEvent):void
		{
			DoMoneyTrails(new Point(event.stageX - X, event.stageY - Y), new Point(SplinesData.BalancePoint.x - X, SplinesData.BalancePoint.y - Y + 48));
		}
		protected override function OnAutoCloseTimer(event:Event):void
		{
			Main.Instance.Session.Wallet.CollectBonusGameEnd(_chips);
			DoRemove();
		}
	}
}