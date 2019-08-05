package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.assets.hud.frame.HudFrameEmbed;
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;

	public class BlackFridayScheduler extends BaseScheduler
	{
		// properties
		public override function get FrameClass():Class
		{
			return HudFrameEmbed.BlackFriday;
		}
		
		// class
		public function BlackFridayScheduler()
		{
			super(new ScheduleData(2014, 11, 28), new ScheduleData(2014, 11, 28));
		}
	}
}