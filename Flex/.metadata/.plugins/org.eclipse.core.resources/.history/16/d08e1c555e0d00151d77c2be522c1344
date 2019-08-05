package com.gotchaslots.common.data.application.schedulers
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.schedulers.scheduler.AprilFoolsDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.BlackFridayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.BoxingDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ChristmasScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ColumbusDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.CyberMondayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.EasterScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.EveryMondayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.EverySundayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FifteenMinutesBeforeEndOfDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FifteenMinutesBeforeNoonScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FirstDayOfAutumn;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FirstDayOfSpring;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FirstDayOfSummer;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FirstDayOfTheMonthScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FirstDayOfWinter;
	import com.gotchaslots.common.data.application.schedulers.scheduler.FourDaysBeforeEndOfTheMonth;
	import com.gotchaslots.common.data.application.schedulers.scheduler.HalloweenScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.IndependenceDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.MothersDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.NewYearScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ThanksGivingDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ThirtyMinutesFollowingTenScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ValentinesScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	
	public class SchedulersData
	{
		// members
		private var _schedulers:Vector.<BaseScheduler>;
		
		// properteis
		public function get Schedulers():Vector.<BaseScheduler>
		{
			return _schedulers;
		}
		
		// class
		public function SchedulersData()
		{
			_schedulers = new Vector.<BaseScheduler>();
			
			_schedulers.push(new AprilFoolsDayScheduler());
			_schedulers.push(new BlackFridayScheduler());
			_schedulers.push(new BoxingDayScheduler());
			_schedulers.push(new ChristmasScheduler());
			_schedulers.push(new ColumbusDayScheduler());
			_schedulers.push(new CyberMondayScheduler());
			_schedulers.push(new EasterScheduler());
			_schedulers.push(new EveryMondayScheduler());
			_schedulers.push(new EverySundayScheduler());
			_schedulers.push(new FifteenMinutesBeforeEndOfDayScheduler());
			_schedulers.push(new FifteenMinutesBeforeNoonScheduler());
			_schedulers.push(new FirstDayOfAutumn());
			_schedulers.push(new FirstDayOfSpring());
			_schedulers.push(new FirstDayOfSummer());
			_schedulers.push(new FirstDayOfTheMonthScheduler());
			_schedulers.push(new FirstDayOfWinter());
			_schedulers.push(new FourDaysBeforeEndOfTheMonth());
			_schedulers.push(new HalloweenScheduler());
			_schedulers.push(new IndependenceDayScheduler());
			_schedulers.push(new MothersDayScheduler());
			_schedulers.push(new NewYearScheduler());
			_schedulers.push(new ThanksGivingDayScheduler());
			_schedulers.push(new ThirtyMinutesFollowingTenScheduler());
			_schedulers.push(new ValentinesScheduler());
		}
		public function Dispose():void
		{
			while (_schedulers && _schedulers.length > 0)
			{
				var scheduler:BaseScheduler = _schedulers.pop();
				scheduler.Dispose();
				scheduler = null;
			}
			_schedulers = null;
		}
		
		// methods
		public function GetCurrentSchedule():BaseScheduler
		{
			var current:Date = Main.Instance.XServices.InternetTime.CurrentLocalDateTime;
			
			for (var i:int = 0; i < _schedulers.length; i++)
			{
				if (_schedulers[i].IsInRange(current))
				{
					return _schedulers[i];
				}
			}
			
			return null;
		}
	}
}