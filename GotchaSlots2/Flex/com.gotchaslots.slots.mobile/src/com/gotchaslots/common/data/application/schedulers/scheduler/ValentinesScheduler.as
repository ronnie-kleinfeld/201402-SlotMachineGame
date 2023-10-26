package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.assets.hud.frame.HudFrameEmbed;
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class ValentinesScheduler extends BaseScheduler
	{
		// properties
		public override function get FrameClass():Class
		{
			return HudFrameEmbed.ValentinesDay;
		}

		// class
		public function ValentinesScheduler()
		{
			super(new ScheduleData(Number.NaN, 2, 10), new ScheduleData(Number.NaN, 2, 14));
		}
	}
}