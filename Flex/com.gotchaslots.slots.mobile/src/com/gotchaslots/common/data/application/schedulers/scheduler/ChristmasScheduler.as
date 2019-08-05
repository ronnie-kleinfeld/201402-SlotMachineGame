package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.assets.hud.frame.HudFrameEmbed;
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;

	public class ChristmasScheduler extends BaseScheduler
	{
		// properties
		public override function get FrameClass():Class
		{
			return HudFrameEmbed.Christmas;
		}
		
		// class
		public function ChristmasScheduler()
		{
			super(new ScheduleData(Number.NaN, 12, 22), new ScheduleData(Number.NaN, 12, 25));
		}
	}
}