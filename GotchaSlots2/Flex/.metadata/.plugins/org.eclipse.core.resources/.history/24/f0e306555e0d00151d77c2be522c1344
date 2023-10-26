package com.gotchaslots.common.utils.helpers
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class ArrayHelper
	{
		public static function Clone(array:Array):Array
		{
			var result:ByteArray = new ByteArray();
			result.writeObject(array);
			result.position = 0;
			return(result.readObject());
		}
		public static function PopToCSV(array:Array, maxItems:int = -1):String
		{
			array.reverse();
			if (maxItems == -1)
			{
				maxItems = array.length;
			}
			
			var result:String = "";
			
			var index:int = 0;
			while(array.length > 0 && index < maxItems)
			{
				if (result == "")
				{
					result = array.pop();
				}
				else
				{
					result += "," + array.pop();
				}
				index++;
			}
			
			return result;
		}
		public static function ToObject(array:Array):Object
		{
			var oResult:Object = new Object();
			
			for (var key:String in array) 
			{
				if (array[key] == null)
				{
					oResult[key] = "NULL";
				}
				else if (array[key] == Dictionary)
				{
					//oResult[key] = DictionaryUtil.ToObject(array[key]);
				}
				else if (array[key] == Array)
				{
					//oResult[key] = ArrayUtil.ToObject(array[key]);
				}
				else
				{
					oResult[key] = array[key];
				}
			}
			
			return oResult;
		}
		
		public static function RemoveDuplicates(array:Array):Array
		{
			if (array == null)
			{
				return null;
			}
			else
			{
				var i:int;
				array.sort();
				while(i < array.length)
				{
					while(i < array.length + 1 && array[i] == array[i + 1])
					{
						array.splice(i, 1);
					}
					i++;
				}
				
				return array;
			}
		}
		public static function RemoveByKey(array:Array, key:Object):Array
		{
			if (array == null)
			{
				return null;
			}
			else
			{
				var result:Array = new Array();
				while (array.length > 0)
				{
					var o:Object = array.pop();
					if (o != key)
					{
						result.push(o);
					}
				}
				
				return result;
			}
		}
		
		public static function MergeSortedDescArray(array1:Array, array2:Array):Array
		{
			var array:Array = new Array();
			var i:int;
			var j:int;
			var k:int;
			while (i < array1.length && j < array2.length)
			{
				if (int(array1[i]) > int(array2[j]))
				{
					array[k] = array1[i];
					i++;
				}
				else
				{
					array[k] = array2[j];
					j++;
				}
				k++;
			}
			while (i < array1.length)
			{
				array[k] = array1[i];
				i++;
				k++;
			}
			while (j < array2.length)
			{
				array[k] = array2[j];
				j++;
				k++;
			}
			
			return array;
		}
		
		public static function Sum(array:Array):Number
		{
			var result:Number = 0;
			for (var i:int = 0; i < array.length; i++) 
			{
				result += array[i];
			}
			return result;
		}
	}
}