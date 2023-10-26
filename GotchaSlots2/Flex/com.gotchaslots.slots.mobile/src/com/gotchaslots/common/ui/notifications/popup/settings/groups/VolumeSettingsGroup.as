package com.gotchaslots.common.ui.notifications.popup.settings.groups
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.notifications.popup.settings.buttons.VolumeSettingsButton;
	import com.gotchaslots.common.ui.notifications.popup.settings.textField.PopupSettingsTextField;
	
	import flash.events.MouseEvent;
	
	public class VolumeSettingsGroup extends BaseSettingsGroup
	{
		// members
		private var _sound:PopupSettingsTextField;
		
		// properties
		private function get GetText():String
		{
			return Main.Instance.Session.Rare.Volume ? "Sound On" : "Sound Off";
		}
		
		// class
		public function VolumeSettingsGroup(w:int, h:int)
		{
			super(w, h);
			
			var settingsPopupVolume:VolumeSettingsButton = new VolumeSettingsButton();
			settingsPopupVolume.x = 3;
			settingsPopupVolume.y = 3;
			addChild(settingsPopupVolume);
			
			_sound = new PopupSettingsTextField(W, GetText);
			_sound.x = W * 0.05;
			_sound.y = 3;
			addChild(_sound);
			
			addEventListener(MouseEvent.CLICK, OnClick);
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			Main.Instance.Session.Rare.Volume = !Main.Instance.Session.Rare.Volume;
			
			_sound.Text = GetText;
		}
	}
}