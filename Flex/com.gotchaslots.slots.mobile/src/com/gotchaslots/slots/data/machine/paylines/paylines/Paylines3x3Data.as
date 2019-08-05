package com.gotchaslots.slots.data.machine.paylines.paylines
{
	import com.gotchaslots.slots.assets.payboxes.payboxes3x3.PayboxesEmbed3x3;
	import com.gotchaslots.slots.assets.paylines.paylines3x3.LinesEmbed3x3;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.Payline3Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.resultMatrix.ResultMatrix3x3Data;
	
	public class Paylines3x3Data extends BasePaylinesData
	{
		// properties
		public override function get ResultMatrixClass():Class
		{
			return ResultMatrix3x3Data;
		}
		
		// class
		public function Paylines3x3Data(maxPaylines:int)
		{
			super(maxPaylines);
		}
		protected override function InitPayboxes():void
		{
			super.InitPayboxes();
			_payboxes[0] = new PayboxData(0, 82, 21, 208, 84, 0, 0);
			_payboxes[1] = new PayboxData(1, 296, 21, 208, 84, 0, 1);
			_payboxes[2] = new PayboxData(2, 510, 21, 208, 84, 0, 2);
			_payboxes[3] = new PayboxData(3, 82, 111, 208, 84, 1, 0);
			_payboxes[4] = new PayboxData(4, 296, 111, 208, 84, 1, 1);
			_payboxes[5] = new PayboxData(5, 510, 111, 208, 84, 1, 2);
			_payboxes[6] = new PayboxData(6, 82, 201, 208, 84, 2, 0);
			_payboxes[7] = new PayboxData(7, 296, 201, 208, 84, 2, 1);
			_payboxes[8] = new PayboxData(8, 510, 201, 208, 84, 2, 2);
		}
		protected override function InitPaylines(payboxes:Vector.<PayboxData>):void
		{
			super.InitPaylines(payboxes);
			_paylines.push(new Payline3Data(0, LinesEmbed3x3.Line_000, PayboxesEmbed3x3.Paybox_000, 0xCD9575, payboxes, 3, 4, 5));
			_paylines.push(new Payline3Data(1, LinesEmbed3x3.Line_001, PayboxesEmbed3x3.Paybox_001, 0xFDD9B5, payboxes, 0, 1, 2));
			_paylines.push(new Payline3Data(2, LinesEmbed3x3.Line_002, PayboxesEmbed3x3.Paybox_002, 0x78DBE2, payboxes, 6, 7, 8));
			_paylines.push(new Payline3Data(3, LinesEmbed3x3.Line_003, PayboxesEmbed3x3.Paybox_003, 0x87A96B, payboxes, 0, 4, 8));
			_paylines.push(new Payline3Data(4, LinesEmbed3x3.Line_004, PayboxesEmbed3x3.Paybox_004, 0xFFA474, payboxes, 6, 4, 2));
			_paylines.push(new Payline3Data(5, LinesEmbed3x3.Line_005, PayboxesEmbed3x3.Paybox_005, 0x9F8170, payboxes, 0, 1, 5));
			_paylines.push(new Payline3Data(6, LinesEmbed3x3.Line_006, PayboxesEmbed3x3.Paybox_006, 0xFD7C6E, payboxes, 0, 1, 8));
			_paylines.push(new Payline3Data(7, LinesEmbed3x3.Line_007, PayboxesEmbed3x3.Paybox_007, 0x1F75FE, payboxes, 0, 4, 2));
			_paylines.push(new Payline3Data(8, LinesEmbed3x3.Line_008, PayboxesEmbed3x3.Paybox_008, 0xADADD6, payboxes, 0, 4, 5));
			_paylines.push(new Payline3Data(9, LinesEmbed3x3.Line_009, PayboxesEmbed3x3.Paybox_009, 0x7366BD, payboxes, 0, 7, 2));
			_paylines.push(new Payline3Data(10, LinesEmbed3x3.Line_010, PayboxesEmbed3x3.Paybox_010, 0xDE5D83, payboxes, 0, 7, 5));
			_paylines.push(new Payline3Data(11, LinesEmbed3x3.Line_011, PayboxesEmbed3x3.Paybox_011, 0xCB4154, payboxes, 0, 7, 8));
			_paylines.push(new Payline3Data(12, LinesEmbed3x3.Line_012, PayboxesEmbed3x3.Paybox_012, 0xB4674D, payboxes, 3, 1, 2));
			_paylines.push(new Payline3Data(13, LinesEmbed3x3.Line_013, PayboxesEmbed3x3.Paybox_013, 0xFF7F49, payboxes, 3, 1, 5));
			_paylines.push(new Payline3Data(14, LinesEmbed3x3.Line_014, PayboxesEmbed3x3.Paybox_014, 0xEA7E5D, payboxes, 3, 1, 8));
			_paylines.push(new Payline3Data(15, LinesEmbed3x3.Line_015, PayboxesEmbed3x3.Paybox_015, 0xFFFF99, payboxes, 3, 4, 2));
			_paylines.push(new Payline3Data(16, LinesEmbed3x3.Line_016, PayboxesEmbed3x3.Paybox_016, 0x1CD3A2, payboxes, 3, 4, 8));
			_paylines.push(new Payline3Data(17, LinesEmbed3x3.Line_017, PayboxesEmbed3x3.Paybox_017, 0xFFAACC, payboxes, 3, 7, 2));
			_paylines.push(new Payline3Data(18, LinesEmbed3x3.Line_018, PayboxesEmbed3x3.Paybox_018, 0x1DACD6, payboxes, 3, 7, 5));
			_paylines.push(new Payline3Data(19, LinesEmbed3x3.Line_019, PayboxesEmbed3x3.Paybox_019, 0xBC5D58, payboxes, 3, 7, 8));
			_paylines.push(new Payline3Data(20, LinesEmbed3x3.Line_020, PayboxesEmbed3x3.Paybox_020, 0xDD9475, payboxes, 6, 1, 2));
			_paylines.push(new Payline3Data(21, LinesEmbed3x3.Line_021, PayboxesEmbed3x3.Paybox_021, 0x9ACEEB, payboxes, 6, 1, 5));
			_paylines.push(new Payline3Data(22, LinesEmbed3x3.Line_022, PayboxesEmbed3x3.Paybox_022, 0xFFBCD9, payboxes, 6, 1, 8));
			_paylines.push(new Payline3Data(23, LinesEmbed3x3.Line_023, PayboxesEmbed3x3.Paybox_023, 0xFDDB6D, payboxes, 6, 4, 5));
			_paylines.push(new Payline3Data(24, LinesEmbed3x3.Line_024, PayboxesEmbed3x3.Paybox_024, 0x2B6CC4, payboxes, 6, 4, 8));
			_paylines.push(new Payline3Data(25, LinesEmbed3x3.Line_025, PayboxesEmbed3x3.Paybox_025, 0x6E5160, payboxes, 6, 7, 2));
			_paylines.push(new Payline3Data(26, LinesEmbed3x3.Line_026, PayboxesEmbed3x3.Paybox_026, 0x1DF914, payboxes, 6, 7, 5));
		}
		protected override function InitHorizontalPaylines(payboxes:Vector.<PayboxData>):void
		{
			super.InitHorizontalPaylines(payboxes);
			_horizontalPaylines.push(new Payline3Data(0, LinesEmbed3x3.Line_000, PayboxesEmbed3x3.Paybox_000, 0xCD9575, payboxes, 3, 4, 5));
			_horizontalPaylines.push(new Payline3Data(1, LinesEmbed3x3.Line_001, PayboxesEmbed3x3.Paybox_001, 0xFDD9B5, payboxes, 0, 1, 2));
			_horizontalPaylines.push(new Payline3Data(2, LinesEmbed3x3.Line_002, PayboxesEmbed3x3.Paybox_002, 0x78DBE2, payboxes, 6, 7, 8));
		}
	}
}