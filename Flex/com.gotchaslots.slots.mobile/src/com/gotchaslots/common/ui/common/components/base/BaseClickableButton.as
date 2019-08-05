package com.gotchaslots.common.ui.common.components.base
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class BaseClickableButton extends BaseButton
	{
		// class
		public function BaseClickableButton(w:int, h:int, onClickDispatch:Function, text:String, normalPng:Bitmap = null, selectedPng:Bitmap = null, bgColor:Number = Number.NaN)
		{
			super(w, h, onClickDispatch, text, normalPng, selectedPng, bgColor);
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			removeEventListener(MouseEvent.ROLL_OUT, OnRollOut);
			removeEventListener(MouseEvent.CLICK, OnClick);
		}
		
		// methods
		public override function SetNormal():void
		{
			super.SetNormal();
			
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			addEventListener(MouseEvent.ROLL_OUT, OnRollOut);
			addEventListener(MouseEvent.CLICK, OnClick);
		}
		public override function SetSelected():void
		{
			super.SetSelected();
			
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			addEventListener(MouseEvent.ROLL_OUT, OnRollOut);
			addEventListener(MouseEvent.CLICK, OnClick);
		}
		public override function SetClickable():void
		{
			super.SetClickable();
			
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			addEventListener(MouseEvent.ROLL_OUT, OnRollOut);
			addEventListener(MouseEvent.CLICK, OnClick);
		}
		public override function SetUnclickable():void
		{
			super.SetUnclickable();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			removeEventListener(MouseEvent.ROLL_OUT, OnRollOut);
			removeEventListener(MouseEvent.CLICK, OnClick);
		}
		public override function SetEnabled():void
		{
			super.SetEnabled();
		}
		public override function SetDisabled():void
		{
			super.SetDisabled();
		}
		
		// events
		protected function OnMouseDown(event:MouseEvent):void
		{
			if (!_isDisabled)
			{
				SetSelected();
			}
		}
		protected function OnMouseUp(event:MouseEvent):void
		{
			if (!_isDisabled)
			{
				SetNormal();
			}
		}
		protected function OnRollOut(event:MouseEvent):void
		{
			if (_isSelected && !_isDisabled)
			{
				SetNormal();
			}
		}
		protected override function OnClick(event:MouseEvent):void
		{
			if (_onClickDispatch != null)
			{
				_onClickDispatch(event);
			}
		}
	}
}