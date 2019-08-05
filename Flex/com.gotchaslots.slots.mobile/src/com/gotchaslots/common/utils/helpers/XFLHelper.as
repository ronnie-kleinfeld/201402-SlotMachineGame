package com.gotchaslots.common.utils.helpers
{
	import infrastructure.log.LogHandler;
	
	import fl.controls.List;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class XFLHelper
	{
		public static function Contains(container:Object, movieClip:DisplayObject, movieClipInstanceName:String):Boolean
		{
			var result:Boolean;
			try
			{
				return movieClip[movieClipInstanceName] != null;
			}
			catch (error:Error)
			{
				LogHandler.Write(container, "MovieClip " + movieClipInstanceName + " not found in " + movieClip.name, error);
				result = false;
			}
			return result;
		}
		public static function GetMovieClip(container:Object, movieClip:DisplayObject, movieClipInstanceName:String):MovieClip
		{
			var result:MovieClip;
			try
			{
				result = MovieClip(movieClip[movieClipInstanceName]);
				result.cacheAsBitmap = true;
				LogHandler.WriteIsNull(container, movieClipInstanceName, result);
			}
			catch (error:Error)
			{
				LogHandler.Write(container, "MovieClip " + movieClipInstanceName + " not found in " + movieClip.name, error);
				//result = new MovieClip();
				result = null;
			}
			return result;
		}
		public static function GetList(container:Object, movieClip:MovieClip, listInstanceName:String):List
		{
			var result:List;
			try
			{
				result = List(movieClip[listInstanceName]);
				LogHandler.WriteIsNull(container, listInstanceName, result);
			}
			catch (error:Error)
			{
				LogHandler.Instance.Publish(container, "List " + listInstanceName + " not found in " + movieClip.name, error);
				result = new List();
			}
			return result;
		}
		public static function GetBitmap(container:Object, movieClip:MovieClip, bitmapInstanceName:String):Bitmap
		{
			var result:Bitmap;
			try
			{
				result = Bitmap(movieClip[bitmapInstanceName]);
				LogHandler.WriteIsNull(container, bitmapInstanceName, result);
			}
			catch (error:Error)
			{
				LogHandler.Instance.Publish(container, "Bitmap " + bitmapInstanceName + " not found in " + movieClip.name, error);
				result = new Bitmap();
			}
			return result;
		}
		public static function GetTextField(container:Object, movieClip:MovieClip, textFieldInstanceName:String):TextField
		{
			var result:TextField;
			try
			{
				result = TextField(movieClip[textFieldInstanceName]);
				LogHandler.WriteIsNull(container, textFieldInstanceName, textFieldInstanceName);
			}
			catch (error:Error)
			{
				LogHandler.Instance.Publish(container, "TextField " + textFieldInstanceName + " not found in " + movieClip.name, error);
				result = new TextField();
			}
			return result;
		}
	}
}