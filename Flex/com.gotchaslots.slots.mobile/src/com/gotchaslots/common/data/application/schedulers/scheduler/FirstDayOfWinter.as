package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.assets.hud.frame.HudFrameEmbed;
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;

	public class FirstDayOfWinter extends BaseScheduler
	{
		// properties
		public override function get FrameClass():Class
		{
			return HudFrameEmbed.FirstDayOfWinter;
		}
		
		// class
		public function FirstDayOfWinter()
		{
			super(new ScheduleData(Number.NaN, 12, 21), new ScheduleData(Number.NaN, 12, 21));
		}
	}
}