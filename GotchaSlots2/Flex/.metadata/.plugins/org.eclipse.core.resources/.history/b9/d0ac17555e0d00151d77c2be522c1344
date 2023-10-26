package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.assets.hud.frame.HudFrameEmbed;
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class NewYearScheduler extends BaseScheduler
	{
		// properties
		public override function get FrameClass():Class
		{
			return HudFrameEmbed.NewYearsDay;
		}

		// class
		public function NewYearScheduler()
		{
			super(new ScheduleData(Number.NaN, 1, 1), new ScheduleData(Number.NaN, 1, 1));
		}
	}
}