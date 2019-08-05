package com.gotchaslots.common.utils.helpers
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	public class ReflectionHelper
	{
		public static function GetQualifiedName(container:Object):String
		{
			var result:String = "";
			try
			{
				//result = flash.utils.getQualifiedSuperclassName(container) + ":" + flash.utils.getQualifiedClassName(container);
				result = flash.utils.getQualifiedClassName(container);
			}
			catch (error:Error)
			{
				result = "";
			}
			return result;
		}
		
		public static function GetFunctionName(parent:Object, callee:Function):String
		{
			for each (var xml:XML in describeType(parent)..method)
			{
				if (parent[xml.@name] == callee)
				{
					return xml.@name;
				}
			}
			
			return "";                                      
		}
	}
}