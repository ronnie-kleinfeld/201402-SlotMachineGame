package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.assets.hud.frame.HudFrameEmbed;
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class ThanksGivingDayScheduler extends BaseScheduler
	{
		// properties
		public override function get FrameClass():Class
		{
			return HudFrameEmbed.ThanksgivingDay;
		}
		
		// class
		public function ThanksGivingDayScheduler()
		{
			super(new ScheduleData(2014, 11, 26), new ScheduleData(2014, 11, 27));
		}
	}
}