package com.gotchaslots.common.ui.common.group
{
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	
	import flash.events.MouseEvent;
	
	public class BaseVGroup extends BaseComponent
	{
		// members
		protected var _width:int;
		protected var _height:int;
		
		// properties
		protected function get Components():Vector.<BaseComponent>
		{
			throw new MustOverrideError();
		}
		protected function get HorizontalAlign():String
		{
			return HorizontalAlignEnum.CENTER;
		}
		protected function get VerticalAlign():String
		{
			return VerticalAlignEnum.MIDDLE;
		}
		
		// class
		public function BaseVGroup(w:int, h:int)
		{
			super(w, h);
			
			_width = w;
			_height = h;
			
			InitComponents(Components);
		}
		protected function InitComponents(components:Vector.<BaseComponent>):void
		{
			var currentY:int = 0;
			var sprite:SpriteEx = new SpriteEx();
			for (var i:int = 0; i < components.length; i++)
			{
				var component:BaseComponent = components[i];
				component.y = currentY;
				sprite.addChild(component);
				
				currentY += component.height;
			}
			
			switch (HorizontalAlign)
			{
				case HorizontalAlignEnum.LEFT:
					sprite.x = 0;
					break;
				case HorizontalAlignEnum.CENTER:
					sprite.x = (_width - component.width) / 2;
					break;
				case HorizontalAlignEnum.RIGHT:
					sprite.x = _width - component.width;
					break;
			}
			switch (VerticalAlign)
			{
				case VerticalAlignEnum.TOP:
					sprite.y = 0;
					break;
				case VerticalAlignEnum.MIDDLE:
					sprite.y = (_height - component.height) / 2;
					break;
				case VerticalAlignEnum.BOTTOM:
					sprite.y = _height - component.height;
					break;
			}
			addChild(sprite);
		}
		
		// methods
		protected function Disable():void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var object:Object = getChildAt(i);
				if (typeof(object) is BaseButton)
				{
					//object.removeEventListener(MouseEvent.CLICK, onClick);
					BaseButton(object).SetDisabled();
				}
			}
		}
		
		// events
		protected function OnClick(event:MouseEvent):void
		{
			//dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
}