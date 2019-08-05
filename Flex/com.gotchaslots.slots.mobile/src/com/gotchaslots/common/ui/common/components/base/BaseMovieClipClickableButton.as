package com.gotchaslots.common.ui.common.components.base
{
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.display.MovieClip;
	
	public class BaseMovieClipClickableButton extends BaseClickableButton
	{
		// members
		private var _normalMC:MovieClip;
		private var _selectedMC:MovieClip;
		
		// properties
		public override function SetNormal():void
		{
			super.SetNormal();
			
			var index:int;
			if (contains(SelectedMC))
			{
				index = getChildIndex(SelectedMC);
				DisplayObjectHelper.SafeRemoveChild(this, SelectedMC);
			}
			else
			{
				index = getChildIndex(BG);
			}
			addChildAt(NormalMC, index);
		}
		public override function SetSelected():void
		{
			super.SetSelected();
			
			var index:int;
			if (contains(NormalMC))
			{
				index = getChildIndex(NormalMC);
				DisplayObjectHelper.SafeRemoveChild(this, NormalMC);
			}
			else
			{
				index = getChildIndex(BG);
			}
			addChildAt(SelectedMC, index);
		}

		public function get NormalMC():MovieClip
		{
			return _normalMC;
		}
		public function get SelectedMC():MovieClip
		{
			return _selectedMC;
		}
		
		// class
		public function BaseMovieClipClickableButton(w:int, h:int, onClickDispatch:Function, text:String, normalMC:MovieClip, selectedMC:MovieClip, bgColor:Number = Number.NaN)
		{
			_normalMC = normalMC;
			_selectedMC = selectedMC;

			super(w, h, onClickDispatch, text, null, null, bgColor);
		}
	}
}