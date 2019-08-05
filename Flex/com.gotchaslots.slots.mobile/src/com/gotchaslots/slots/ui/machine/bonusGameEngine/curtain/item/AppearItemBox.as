package com.gotchaslots.slots.ui.machine.bonusGameEngine.curtain.item
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.AppearCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.base.CurtainItemDataEvent;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.curtain.item.base.BaseItemBox;
	
	import flash.events.MouseEvent;
	
	public class AppearItemBox extends BaseItemBox
	{
		// class
		public function AppearItemBox(appearCurtainItem:AppearCurtainItemData)
		{
			super(appearCurtainItem);
			
			appearCurtainItem.GetMC.gotoAndStop(1);
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			CurtainItem.Selected = true;
			
			Main.Instance.Sounds.Play(CurtainItem.ClickSound);
			dispatchEvent(new CurtainItemDataEvent(CurtainItemDataEvent.ItemClick, CurtainItem));
			
			DoShowScore();
			
			Main.Instance.Device.DeviceStage.frameRate = 24;
			CurtainItem.GetMC.addFrameScript(CurtainItem.GetMC.totalFrames - 1, onMCLastFrame);
			CurtainItem.GetMC.gotoAndPlay(1);
		}
		private function onMCLastFrame():void
		{
			CurtainItem.GetMC.gotoAndStop(CurtainItem.GetMC.totalFrames);
			CurtainItem.GetMC.addFrameScript(CurtainItem.GetMC.totalFrames - 1, null);
			
			Main.Instance.Device.DeviceStage.frameRate = 60;
			
			Main.Instance.Sounds.Play(CurtainItem.IsFailure ? CurtainItem.LoseSound : CurtainItem.WinSound);
			
			dispatchEvent(new CurtainItemDataEvent(CurtainItemDataEvent.ItemClicked, CurtainItem));
		}
	}
}