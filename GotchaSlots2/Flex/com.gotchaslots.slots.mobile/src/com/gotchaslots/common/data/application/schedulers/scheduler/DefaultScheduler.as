package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class DefaultScheduler extends BaseScheduler
	{
		// class
		public function DefaultScheduler()
		{
			super(new ScheduleData(), new ScheduleData());
		}
	}
}