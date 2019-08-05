package com.gotchaslots.common.data.application.schedulers.scheduler
{
	import com.gotchaslots.common.data.application.schedulers.ScheduleData;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;

	public class BoxingDayScheduler extends BaseScheduler
	{
		// class
		public function BoxingDayScheduler()
		{
			super(new ScheduleData(Number.NaN, 12, 26), new ScheduleData(Number.NaN, 12, 26));
		}
	}
}