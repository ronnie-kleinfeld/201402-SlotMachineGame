package com.gotchaslots.common.ui.common.components.base
{
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	
	public class BaseButton extends BaseTextField
	{
		// members
		private var _normalButton:SpriteEx;
		private var _selectedButton:SpriteEx;
		
		private var _selectedPng:Bitmap;
		
		protected var _normalText:String;
		
		protected var _isSelected:Boolean;
		protected var _isDisabled:Boolean;
		private var _colorMatrixFilter:ColorMatrixFilter;
		
		protected var _onClickDispatch:Function;
		
		// properties
		protected function get HasNormalButton():Boolean
		{
			return false;
		}
		protected function get NormalButtonColor():Number
		{
			return 0x265366;
		}
		protected function get NormalButtonFrameColor():Number
		{
			return 0x0087b4;
		}
		protected function get NormalButtonCorner():Number
		{
			return width * .1;
		}
		protected function get NormalButtonFilters():Array
		{
			return [new DropShadowFilter(4, 45, 0x000000), new BevelFilter(3, 45, 0xffffff, 1, 0)];
		}
		
		private function get NormalButton():SpriteEx
		{
			if (!_normalButton)
			{
				_normalButton = new SpriteEx();
				_normalButton.graphics.lineStyle(3, NormalButtonFrameColor, isNaN(NormalButtonFrameColor) ? 0 : 1);
				_normalButton.graphics.beginFill(NormalButtonColor);
				_normalButton.graphics.drawRoundRect(0, 0, W, H, NormalButtonCorner, NormalButtonCorner);
				_normalButton.graphics.endFill();
				_normalButton.filters = NormalButtonFilters;
				addChild(_normalButton);
			}
			
			return _normalButton;
		}
		
		protected function get HasSelectedButton():Boolean
		{
			return false;
		}
		protected function get SelectedButtonColor():Number
		{
			return 0x2c94bb;
		}
		protected function get SelectedButtonFrameColor():Number
		{
			return 0x1f5366;
		}
		protected function get SelectedButtonCorner():Number
		{
			return width * .1;
		}
		protected function get SelectedButtonFilters():Array
		{
			return [new BevelFilter(4, 225, 0xffffff, 1, 0)];
		}
		private function get SelectedButton():SpriteEx
		{
			if (!_selectedButton)
			{
				_selectedButton = new SpriteEx();
				_selectedButton.graphics.lineStyle(3, NormalButtonColor, isNaN(NormalButtonColor) ? 0 : 1);
				_selectedButton.graphics.beginFill(SelectedButtonColor);
				_selectedButton.graphics.drawRoundRect(0, 0, W, H, SelectedButtonCorner, SelectedButtonCorner);
				_selectedButton.graphics.endFill();
				_selectedButton.filters = SelectedButtonFilters;
			}
			
			return _selectedButton;
		}
		
		public function get IsSelected():Boolean
		{
			return _isSelected;
		}
		
		private function get DisabledColorMatrixFilter():ColorMatrixFilter
		{
			if (!_colorMatrixFilter)
			{
				var matrix:Array = [.33,.33,.33,0,0, .33,.33,.33,0,0, .33,.33,.33,0,0, .33,.33,.33,1,0];
				_colorMatrixFilter = new ColorMatrixFilter(matrix);
			}
			return _colorMatrixFilter;
		}
		
		// class
		public function BaseButton(w:int, h:int, onClickDispatch:Function, text:String, normalPng:Bitmap = null, selectedPng:Bitmap = null, bgColor:Number = Number.NaN)
		{
			super(w, h, text, normalPng, bgColor);
			
			_normalText = text;
			_onClickDispatch = onClickDispatch;
			
			InitSelectedPng(selectedPng);
			
			SetNormal();
		}
		private function InitSelectedPng(selectedPng:Bitmap):void
		{
			if (selectedPng)
			{
				_selectedPng = selectedPng;
				_selectedPng.smoothing = true;
				_selectedPng.scaleX = _selectedPng.scaleY = Math.min(W / _selectedPng.width, H / _selectedPng.height);
				_selectedPng.x = (W - _selectedPng.width) / 2;
				_selectedPng.y = (H - _selectedPng.height) / 2;
				_selectedPng.filters = [new BevelFilter(3, 225, 0xffffff, 1, 0)];
			}
		}
		
		// methods
		public function SetNormal():void
		{
			_isSelected = false;
			_isDisabled = false;
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
			this.filters = null;
			
			var index:int;
			if (HasNormalButton && HasSelectedButton)
			{
				if (contains(SelectedButton))
				{
					index = getChildIndex(SelectedButton);
					DisplayObjectHelper.SafeRemoveChild(this, SelectedButton);
				}
				else
				{
					index = getChildIndex(BG);
				}
				addChildAt(NormalButton, index);
			}
			
			if (NormalPng && _selectedPng)
			{
				if (contains(_selectedPng))
				{
					index = getChildIndex(_selectedPng);
					DisplayObjectHelper.SafeRemoveChild(this, _selectedPng);
				}
				else
				{
					index = getChildIndex(BG);
				}
				addChildAt(NormalPng, index);
			}
		}
		public function SetSelected():void
		{
			_isSelected = true;
			_isDisabled = false;
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
			this.filters = null;
			
			var index:int;
			if (HasNormalButton && HasSelectedButton)
			{
				if (contains(NormalButton))
				{
					index = getChildIndex(NormalButton);
					DisplayObjectHelper.SafeRemoveChild(this, NormalButton);
				}
				else
				{
					index = getChildIndex(BG);
				}
				addChildAt(_selectedButton, index);
			}
			
			if (NormalPng && _selectedPng)
			{
				if (contains(NormalPng))
				{
					index = getChildIndex(NormalPng);
					DisplayObjectHelper.SafeRemoveChild(this, NormalPng);
				}
				else
				{
					index = getChildIndex(BG);
				}
				addChildAt(_selectedPng, index);
			}
		}
		public function SetClickable():void
		{
			_isDisabled = false;
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = true;
		}
		public function SetUnclickable():void
		{
			_isDisabled = true;
			buttonMode = false;
			mouseEnabled = false;
			mouseChildren = true;
			useHandCursor = false;
		}
		public function SetEnabled():void
		{
			SetClickable();
			this.filters = null;
		}
		public function SetDisabled():void
		{
			SetUnclickable();
			this.filters = [DisabledColorMatrixFilter];
		}
		
		// events
		protected function OnClick(event:MouseEvent):void
		{
			//SoundsHandler.Instance.Play(SoundsHandler.Button);
			// override to implement an in-button onClick action
		}
	}
}