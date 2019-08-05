package com.gotchaslots.common.ui.notifications.popup.base
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseSwitchableButton;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BaseVolumeButton extends BaseSwitchableButton
	{
		// class
		public function BaseVolumeButton(w:int, h:int, normalPng:Bitmap, selectedPng:Bitmap)
		{
			super(w, h, null, null, null, normalPng, selectedPng, Number.NaN);
			
			SetState();
			
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.VolumeChanged, OnVolumeChanged);
		}
		public override function Dispose():void
		{
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.VolumeChanged, OnVolumeChanged);
			
			super.Dispose();
		}
		
		// methods
		protected function SetState():void
		{
			switch (Main.Instance.Session.Rare.Volume)
			{
				case false:
					SetSelected();
					break;
				case true:
					SetNormal();
					break;
			}
		}
		
		// events
		protected function OnVolumeChanged(event:Event):void
		{
			SetState();
		}
		
		protected override function OnNormal(event:MouseEvent):void
		{
			Main.Instance.Session.Rare.Volume = true;
		}
		protected override function OnSelected(event:MouseEvent):void
		{
			Main.Instance.Session.Rare.Volume = false;
		}
	}
}