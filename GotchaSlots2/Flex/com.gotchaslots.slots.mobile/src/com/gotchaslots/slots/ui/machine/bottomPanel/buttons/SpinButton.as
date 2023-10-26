package com.gotchaslots.slots.ui.machine.bottomPanel.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.ui.machine.bottomPanel.BottomPanelEvent;
	import com.gotchaslots.common.utils.debug.FrameRateHandler;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class SpinButton extends BaseBottomPanelButton
	{
		// members
		private var _bitSprite:Sprite;
		
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineBottomPanelSpin;
		}
		
		protected override function get NormalButtonColor():Number
		{
			return 0x05e747;
		}
		protected override function get NormalButtonFrameColor():Number
		{
			return 0x009122;
		}
		protected override function get SelectedButtonColor():Number
		{
			return 0x009122;
		}
		protected override function get SelectedButtonFrameColor():Number
		{
			return 0x05e747;
		}
		
		// class
		public function SpinButton()
		{
			super(128, 128, "Spin");
			
			_bitSprite = new Sprite();
			StartBit();
		}
		public override function Dispose():void
		{
			StopBit();
			TweenLite.killTweensOf(_bitSprite);
			
			if (_bitSprite)
			{
				_bitSprite = null;
			}
			
			super.Dispose();
		}
		
		// methods
		public override function SetEnabled():void
		{
			super.SetEnabled();
			
			StartBit();
		}
		public override function SetDisabled():void
		{
			super.SetDisabled();
			
			StopBit();
		}
		
		private function StartBit():void
		{
			if (Main.Instance.Application.EnableSpinButtonBit)
			{
				TweenLite.to(_bitSprite, 0.5, {x:30, delay:0.5, onUpdate:OnBitTweenUpdate, onComplete:OnBitTweenComplete});
			}
		}
		private function StopBit():void
		{
			TweenLite.killTweensOf(_bitSprite);
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			super.OnClick(event);
			dispatchEvent(new Event(BottomPanelEvent.SpinButtonClicked));
		}
		
		private function OnBitTweenUpdate():void
		{
			if (_bitSprite)
			{
				this.filters = [new GlowFilter(0xffffff, 1, 30 - _bitSprite.x, 30 - _bitSprite.x)];
			}
		}
		private function OnBitTweenComplete():void
		{
			if (_bitSprite &&
				Main.Instance.Device.FrameRate.ActualFrameRate > FrameRateHandler.MAX_RATE_FOR_ANIMATION)
			{
				_bitSprite.x = 0;
				TweenLite.to(_bitSprite, 0.5, {x:30, delay:0.5, onUpdate:OnBitTweenUpdate, onComplete:OnBitTweenComplete});
			}
		}
	}
}