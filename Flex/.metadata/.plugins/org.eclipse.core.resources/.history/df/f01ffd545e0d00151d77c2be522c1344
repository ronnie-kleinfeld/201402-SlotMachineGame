package com.gotchaslots.common.ui.notifications.popup.machine.machineInfo
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	import com.gotchaslots.common.ui.common.components.buttons.BackButton;
	import com.gotchaslots.common.ui.common.components.buttons.NextButton;
	import com.gotchaslots.common.ui.common.components.gradientBG.RadialGradientBG;
	import com.gotchaslots.common.ui.notifications.popup.base.BaseMachinePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.textFields.PopupNavigatorTextField;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	
	public class CommonMachineInfoPopup extends BaseMachinePopup
	{
		// members
		protected var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		protected var _strip:SpriteEx;
		protected var _back:BackButton;
		protected var _next:NextButton;
		private var _navigatorTextField:PopupNavigatorTextField;
		protected var _machineInfoPage:int;
		
		private var _slideTween:TweenLite;
		
		// properties
		public function get MachineInfoPage():int
		{
			return _machineInfoPage;
		}
		public function set MachineInfoPage(value:int):void
		{
			throw new MustOverrideError();
		}
		
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		protected override function get Width():int
		{
			return 456;
		}
		protected override function get Height():int
		{
			return 382;
		}
		
		protected override function get Title():String
		{
			return "Machine Info";
		}
		
		protected override function get FrameCorner():Number
		{
			return 0;
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		protected override function get AutoCloseTimeout():int
		{
			return 0;
		}
		
		// class
		public function CommonMachineInfoPopup(machineInfoPage:int, lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function)
		{
			_lobbyMachine = lobbyMachine;
			
			super(onClose);
			
			InitStrip();
			InitNavigator();
			
			_machineInfoPage = -1;
			MachineInfoPage = machineInfoPage;
		}
		protected function InitStrip():void
		{
			_strip = new SpriteEx();
			_strip.x = 19;
			_strip.y = 103;
			_strip.addEventListener(TransformGestureEvent.GESTURE_SWIPE, OnGestureSwipe);
			
			var maskingShape:Shape = new Shape();
			maskingShape.graphics.beginFill(0x666666, 1);
			maskingShape.graphics.drawRect(19, 103, 421, 260);
			maskingShape.graphics.endFill();
			_strip.mask = maskingShape;
			addChild(maskingShape);
			
			addChild(_strip);
		}
		private function InitNavigator():void
		{
			var radialGradientBG:RadialGradientBG = new RadialGradientBG(421, 50, 15, 0x53f0fb, 0x00adf9);
			radialGradientBG.x = 19;
			radialGradientBG.y = 40;
			addChild(radialGradientBG);
			
			var navigatorBG:BaseBG = new BaseBG(421, 50, 0x8330ba);
			navigatorBG.x = 19;
			navigatorBG.y = 40;
			//addChild(navigatorBG);
			
			_navigatorTextField = new PopupNavigatorTextField(navigatorBG.width, "something");
			_navigatorTextField.x = navigatorBG.x;
			_navigatorTextField.y = navigatorBG.y + (navigatorBG.height - _navigatorTextField.height) / 2;
			addChild(_navigatorTextField);
			
			_back = new BackButton(OnBackClick);
			_back.x = navigatorBG.x + 3;
			_back.y = navigatorBG.y + 3;
			addChild(_back);
			
			_next = new NextButton(OnNextClick);
			_next.x = navigatorBG.x + navigatorBG.width - 3 - _next.width;
			_next.y = navigatorBG.y + 3;
			addChild(_next);
		}
		
		// methods
		protected override function AddBody():void
		{
		}
		protected function Slide(navigatorText:String):void
		{
			var targetX:int = -MachineInfoPage * 421 + 19;
			
			TweenLite.to(_strip, 0.5, {x:targetX});
			TweenLite.to(_navigatorTextField, 0.1, {alpha:0, onComplete:OnComplete, onCompleteParams:[navigatorText]});
		}
		
		// events
		protected function OnGestureSwipe(event:TransformGestureEvent):void
		{
			if (event.offsetX == 1)
			{
				MachineInfoPage--;
			}
			else if (event.offsetX == -1)
			{
				MachineInfoPage++;
			}
		}
		
		protected function OnBackClick(event:Event):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Slide);
			MachineInfoPage--;
		}
		protected function OnNextClick(event:Event):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Slide);
			MachineInfoPage++;
		}
		
		private function OnComplete(navigatorText:String):void
		{
			_navigatorTextField.Text = navigatorText;
			TweenLite.to(_navigatorTextField, 0.4, {alpha:1.4});
		}
		
		private function OnCloseClick(event:Event):void
		{
			DoRemove();
		}
	}
}