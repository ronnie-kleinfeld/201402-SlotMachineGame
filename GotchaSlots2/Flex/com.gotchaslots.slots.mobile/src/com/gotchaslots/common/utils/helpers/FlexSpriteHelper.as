package com.gotchaslots.common.utils.helpers
{
	import infrastructure.log.LogHandler;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	
	public class FlexSpriteHelper
	{
		// remove
		public static function SafeRemoveChild(container:Group, object:IVisualElement):void
		{
			try
			{
				container.removeElement(object);
			}
			catch (error:Error)
			{
				LogHandler.Write(container, "container is null:" + (container == null).toString() + " object is null:" + (object == null).toString(), error);
			}
		}
		public static function SafeRemoveChildAt(container:Group, index:int):void
		{
			try
			{
				container.removeElementAt(index);
			}
			catch (error:Error)
			{
				LogHandler.Write(container, "container is null:" + (container == null).toString(), error);
			}
		}
		public static function SafeRemoveAllChildrens(container:Group):void
		{
			try
			{
				while (container.numElements > 0)
				{
					container.removeElementAt(0);
				}
			}
			catch (error:Error)
			{
				LogHandler.Write(container, "container is null:" + (container == null).toString(), error);
			}
		}
	}
}