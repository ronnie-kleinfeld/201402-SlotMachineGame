package com.gotchaslots.common.ui.common.components
{
	import com.gotchaslots.common.assets.common.CommonEmbed;
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	
	import flash.display.Sprite;
	
	public class AndroidLoader extends BaseBG
	{
		// members
		private var _sprite:Sprite;
		
		// class
		public function AndroidLoader(w:int, h:int)
		{
			super(w, h);
			
			_sprite = new CommonEmbed.AndroidLoader();
			_sprite.scaleX = _sprite.scaleY = Math.min(W / _sprite.width, H / _sprite.height);
			_sprite.x = (W - _sprite.width) / 2;
			_sprite.y = (H - _sprite.height) / 2;
			addChild(_sprite);
		}
	}
}