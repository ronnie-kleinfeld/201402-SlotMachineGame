package com.gotchaslots.common.ui.common.components.freeActionScript.explosion
{
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	import flash.display.Bitmap;
	
	public class Particle extends SpriteEx
	{
		// members
		private var _growSpeed:Number;
		private var _fadeSpeed:Number;
		private var _vx:Number;
		private var _vy:Number;
		
		// properties
		public function get GrowSpeed():Number 
		{
			return _growSpeed;
		}
		public function set GrowSpeed(value:Number):void 
		{
			_growSpeed = value;
		}
		public function get FadeSpeed():Number 
		{
			return _fadeSpeed;
		}
		public function set FadeSpeed(value:Number):void 
		{
			_fadeSpeed = value;
		}
		public function get VX():Number 
		{
			return _vx;
		}
		public function set VX(value:Number):void 
		{
			_vx = value;
		}
		public function get VY():Number 
		{
			return _vy;
		}
		public function set VY(value:Number):void 
		{
			_vy = value;
		}
		
		// class
		public function Particle(bitmap:Bitmap) 
		{
			addChild(bitmap);
		}
	}
}