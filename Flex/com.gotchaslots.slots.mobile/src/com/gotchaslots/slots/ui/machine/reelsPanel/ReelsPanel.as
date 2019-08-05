package com.gotchaslots.slots.ui.machine.reelsPanel
{
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	import flash.events.Event;
	
	public class ReelsPanel extends SpriteEx
	{
		// members
		private var _reelsBG:ReelsBG;
		private var _reels:Reels;
		private var _animatePaylines:AnimatePaylines;
		private var _paylinesBox:PaylinesBox;
		
		// properties
		public function get GetReels():Reels
		{
			return _reels;
		}
		public function get GetAnimatePaylines():AnimatePaylines
		{
			return _animatePaylines;
		}
		public function get GetAnimatePaylinesBox():PaylinesBox
		{
			return _paylinesBox;
		}
		
		// class
		public function ReelsPanel()
		{
			super();
			
		}
		public function Init():void
		{
			_reelsBG = new ReelsBG();
			addChild(_reelsBG);
			
			_reels = new Reels();
			_reels.addEventListener(ReelsPanelEvent.ReelStopped, OnReelStopped);
			addChild(_reels);
			
			_animatePaylines = new AnimatePaylines();
			addChild(_animatePaylines);
			
			_paylinesBox = new PaylinesBox();
			addChild(_paylinesBox);
		}
		public override function Dispose():void
		{
			if (_reelsBG)
			{
				_reelsBG.Dispose();
				_reelsBG = null;
			}
			
			if (_reels)
			{
				_reels.Dispose();
				_reels = null;
			}
			
			if (_animatePaylines)
			{
				_animatePaylines.Dispose();
				_animatePaylines = null;
			}
			
			if (_paylinesBox)
			{
				_paylinesBox.Dispose();
				_paylinesBox = null;
			}
			
			super.Dispose();
		}
		
		// events
		private function OnReelStopped(event:Event):void
		{
			dispatchEvent(new Event(ReelsPanelEvent.ReelStopped));
		}
		private function OnParticlePaylinesComplete(event:Event):void
		{
			dispatchEvent(new Event(ReelsPanelEvent.ParticlePaylinesComplete));
		}
	}
}