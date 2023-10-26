package com.gotchaslots.common.data.application.prices
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.schedulers.scheduler.AprilFoolsDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.BlackFridayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.BoxingDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ChristmasScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.ColumbusDayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.CyberMondayScheduler;
	import com.gotchaslots.common.data.application.schedulers.scheduler.DefaultScheduler;
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
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	public class PricesData extends EventDispatcherEx
	{
		// memebrs
		private var _pricesOptions:Vector.<PriceOptionsData>;
		private var _defaultPriceOptions:PriceOptionsData;
		
		// properties
		private function get AddFifteenMinutesBeforeEndOfDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 30000));priceOptions.push(new PriceOptionData(1, "33% Sale", ProductID.USD499, 226000));priceOptions.push(new PriceOptionData(2, "29% Sale", ProductID.USD999, 430000));priceOptions.push(new PriceOptionData(3, "28% Sale", ProductID.USD1999, 850000));return new PriceOptionsData(9, "15 minutes to Midnight", priceOptions, new FifteenMinutesBeforeEndOfDayScheduler(), true);}
		private function get AddFifteenMinutesBeforeNoonPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 140000));priceOptions.push(new PriceOptionData(1, "23% off", ProductID.USD1999, 3700000));priceOptions.push(new PriceOptionData(2, "29% off", ProductID.USD4999, 10000000));priceOptions.push(new PriceOptionData(3, "29% off", ProductID.USD9999, 20000000));return new PriceOptionsData(10, "15 minutes to Noon", priceOptions, new FifteenMinutesBeforeNoonScheduler(), true);}
		private function get AddThirtyMinutesFollowingTenPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 72500));priceOptions.push(new PriceOptionData(1, "9409 Chips for Free", ProductID.USD999, 741000));priceOptions.push(new PriceOptionData(2, "17258 Chips for Free", ProductID.USD1999, 1500000));priceOptions.push(new PriceOptionData(3, "648874 Chips for Free", ProductID.USD4999, 4400000));return new PriceOptionsData(22, "22:00 - 22:30", priceOptions, new ThirtyMinutesFollowingTenScheduler(), true);}
		private function get AddAprilFoolsDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 18000));priceOptions.push(new PriceOptionData(1, "45272 Chips for Free", ProductID.USD499, 136000));priceOptions.push(new PriceOptionData(2, "17727 Chips for Free", ProductID.USD999, 290000));priceOptions.push(new PriceOptionData(3, "19709 Chips for Free", ProductID.USD1999, 600000));return new PriceOptionsData(0, "April Fools Sale", priceOptions, new AprilFoolsDayScheduler(), true);}
		private function get AddBlackFridayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 40000));priceOptions.push(new PriceOptionData(1, "16% Sale", ProductID.USD499, 241000));priceOptions.push(new PriceOptionData(2, "8% Sale", ProductID.USD999, 440000));priceOptions.push(new PriceOptionData(3, "32% Sale", ProductID.USD1999, 1200000));return new PriceOptionsData(1, "Black Friday", priceOptions, new BlackFridayScheduler(), true);}
		private function get AddBoxingDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 45000));priceOptions.push(new PriceOptionData(1, "16% Sale", ProductID.USD499, 272000));priceOptions.push(new PriceOptionData(2, "7% Sale", ProductID.USD999, 490000));priceOptions.push(new PriceOptionData(3, "9% Sale", ProductID.USD1999, 1000000));return new PriceOptionsData(2, "Boxing Day", priceOptions, new BoxingDayScheduler(), true);}
		private function get AddChristmasPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 25000));priceOptions.push(new PriceOptionData(1, "22% Sale", ProductID.USD499, 163000));priceOptions.push(new PriceOptionData(2, "23% Sale", ProductID.USD999, 330000));priceOptions.push(new PriceOptionData(3, "24% Sale", ProductID.USD1999, 670000));return new PriceOptionsData(3, "Xmas Sale", priceOptions, new ChristmasScheduler(), true);}
		private function get AddColumbusDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 110000));priceOptions.push(new PriceOptionData(1, "17% off", ProductID.USD1999, 2700000));priceOptions.push(new PriceOptionData(2, "20% off", ProductID.USD4999, 7000000));priceOptions.push(new PriceOptionData(3, "25% off", ProductID.USD9999, 15000000));return new PriceOptionsData(4, "Columbus Day", priceOptions, new ColumbusDayScheduler(), true);}
		private function get AddCyberMondayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 120000));priceOptions.push(new PriceOptionData(1, "19% Sale", ProductID.USD999, 1500000));priceOptions.push(new PriceOptionData(2, "28% Sale", ProductID.USD1999, 3400000));priceOptions.push(new PriceOptionData(3, "32% Sale", ProductID.USD4999, 9000000));return new PriceOptionsData(5, "Cyber Monday", priceOptions, new CyberMondayScheduler(), true);}
		private function get AddEasterPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 22000));priceOptions.push(new PriceOptionData(1, "17% off", ProductID.USD499, 134000));priceOptions.push(new PriceOptionData(2, "17% off", ProductID.USD999, 270000));priceOptions.push(new PriceOptionData(3, "25% off", ProductID.USD1999, 600000));return new PriceOptionsData(6, "Easter Sale", priceOptions, new EasterScheduler(), true);}
		private function get AddHalloweenPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 55000));priceOptions.push(new PriceOptionData(1, "56000 Chips for Free", ProductID.USD999, 611000));priceOptions.push(new PriceOptionData(2, "377388 Chips for Free", ProductID.USD1999, 1600000));priceOptions.push(new PriceOptionData(3, "498799 Chips for Free", ProductID.USD4999, 4500000));return new PriceOptionsData(17, "Halloween Sale", priceOptions, new HalloweenScheduler(), true);}
		private function get AddIndependenceDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 20000));priceOptions.push(new PriceOptionData(1, "24% Sale", ProductID.USD199, 53000));priceOptions.push(new PriceOptionData(2, "32% Sale", ProductID.USD499, 150000));priceOptions.push(new PriceOptionData(3, "34% Sale", ProductID.USD999, 310000));return new PriceOptionsData(18, "Independece Day", priceOptions, new IndependenceDayScheduler(), true);}
		private function get AddMothersDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 80000));priceOptions.push(new PriceOptionData(1, "23% Sale", ProductID.USD999, 1050000));priceOptions.push(new PriceOptionData(2, "19% Sale", ProductID.USD1999, 2000000));priceOptions.push(new PriceOptionData(3, "10% Sale", ProductID.USD4999, 4500000));return new PriceOptionsData(19, "Mother Day", priceOptions, new MothersDayScheduler(), true);}
		private function get AddNewYearPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 70000));priceOptions.push(new PriceOptionData(1, "23% off", ProductID.USD999, 920000));priceOptions.push(new PriceOptionData(2, "25% off", ProductID.USD1999, 1900000));priceOptions.push(new PriceOptionData(3, "29% off", ProductID.USD4999, 5000000));return new PriceOptionsData(20, "New Year", priceOptions, new NewYearScheduler(), true);}
		private function get AddThanksGivingDayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 24000));priceOptions.push(new PriceOptionData(1, "33% off", ProductID.USD499, 182000));priceOptions.push(new PriceOptionData(2, "34% off", ProductID.USD999, 370000));priceOptions.push(new PriceOptionData(3, "39% off", ProductID.USD1999, 800000));return new PriceOptionsData(21, "Thanks Giving Day", priceOptions, new ThanksGivingDayScheduler(), true);}
		private function get AddValentinesPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 25000));priceOptions.push(new PriceOptionData(1, "23% Sale", ProductID.USD499, 164000));priceOptions.push(new PriceOptionData(2, "33% Sale", ProductID.USD999, 380000));priceOptions.push(new PriceOptionData(3, "36% Sale", ProductID.USD1999, 800000));return new PriceOptionsData(23, "Lovers Sale", priceOptions, new ValentinesScheduler(), true);}
		private function get AddFirstDayOfAutumn():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 15000));priceOptions.push(new PriceOptionData(1, "29% Sale", ProductID.USD199, 43000));priceOptions.push(new PriceOptionData(2, "31% Sale", ProductID.USD999, 220000));priceOptions.push(new PriceOptionData(3, "36% Sale", ProductID.USD4999, 1200000));return new PriceOptionsData(11, "Automn", priceOptions, new FirstDayOfAutumn(), true);}
		private function get AddFirstDayOfSpring():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 18000));priceOptions.push(new PriceOptionData(1, "29% off", ProductID.USD199, 51000));priceOptions.push(new PriceOptionData(2, "30% off", ProductID.USD999, 260000));priceOptions.push(new PriceOptionData(3, "35% off", ProductID.USD4999, 1400000));return new PriceOptionsData(12, "Spring", priceOptions, new FirstDayOfSpring(), true);}
		private function get AddFirstDayOfSummer():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 21000));priceOptions.push(new PriceOptionData(1, "29% off", ProductID.USD199, 60000));priceOptions.push(new PriceOptionData(2, "35% off", ProductID.USD999, 330000));priceOptions.push(new PriceOptionData(3, "46% off", ProductID.USD4999, 2000000));return new PriceOptionsData(13, "Hot Season .. Hot Sale", priceOptions, new FirstDayOfSummer(), true);}
		private function get AddFirstDayOfWinter():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 22000));priceOptions.push(new PriceOptionData(1, "23% off", ProductID.USD199, 58000));priceOptions.push(new PriceOptionData(2, "17% off", ProductID.USD999, 270000));priceOptions.push(new PriceOptionData(3, "20% off", ProductID.USD4999, 1400000));return new PriceOptionsData(15, "Wintertime", priceOptions, new FirstDayOfWinter(), true);}
		private function get AddEveryMondayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 150000));priceOptions.push(new PriceOptionData(1, "971212 Chips for Free", ProductID.USD1999, 4000000));priceOptions.push(new PriceOptionData(2, "996998 Chips for Free", ProductID.USD4999, 11000000));priceOptions.push(new PriceOptionData(3, "2997799 Chips for Free", ProductID.USD9999, 25000000));return new PriceOptionsData(7, "Monday Sale", priceOptions, new EveryMondayScheduler(), true);}
		private function get AddEverySundayPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 25000));priceOptions.push(new PriceOptionData(1, "29% Sale", ProductID.USD199, 71000));priceOptions.push(new PriceOptionData(2, "6% Sale", ProductID.USD499, 135000));priceOptions.push(new PriceOptionData(3, "6% Sale", ProductID.USD999, 270000));return new PriceOptionsData(8, "Sunday Sale", priceOptions, new EverySundayScheduler(), true);}
		private function get AddFirstDayOfTheMonthPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 30000));priceOptions.push(new PriceOptionData(1, "17% off", ProductID.USD199, 73000));priceOptions.push(new PriceOptionData(2, "11% off", ProductID.USD499, 170000));priceOptions.push(new PriceOptionData(3, "32% off", ProductID.USD999, 450000));return new PriceOptionsData(14, "1st day of the Month", priceOptions, new FirstDayOfTheMonthScheduler(), true);}
		private function get AddFourDaysBeforeEndOfTheMonth():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 20000));priceOptions.push(new PriceOptionData(1, "29% off", ProductID.USD199, 57000));priceOptions.push(new PriceOptionData(2, "36% off", ProductID.USD499, 160000));priceOptions.push(new PriceOptionData(3, "25% off", ProductID.USD999, 270000));return new PriceOptionsData(16, "End of the month", priceOptions, new FourDaysBeforeEndOfTheMonth(), false);}
		private function get AddDefaultPriceOptions():PriceOptionsData{var priceOptions:Vector.<PriceOptionData> = new Vector.<PriceOptionData>();priceOptions.push(new PriceOptionData(0, "", ProductID.USD99, 15000));priceOptions.push(new PriceOptionData(1, "34% Sale", ProductID.USD199, 46000));priceOptions.push(new PriceOptionData(2, "24% Sale", ProductID.USD499, 100000));priceOptions.push(new PriceOptionData(3, "20% Sale", ProductID.USD999, 190000));return new PriceOptionsData(99, "Buy Chips", priceOptions, new DefaultScheduler(), false);}
		
		// class
		public function PricesData()
		{
			_pricesOptions = new Vector.<PriceOptionsData>();
			_pricesOptions.push(AddFifteenMinutesBeforeEndOfDayPriceOptions);
			_pricesOptions.push(AddFifteenMinutesBeforeNoonPriceOptions);
			_pricesOptions.push(AddThirtyMinutesFollowingTenPriceOptions);
			_pricesOptions.push(AddAprilFoolsDayPriceOptions);
			_pricesOptions.push(AddBlackFridayPriceOptions);
			_pricesOptions.push(AddBoxingDayPriceOptions);
			_pricesOptions.push(AddChristmasPriceOptions);
			_pricesOptions.push(AddColumbusDayPriceOptions);
			_pricesOptions.push(AddCyberMondayPriceOptions);
			_pricesOptions.push(AddEasterPriceOptions);
			_pricesOptions.push(AddHalloweenPriceOptions);
			_pricesOptions.push(AddIndependenceDayPriceOptions);
			_pricesOptions.push(AddMothersDayPriceOptions);
			_pricesOptions.push(AddNewYearPriceOptions);
			_pricesOptions.push(AddThanksGivingDayPriceOptions);
			_pricesOptions.push(AddValentinesPriceOptions);
			_pricesOptions.push(AddFirstDayOfAutumn);
			_pricesOptions.push(AddFirstDayOfSpring);
			_pricesOptions.push(AddFirstDayOfSummer);
			_pricesOptions.push(AddFirstDayOfWinter);
			_pricesOptions.push(AddEveryMondayPriceOptions);
			_pricesOptions.push(AddEverySundayPriceOptions);
			_pricesOptions.push(AddFirstDayOfTheMonthPriceOptions);
			_pricesOptions.push(AddFourDaysBeforeEndOfTheMonth);
			
			_defaultPriceOptions = AddDefaultPriceOptions;
			_pricesOptions.push(_defaultPriceOptions);
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			while (_pricesOptions && _pricesOptions.length > 0)
			{
				var priceOptions:PriceOptionsData = _pricesOptions.pop();
				priceOptions.Dispose();
				priceOptions = null;
			}
			_pricesOptions = null;
			
			if (_defaultPriceOptions)
			{
				_defaultPriceOptions.Dispose();
				_defaultPriceOptions = null;
			}
		}
		
		// methods
		public function GetPriceOptions(onlyByCurrentMS:Boolean):PriceOptionsData
		{
			if (onlyByCurrentMS)
			{
				priceOptions = _defaultPriceOptions;
			}
			else
			{
				var priceOptions:PriceOptionsData = _defaultPriceOptions;
				
				for (var i:int = 0; i < _pricesOptions.length; i++)
				{
					if (_pricesOptions[i].Scheduler.IsInRange(Main.Instance.XServices.InternetTime.CurrentLocalDateTime))
					{
						priceOptions = _pricesOptions[i];
						break;
					}
				}
			}
			
			return priceOptions;
		}
	}
}