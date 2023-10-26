package com.gotchaslots.slots.data.machine.spline
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class SplinesData
	{
		// consts
		public static const BalancePoint:Point = new Point(107, 0);
		public static const LevelInfoPoint:Point = new Point(575, 0);
		public static const WinPoint:Point = new Point(400, 337 - 48);
		public static const CollectiblesPanelPoint:Point = new Point(14, 195 - 48);
		public static const FreeSpinsRibbonPoint:Point = new Point(100, 354 - 48);
		
		// members
		private var _splines:Dictionary;
		
		// class
		public function SplinesData()
		{
			_splines = new Dictionary();
		}
		public function Dispose():void
		{
			if (_splines)
			{
				for each (var spline:Object in _splines)
				{
					SplineData(spline).Dispose();
				}
				_splines = new Dictionary();;
				_splines = null;
			}
		}
		
		// methods
		public function GetSpline(point0:Point, point1:Point, point2:Point):SplineData
		{
			if (!point1)
			{
				point1 = new Point(Math.floor(Math.random() * 800), Math.floor(Math.random() * 306));
			}
			
			var key:String; 
			if (point1)
			{
				key = point0.x + "." + point0.y + ":" + point1.x + "." + point1.y + ":" + point2.x + "." + point2.y;
			}
			else
			{
				key = point0.x + "." + point0.y + ":0.0:" + point2.x + "." + point2.y;
			}
			
			if (_splines[key] == null)
			{
				_splines[key] = new SplineData(point0, point1, point2);
			}
			
			return SplineData(_splines[key]);
		}
	}
}