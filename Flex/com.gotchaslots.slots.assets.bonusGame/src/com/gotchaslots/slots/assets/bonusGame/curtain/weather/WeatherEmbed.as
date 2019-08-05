package com.gotchaslots.slots.assets.bonusGame.curtain.weather
{
	public class WeatherEmbed
	{
		// Sea
		[Embed(source="SunBG.jpg")]						public static const SunBG:Class;
		[Embed(source="Weather.swf", symbol="BrightOrangeHappy_Motion")]	public static const BrightOrangeHappy_Motion:Class;
		[Embed(source="Weather.swf", symbol="ShiningSunWinks_Motion")]		public static const ShiningSunWinks_Motion:Class;
		[Embed(source="Weather.swf", symbol="SillySmilingSun_Motion")]		public static const SillySmilingSun_Motion:Class;
		[Embed(source="Weather.swf", symbol="SleepySun_Motion")]			public static const SleepySun_Motion:Class;
		[Embed(source="Weather.swf", symbol="SunBehindClouds_Motion")]		public static const SunBehindClouds_Motion:Class;
		
		[Embed(source="WinterBG.jpg")]					public static const WinterBG:Class;
		[Embed(source="Weather.swf", symbol="Cloud_Motion")]				public static const Cloud_Motion:Class;
		[Embed(source="Weather.swf", symbol="Rain_Motion")]					public static const Rain_Motion:Class;
		[Embed(source="Weather.swf", symbol="RainWoman_Motion")]			public static const RainWoman_Motion:Class;
		[Embed(source="Weather.swf", symbol="Snow_Motion")]					public static const Snow_Motion:Class;
		[Embed(source="Weather.swf", symbol="SnowFlake_Motion")]			public static const SnowFlake_Motion:Class;
		[Embed(source="Weather.swf", symbol="TreeSnow_Motion")]				public static const TreeSnow_Motion:Class;
		
		// class
		public function WeatherEmbed()
		{
		}
	}
}