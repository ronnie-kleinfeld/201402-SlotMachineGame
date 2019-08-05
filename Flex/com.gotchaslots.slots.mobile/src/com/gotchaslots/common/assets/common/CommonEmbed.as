package com.gotchaslots.common.assets.common
{
	public class CommonEmbed
	{
		// embed
		[Embed(source="Chip.png")] public static const Chip:Class;
		
		[Embed(source="loader/Loader.swf", symbol="AndroidLoader")]	public static const AndroidLoader:Class;

		// class
		public function CommonEmbed()
		{
		}
	}
}