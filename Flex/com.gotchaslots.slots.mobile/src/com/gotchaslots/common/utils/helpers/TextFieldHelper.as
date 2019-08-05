package com.gotchaslots.common.utils.helpers
{
	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	public class TextFieldHelper
	{
		public static function Enable(textField:TextField):void
		{
			EnableDisable(textField, true);
		}
		public static function Disable(textField:TextField):void
		{
			EnableDisable(textField, false);
		}
		private static function EnableDisable(textField:TextField, enable:Boolean):void
		{
			textField.tabEnabled = enable;
			textField.mouseEnabled = enable;
		}
		
		public static function SetText(textField:TextField, text:String):void
		{
			if (textField)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				textField.text = text;
				textField.antiAliasType = AntiAliasType.ADVANCED;
				textField.setTextFormat(textFormat);
			}
		}
		
		public static function AddTextToTextField(tf:TextField, str:String, vAlign:Boolean = false):void
		{
			if (!tf) return;
			
			var format:TextFormat = tf.getTextFormat();
			
			tf.text = str;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.setTextFormat(format);
			
			if (str != "")
			{
				if (!tf.multiline)
				{
					while ((tf.textWidth + 5) > tf.width && (int(format.size) > 1)) {
						format.size = int(format.size) - 1;
						tf.setTextFormat(format);
						tf.y += .5;
					}
				} else 
				{
					if (vAlign)
					{
						var alignObj:SpriteEx = MovieClip(tf.parent).alignToObject;
						
						if (alignObj != null && alignObj is SpriteEx)
						{
							tf.y = alignObj.y + (alignObj.height - tf.textHeight) / 2;
						} else
						{
							var num:Number = tf.numLines > 1?tf.textHeight / (tf.numLines - 1):tf.textHeight;
							var deltaL:int = int((tf.height - tf.textHeight) / 2 / num);
							
							for (var j:int = 0; j <deltaL; j++) {
								
								tf.text = "\n" + tf.text;
							}
							
						}
					}
				}
			}
		}
		
	}
}