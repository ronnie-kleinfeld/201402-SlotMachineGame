package com.gotchaslots.slots.data.machine.paylines.paylines.base
{
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	import flash.geom.Rectangle;
	
	public class BasePaylinesData extends EventDispatcherEx
	{
		// members
		protected var _paylines:Vector.<BasePaylineData>;
		protected var _horizontalPaylines:Vector.<BasePaylineData>;
		protected var _payboxes:Vector.<PayboxData>;
		
		// properties
		public function get Paylines():Vector.<BasePaylineData>
		{
			return _paylines;
		}
		public function get HorizontalPaylines():Vector.<BasePaylineData>
		{
			return _horizontalPaylines;
		}
		public function get Payboxes():Vector.<PayboxData>
		{
			return _payboxes;
		}
		
		public function get RowsCount():int
		{
			return _payboxes.length / Paylines[0].ColumnsCount;
		}
		
		public function get MaskRectangle():Rectangle
		{
			var lastPayboxes:PayboxData = _payboxes[_payboxes.length - 1];
			return new Rectangle(_payboxes[0].Rect.x, _payboxes[0].Rect.y,
				lastPayboxes.Rect.x + lastPayboxes.Rect.width - _payboxes[0].Rect.x,
				lastPayboxes.Rect.y + lastPayboxes.Rect.height - _payboxes[0].Rect.y);
		}
		
		public function get ResultMatrixClass():Class
		{
			throw new MustOverrideError();
		}
		
		public function get LinesCount():int
		{
			return _paylines.length;
		}
		
		// class
		public function BasePaylinesData(maxPaylines:int)
		{
			super();
			
			InitPayboxes();
			InitPaylines(_payboxes);
			InitHorizontalPaylines(_payboxes);
			RemovePaylines(maxPaylines);
		}
		protected function InitPayboxes():void
		{
			_payboxes = new Vector.<PayboxData>();
		}
		protected function InitPaylines(payboxes:Vector.<PayboxData>):void
		{
			_paylines = new Vector.<BasePaylineData>();
		}
		protected function InitHorizontalPaylines(payboxes:Vector.<PayboxData>):void
		{
			_horizontalPaylines = new Vector.<BasePaylineData>();
		}
		private function RemovePaylines(maxPaylines:int):void
		{
			while (_paylines.length > maxPaylines)
			{
				var payline:BasePaylineData = _paylines.pop();
				payline.Dispose();
				payline = null;
			}
		}
		public override function Dispose():void
		{
			var payline:BasePaylineData;
			while (_paylines && _paylines.length > 0)
			{
				payline = _paylines.pop();
				payline.Dispose();
				payline = null;
			}
			_paylines = null;
			
			while (_horizontalPaylines && _horizontalPaylines.length > 0)
			{
				payline = _horizontalPaylines.pop();
				payline.Dispose();
				payline = null;
			}
			_horizontalPaylines = null;
			
			while (_payboxes && _payboxes.length > 0)
			{
				var paybox:PayboxData = _payboxes.pop();
				paybox.Dispose();
				paybox = null;
			}
			_payboxes = null;
		}
		
		// methods
		public function LocationByPayBoxID(id:int):Rectangle
		{
			return PayboxData(_payboxes[id]).Rect;
		}
	}
}