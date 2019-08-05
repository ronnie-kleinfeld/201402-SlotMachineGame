package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class FourDaysBeforeEndOfTheMonth extends BaseScheduler
	{
		// class
		public function FourDaysBeforeEndOfTheMonth()
		{
			super(new ScheduleData(Number.NaN, Number.NaN, 27), new ScheduleData(Number.NaN, Number.NaN, 31));
		}
	}
}