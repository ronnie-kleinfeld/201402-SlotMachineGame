package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class EverySundayScheduler extends BaseScheduler
	{
		// class
		public function EverySundayScheduler()
		{
			super(new ScheduleData(Number.NaN, Number.NaN, Number.NaN, 1), new ScheduleData(Number.NaN, Number.NaN, Number.NaN, 1));
		}
	}
}