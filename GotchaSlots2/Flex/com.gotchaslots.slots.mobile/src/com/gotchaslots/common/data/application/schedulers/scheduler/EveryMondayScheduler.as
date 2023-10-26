package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class EveryMondayScheduler extends BaseScheduler
	{
		// class
		public function EveryMondayScheduler()
		{
			super(new ScheduleData(Number.NaN, Number.NaN, Number.NaN, 2), new ScheduleData(Number.NaN, Number.NaN, Number.NaN, 2));
		}
	}
}