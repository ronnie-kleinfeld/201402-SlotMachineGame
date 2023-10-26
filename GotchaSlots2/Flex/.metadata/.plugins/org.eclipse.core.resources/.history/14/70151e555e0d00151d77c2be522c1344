package com.gotchaslots.common.data.application
{
	import com.gotchaslots.common.data.application.locale.L10NHandler;
	import com.gotchaslots.common.data.application.prices.PricesData;
	import com.gotchaslots.common.data.application.schedulers.SchedulersData;
	import com.gotchaslots.slots.data.machine.spline.SplinesData;
	import com.gotchaslots.slots.data.application.ticker.SlotsTickerData;

	public class CommonApplicationData
	{
		// members
		private var _l10n:L10NHandler;
		private var _prices:PricesData;
		private var _ticker:SlotsTickerData;
		private var _schedulers:SchedulersData;
		private var _splines:SplinesData;
		
		// properties
		public function get L10N():L10NHandler
		{
			return _l10n;
		}
		public function get Prices():PricesData
		{
			return _prices;
		}
		public function get Ticker():SlotsTickerData
		{
			return _ticker;
		}
		public function get Schedulers():SchedulersData
		{
			return _schedulers;
		}
		public function get Splines():SplinesData
		{
			return _splines;
		}
		
		public function get EnableJackpot():Boolean
		{
			return true;
		}
		public function get EnableTicker():Boolean
		{
			return true;
		}
		public function get FountainsLimit():int
		{
			return 30;
		}
		
		// class
		public function CommonApplicationData()
		{
			_l10n = new L10NHandler();
			_prices = new PricesData();
			_ticker = new SlotsTickerData();
			_schedulers = new SchedulersData();
			_splines = new SplinesData();
		}
	}
}