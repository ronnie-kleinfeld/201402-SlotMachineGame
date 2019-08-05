package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;

	public class FifteenMinutesBeforeEndOfDayScheduler extends BaseScheduler
	{
		// class
		public function FifteenMinutesBeforeEndOfDayScheduler()
		{
			super(new ScheduleData(Number.NaN, Number.NaN, Number.NaN, Number.NaN, 23, 45), new ScheduleData(Number.NaN, Number.NaN, Number.NaN, Number.NaN, 23, 59));
		}
	}
}