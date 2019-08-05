package com.gotchaslots.slots.ui.machine.bonusGameEngine.curtain
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.base.BaseCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.base.CurtainItemDataEvent;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainLevel.CurtainLevelData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainLevel.CurtainLevelDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.curtain.item.base.BaseItemBox;
	import com.gotchaslots.common.utils.ex.TimerEx;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	
	public class LevelBox extends BaseComponent
	{
		// members
		private var _curtainLevel:CurtainLevelData;
		private var _selectedItemsCount:int;
		
		// class
		public function LevelBox(curtainLevel:CurtainLevelData)
		{
			super(0, 0);
			
			_curtainLevel = curtainLevel;
			
			if (_curtainLevel.BG)
			{
				var bg:DisplayObject = _curtainLevel.BG;
				addChild(bg);
			}
			
			for (var i:int = 0; i < _curtainLevel.CurtainItems.length; i++)
			{
				var curtainItem:BaseCurtainItemData = _curtainLevel.CurtainItems[i];
				
				var itemBox:BaseItemBox = new curtainItem.ItemBoxClass(curtainItem);
				itemBox.addEventListener(CurtainItemDataEvent.ItemClick, onItemClick);
				itemBox.addEventListener(CurtainItemDataEvent.ItemClicked, onItemClicked);
				itemBox.x = curtainItem.StartRectangle.x;
				itemBox.y = curtainItem.StartRectangle.y;
				addChild(itemBox);
			}
			
			Main.Instance.Application.Ticker.PushMessage(_curtainLevel.TickerMessage, "", true);
		}
		
		// methods
		private function DoShowScores(isSuccess:Boolean):void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var o:Object = getChildAt(i);
				if (o is BaseItemBox)
				{
					var itemBox:BaseItemBox = BaseItemBox(o);
					if (!itemBox.CurtainItem.Selected)
					{
						itemBox.SetDisabled();
						itemBox.DoShowScore();
					}
				}
			}
			
			var timer:TimerEx = new TimerEx(2000);
			timer.addEventListener(TimerEvent.TIMER, isSuccess ? onSuccessTimer : onFailedTimer);
			timer.start();
		}
		protected function onSuccessTimer(event:TimerEvent):void
		{
			var timer:TimerEx = TimerEx(event.currentTarget);
			timer.removeEventListener(TimerEvent.TIMER, onSuccessTimer);
			timer.Dispose();
			timer = null;
			
			dispatchEvent(new CurtainLevelDataEvent(CurtainLevelDataEvent.LevelSuccess, _curtainLevel));
		}
		protected function onFailedTimer(event:TimerEvent):void
		{
			var timer:TimerEx = TimerEx(event.currentTarget);
			timer.removeEventListener(TimerEvent.TIMER, onFailedTimer);
			timer.Dispose();
			timer = null;
			
			dispatchEvent(new CurtainLevelDataEvent(CurtainLevelDataEvent.LevelFailed, _curtainLevel));
		}
		
		// events
		protected function onItemClick(event:CurtainItemDataEvent):void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var o:Object = getChildAt(i);
				if (o is BaseItemBox)
				{
					var itemBox:BaseItemBox = BaseItemBox(o);
					if (itemBox.CurtainItem.ID == event.CurtainItem.ID || !itemBox.CurtainItem.Selected)
					{
						itemBox.SetUnclickable();
					}
				}
			}
		}
		protected function onItemClicked(event:CurtainItemDataEvent):void
		{
			dispatchEvent(new CurtainLevelDataEvent(CurtainLevelDataEvent.LevelClicked, _curtainLevel));
			_selectedItemsCount++;
			if (event.CurtainItem.IsFailure)
			{
				DoShowScores(false);
			}
			else if (_selectedItemsCount == _curtainLevel.SelectiveItemsCount)
			{
				DoShowScores(true);
			}
			else
			{
				Main.Instance.Application.Ticker.PushMessage(_curtainLevel.TickerMessage, "", true);
				
				for (var i:int = 0; i < numChildren; i++)
				{
					var o:Object = getChildAt(i);
					if (o is BaseItemBox)
					{
						var itemBox:BaseItemBox = BaseItemBox(o);
						if (!itemBox.CurtainItem.Selected)
						{
							itemBox.SetEnabled();
						}
					}
				}
			}
		}
	}
}