package com.gotchaslots.slots.data.machine.paylines.paylines
{
	import com.gotchaslots.slots.assets.payboxes.payboxes5x4.PayboxesEmbed5x4;
	import com.gotchaslots.slots.assets.paylines.paylines5x4.LinesEmbed5x4;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.Payline5Data;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.resultMatrix.ResultMatrix5x4Data;
	
	public class Paylines5x4Data extends BasePaylinesData
	{
		// properties
		public override function get ResultMatrixClass():Class
		{
			return ResultMatrix5x4Data;
		}
		
		// class
		public function Paylines5x4Data(maxPaylines:int)
		{
			super(maxPaylines);
		}
		protected override function InitPayboxes():void
		{
			super.InitPayboxes();
			_payboxes[0] = new PayboxData(0, 48, 22, 136, 61, 0, 0);
			_payboxes[1] = new PayboxData(1, 190, 22, 136, 61, 0, 1);
			_payboxes[2] = new PayboxData(2, 332, 22, 136, 61, 0, 2);
			_payboxes[3] = new PayboxData(3, 474, 22, 136, 61, 0, 3);
			_payboxes[4] = new PayboxData(4, 616, 22, 136, 61, 0, 4);
			_payboxes[5] = new PayboxData(5, 48, 89, 136, 61, 1, 0);
			_payboxes[6] = new PayboxData(6, 190, 89, 136, 61, 1, 1);
			_payboxes[7] = new PayboxData(7, 332, 89, 136, 61, 1, 2);
			_payboxes[8] = new PayboxData(8, 474, 89, 136, 61, 1, 3);
			_payboxes[9] = new PayboxData(9, 616, 89, 136, 61, 1, 4);
			_payboxes[10] = new PayboxData(10, 48, 156, 136, 61, 2, 0);
			_payboxes[11] = new PayboxData(11, 190, 156, 136, 61, 2, 1);
			_payboxes[12] = new PayboxData(12, 332, 156, 136, 61, 2, 2);
			_payboxes[13] = new PayboxData(13, 474, 156, 136, 61, 2, 3);
			_payboxes[14] = new PayboxData(14, 616, 156, 136, 61, 2, 4);
			_payboxes[15] = new PayboxData(15, 48, 223, 136, 61, 3, 0);
			_payboxes[16] = new PayboxData(16, 190, 223, 136, 61, 3, 1);
			_payboxes[17] = new PayboxData(17, 332, 223, 136, 61, 3, 2);
			_payboxes[18] = new PayboxData(18, 474, 223, 136, 61, 3, 3);
			_payboxes[19] = new PayboxData(19, 616, 223, 136, 61, 3, 4);
		}
		protected override function InitPaylines(payboxes:Vector.<PayboxData>):void
		{
			super.InitPaylines(payboxes);
			_paylines.push(new Payline5Data(0, LinesEmbed5x4.Line_000, PayboxesEmbed5x4.Paybox_000, 0xCD9575, payboxes, 0, 1, 2, 3, 4));
			_paylines.push(new Payline5Data(1, LinesEmbed5x4.Line_001, PayboxesEmbed5x4.Paybox_001, 0xFDD9B5, payboxes, 5, 6, 7, 8, 9));
			_paylines.push(new Payline5Data(2, LinesEmbed5x4.Line_002, PayboxesEmbed5x4.Paybox_002, 0x78DBE2, payboxes, 10, 11, 12, 13, 14));
			_paylines.push(new Payline5Data(3, LinesEmbed5x4.Line_003, PayboxesEmbed5x4.Paybox_003, 0x87A96B, payboxes, 15, 16, 17, 18, 19));
			_paylines.push(new Payline5Data(4, LinesEmbed5x4.Line_004, PayboxesEmbed5x4.Paybox_004, 0xFFA474, payboxes, 0, 6, 12, 8, 4));
			_paylines.push(new Payline5Data(5, LinesEmbed5x4.Line_005, PayboxesEmbed5x4.Paybox_005, 0x9F8170, payboxes, 15, 11, 7, 13, 19));
			_paylines.push(new Payline5Data(6, LinesEmbed5x4.Line_006, PayboxesEmbed5x4.Paybox_006, 0xFD7C6E, payboxes, 5, 11, 17, 13, 9));
			_paylines.push(new Payline5Data(7, LinesEmbed5x4.Line_007, PayboxesEmbed5x4.Paybox_007, 0x1F75FE, payboxes, 10, 6, 2, 8, 14));
			_paylines.push(new Payline5Data(8, LinesEmbed5x4.Line_008, PayboxesEmbed5x4.Paybox_008, 0xADADD6, payboxes, 5, 1, 2, 3, 9));
			_paylines.push(new Payline5Data(9, LinesEmbed5x4.Line_009, PayboxesEmbed5x4.Paybox_009, 0x7366BD, payboxes, 10, 16, 17, 18, 14));
			_paylines.push(new Payline5Data(10, LinesEmbed5x4.Line_010, PayboxesEmbed5x4.Paybox_010, 0xDE5D83, payboxes, 0, 6, 7, 8, 4));
			_paylines.push(new Payline5Data(11, LinesEmbed5x4.Line_011, PayboxesEmbed5x4.Paybox_011, 0xCB4154, payboxes, 15, 11, 12, 13, 19));
			_paylines.push(new Payline5Data(12, LinesEmbed5x4.Line_012, PayboxesEmbed5x4.Paybox_012, 0xB4674D, payboxes, 0, 6, 2, 8, 4));
			_paylines.push(new Payline5Data(13, LinesEmbed5x4.Line_013, PayboxesEmbed5x4.Paybox_013, 0xFF7F49, payboxes, 15, 11, 17, 13, 19));
			_paylines.push(new Payline5Data(14, LinesEmbed5x4.Line_014, PayboxesEmbed5x4.Paybox_014, 0xEA7E5D, payboxes, 5, 1, 7, 3, 9));
			_paylines.push(new Payline5Data(15, LinesEmbed5x4.Line_015, PayboxesEmbed5x4.Paybox_015, 0xFFFF99, payboxes, 10, 16, 12, 18, 14));
			_paylines.push(new Payline5Data(16, LinesEmbed5x4.Line_016, PayboxesEmbed5x4.Paybox_016, 0x1CD3A2, payboxes, 0, 1, 7, 3, 4));
			_paylines.push(new Payline5Data(17, LinesEmbed5x4.Line_017, PayboxesEmbed5x4.Paybox_017, 0xFFAACC, payboxes, 15, 16, 12, 18, 19));
			_paylines.push(new Payline5Data(18, LinesEmbed5x4.Line_018, PayboxesEmbed5x4.Paybox_018, 0x1DACD6, payboxes, 5, 6, 2, 8, 9));
			_paylines.push(new Payline5Data(19, LinesEmbed5x4.Line_019, PayboxesEmbed5x4.Paybox_019, 0xBC5D58, payboxes, 10, 11, 17, 13, 14));
			_paylines.push(new Payline5Data(20, LinesEmbed5x4.Line_020, PayboxesEmbed5x4.Paybox_020, 0xDD9475, payboxes, 0, 1, 2, 8, 14));
			_paylines.push(new Payline5Data(21, LinesEmbed5x4.Line_021, PayboxesEmbed5x4.Paybox_021, 0x9ACEEB, payboxes, 15, 16, 17, 13, 9));
			_paylines.push(new Payline5Data(22, LinesEmbed5x4.Line_022, PayboxesEmbed5x4.Paybox_022, 0xFFBCD9, payboxes, 10, 6, 2, 3, 4));
			_paylines.push(new Payline5Data(23, LinesEmbed5x4.Line_023, PayboxesEmbed5x4.Paybox_023, 0xFDDB6D, payboxes, 5, 11, 17, 18, 19));
			_paylines.push(new Payline5Data(24, LinesEmbed5x4.Line_024, PayboxesEmbed5x4.Paybox_024, 0x2B6CC4, payboxes, 10, 11, 12, 8, 4));
			_paylines.push(new Payline5Data(25, LinesEmbed5x4.Line_025, PayboxesEmbed5x4.Paybox_025, 0x6E5160, payboxes, 5, 6, 7, 13, 19));
			_paylines.push(new Payline5Data(26, LinesEmbed5x4.Line_026, PayboxesEmbed5x4.Paybox_026, 0x1DF914, payboxes, 15, 11, 7, 8, 9));
			_paylines.push(new Payline5Data(27, LinesEmbed5x4.Line_027, PayboxesEmbed5x4.Paybox_027, 0x71BC78, payboxes, 0, 6, 12, 13, 14));
			_paylines.push(new Payline5Data(28, LinesEmbed5x4.Line_028, PayboxesEmbed5x4.Paybox_028, 0xC364C5, payboxes, 0, 1, 7, 13, 14));
			_paylines.push(new Payline5Data(29, LinesEmbed5x4.Line_029, PayboxesEmbed5x4.Paybox_029, 0xCC6666, payboxes, 15, 16, 12, 8, 9));
			_paylines.push(new Payline5Data(30, LinesEmbed5x4.Line_030, PayboxesEmbed5x4.Paybox_030, 0xE7C697, payboxes, 10, 11, 7, 3, 4));
			_paylines.push(new Payline5Data(31, LinesEmbed5x4.Line_031, PayboxesEmbed5x4.Paybox_031, 0xFCD975, payboxes, 5, 6, 12, 18, 19));
			_paylines.push(new Payline5Data(32, LinesEmbed5x4.Line_032, PayboxesEmbed5x4.Paybox_032, 0xA8E4A0, payboxes, 0, 1, 2, 3, 9));
			_paylines.push(new Payline5Data(33, LinesEmbed5x4.Line_033, PayboxesEmbed5x4.Paybox_033, 0x95918C, payboxes, 15, 16, 17, 18, 14));
			_paylines.push(new Payline5Data(34, LinesEmbed5x4.Line_034, PayboxesEmbed5x4.Paybox_034, 0x1CAC78, payboxes, 5, 1, 2, 3, 4));
			_paylines.push(new Payline5Data(35, LinesEmbed5x4.Line_035, PayboxesEmbed5x4.Paybox_035, 0xF0E891, payboxes, 10, 16, 17, 18, 19));
			_paylines.push(new Payline5Data(36, LinesEmbed5x4.Line_036, PayboxesEmbed5x4.Paybox_036, 0xB2EC5D, payboxes, 5, 6, 7, 8, 14));
			_paylines.push(new Payline5Data(37, LinesEmbed5x4.Line_037, PayboxesEmbed5x4.Paybox_037, 0x5D76CB, payboxes, 10, 11, 12, 13, 9));
			_paylines.push(new Payline5Data(38, LinesEmbed5x4.Line_038, PayboxesEmbed5x4.Paybox_038, 0xCA3767, payboxes, 10, 6, 7, 8, 9));
			_paylines.push(new Payline5Data(39, LinesEmbed5x4.Line_039, PayboxesEmbed5x4.Paybox_039, 0x3BB08F, payboxes, 5, 11, 12, 13, 14));
			_paylines.push(new Payline5Data(40, LinesEmbed5x4.Line_040, PayboxesEmbed5x4.Paybox_040, 0xFDFC74, payboxes, 0, 11, 2, 13, 4));
			_paylines.push(new Payline5Data(41, LinesEmbed5x4.Line_041, PayboxesEmbed5x4.Paybox_041, 0xFCB4D5, payboxes, 15, 6, 17, 8, 19));
			_paylines.push(new Payline5Data(42, LinesEmbed5x4.Line_042, PayboxesEmbed5x4.Paybox_042, 0xFFBD88, payboxes, 0, 16, 2, 18, 4));
			_paylines.push(new Payline5Data(43, LinesEmbed5x4.Line_043, PayboxesEmbed5x4.Paybox_043, 0xF664AF, payboxes, 15, 1, 17, 3, 19));
			_paylines.push(new Payline5Data(44, LinesEmbed5x4.Line_044, PayboxesEmbed5x4.Paybox_044, 0x979AAA, payboxes, 0, 6, 12, 18, 19));
			_paylines.push(new Payline5Data(45, LinesEmbed5x4.Line_045, PayboxesEmbed5x4.Paybox_045, 0xFF8243, payboxes, 15, 11, 7, 3, 4));
			_paylines.push(new Payline5Data(46, LinesEmbed5x4.Line_046, PayboxesEmbed5x4.Paybox_046, 0xC8385A, payboxes, 5, 6, 12, 8, 9));
			_paylines.push(new Payline5Data(47, LinesEmbed5x4.Line_047, PayboxesEmbed5x4.Paybox_047, 0xEF98AA, payboxes, 10, 11, 7, 13, 14));
			_paylines.push(new Payline5Data(48, LinesEmbed5x4.Line_048, PayboxesEmbed5x4.Paybox_048, 0x1A4876, payboxes, 15, 16, 12, 8, 4));
			_paylines.push(new Payline5Data(49, LinesEmbed5x4.Line_049, PayboxesEmbed5x4.Paybox_049, 0x30BA8F, payboxes, 0, 1, 7, 13, 19));
			_paylines.push(new Payline5Data(50, LinesEmbed5x4.Line_050, PayboxesEmbed5x4.Paybox_050, 0x1974D2, payboxes, 5, 11, 7, 13, 9));
			_paylines.push(new Payline5Data(51, LinesEmbed5x4.Line_051, PayboxesEmbed5x4.Paybox_051, 0xFFA343, payboxes, 10, 6, 12, 8, 14));
			_paylines.push(new Payline5Data(52, LinesEmbed5x4.Line_052, PayboxesEmbed5x4.Paybox_052, 0xBAB86C, payboxes, 5, 16, 7, 18, 9));
			_paylines.push(new Payline5Data(53, LinesEmbed5x4.Line_053, PayboxesEmbed5x4.Paybox_053, 0xFF7538, payboxes, 10, 1, 12, 3, 14));
			_paylines.push(new Payline5Data(54, LinesEmbed5x4.Line_054, PayboxesEmbed5x4.Paybox_054, 0xE6A8D7, payboxes, 10, 6, 7, 8, 14));
			_paylines.push(new Payline5Data(55, LinesEmbed5x4.Line_055, PayboxesEmbed5x4.Paybox_055, 0x414A4C, payboxes, 5, 11, 12, 13, 9));
			_paylines.push(new Payline5Data(56, LinesEmbed5x4.Line_056, PayboxesEmbed5x4.Paybox_056, 0x1CA9C9, payboxes, 0, 11, 12, 13, 4));
			_paylines.push(new Payline5Data(57, LinesEmbed5x4.Line_057, PayboxesEmbed5x4.Paybox_057, 0xFFCFAB, payboxes, 5, 16, 17, 18, 9));
			_paylines.push(new Payline5Data(58, LinesEmbed5x4.Line_058, PayboxesEmbed5x4.Paybox_058, 0x158078, payboxes, 15, 6, 7, 8, 19));
			_paylines.push(new Payline5Data(59, LinesEmbed5x4.Line_059, PayboxesEmbed5x4.Paybox_059, 0xFC74FD, payboxes, 10, 1, 2, 3, 14));
			_paylines.push(new Payline5Data(60, LinesEmbed5x4.Line_060, PayboxesEmbed5x4.Paybox_060, 0xF780A1, payboxes, 0, 16, 17, 18, 4));
			_paylines.push(new Payline5Data(61, LinesEmbed5x4.Line_061, PayboxesEmbed5x4.Paybox_061, 0x8E4585, payboxes, 15, 1, 2, 3, 19));
			_paylines.push(new Payline5Data(62, LinesEmbed5x4.Line_062, PayboxesEmbed5x4.Paybox_062, 0x7442C8, payboxes, 0, 1, 2, 8, 9));
			_paylines.push(new Payline5Data(63, LinesEmbed5x4.Line_063, PayboxesEmbed5x4.Paybox_063, 0x9D81BA, payboxes, 5, 6, 7, 13, 14));
			_paylines.push(new Payline5Data(64, LinesEmbed5x4.Line_064, PayboxesEmbed5x4.Paybox_064, 0xFF1DCE, payboxes, 5, 6, 7, 3, 4));
			_paylines.push(new Payline5Data(65, LinesEmbed5x4.Line_065, PayboxesEmbed5x4.Paybox_065, 0xFF496C, payboxes, 10, 11, 12, 18, 19));
			_paylines.push(new Payline5Data(66, LinesEmbed5x4.Line_066, PayboxesEmbed5x4.Paybox_066, 0xD68A59, payboxes, 10, 11, 12, 8, 9));
			_paylines.push(new Payline5Data(67, LinesEmbed5x4.Line_067, PayboxesEmbed5x4.Paybox_067, 0xFF48D0, payboxes, 15, 16, 17, 13, 14));
			_paylines.push(new Payline5Data(68, LinesEmbed5x4.Line_068, PayboxesEmbed5x4.Paybox_068, 0xEE204D, payboxes, 0, 1, 2, 13, 14));
			_paylines.push(new Payline5Data(69, LinesEmbed5x4.Line_069, PayboxesEmbed5x4.Paybox_069, 0xFF5349, payboxes, 5, 6, 7, 18, 19));
			_paylines.push(new Payline5Data(70, LinesEmbed5x4.Line_070, PayboxesEmbed5x4.Paybox_070, 0xC0448F, payboxes, 10, 11, 12, 3, 4));
			_paylines.push(new Payline5Data(71, LinesEmbed5x4.Line_071, PayboxesEmbed5x4.Paybox_071, 0x1FCECB, payboxes, 15, 16, 17, 8, 9));
			_paylines.push(new Payline5Data(72, LinesEmbed5x4.Line_072, PayboxesEmbed5x4.Paybox_072, 0x7851A9, payboxes, 0, 1, 2, 18, 19));
			_paylines.push(new Payline5Data(73, LinesEmbed5x4.Line_073, PayboxesEmbed5x4.Paybox_073, 0xFF9BAA, payboxes, 15, 16, 17, 3, 4));
			_paylines.push(new Payline5Data(74, LinesEmbed5x4.Line_074, PayboxesEmbed5x4.Paybox_074, 0xFC2847, payboxes, 0, 1, 7, 8, 9));
			_paylines.push(new Payline5Data(75, LinesEmbed5x4.Line_075, PayboxesEmbed5x4.Paybox_075, 0x76FF7A, payboxes, 5, 6, 12, 13, 14));
			_paylines.push(new Payline5Data(76, LinesEmbed5x4.Line_076, PayboxesEmbed5x4.Paybox_076, 0x9FE2BF, payboxes, 10, 11, 17, 18, 19));
			_paylines.push(new Payline5Data(77, LinesEmbed5x4.Line_077, PayboxesEmbed5x4.Paybox_077, 0xA5694F, payboxes, 5, 6, 2, 3, 4));
			_paylines.push(new Payline5Data(78, LinesEmbed5x4.Line_078, PayboxesEmbed5x4.Paybox_078, 0x8A795D, payboxes, 10, 11, 7, 8, 9));
			_paylines.push(new Payline5Data(79, LinesEmbed5x4.Line_079, PayboxesEmbed5x4.Paybox_079, 0x45CEA2, payboxes, 15, 16, 12, 13, 14));
			_paylines.push(new Payline5Data(80, LinesEmbed5x4.Line_080, PayboxesEmbed5x4.Paybox_080, 0x80DAEB, payboxes, 0, 1, 12, 13, 14));
			_paylines.push(new Payline5Data(81, LinesEmbed5x4.Line_081, PayboxesEmbed5x4.Paybox_081, 0xFFCF48, payboxes, 5, 6, 17, 18, 19));
			_paylines.push(new Payline5Data(82, LinesEmbed5x4.Line_082, PayboxesEmbed5x4.Paybox_082, 0xFD5E53, payboxes, 10, 11, 2, 3, 4));
			_paylines.push(new Payline5Data(83, LinesEmbed5x4.Line_083, PayboxesEmbed5x4.Paybox_083, 0xFAA76C, payboxes, 15, 16, 7, 8, 9));
			_paylines.push(new Payline5Data(84, LinesEmbed5x4.Line_084, PayboxesEmbed5x4.Paybox_084, 0xFC89AC, payboxes, 0, 1, 17, 18, 19));
			_paylines.push(new Payline5Data(85, LinesEmbed5x4.Line_085, PayboxesEmbed5x4.Paybox_085, 0x17806D, payboxes, 15, 16, 2, 3, 4));
			_paylines.push(new Payline5Data(86, LinesEmbed5x4.Line_086, PayboxesEmbed5x4.Paybox_086, 0xDEAA88, payboxes, 5, 1, 7, 13, 9));
			_paylines.push(new Payline5Data(87, LinesEmbed5x4.Line_087, PayboxesEmbed5x4.Paybox_087, 0x77DDE7, payboxes, 10, 6, 12, 18, 14));
			_paylines.push(new Payline5Data(88, LinesEmbed5x4.Line_088, PayboxesEmbed5x4.Paybox_088, 0xFDFC74, payboxes, 5, 11, 7, 3, 9));
			_paylines.push(new Payline5Data(89, LinesEmbed5x4.Line_089, PayboxesEmbed5x4.Paybox_089, 0x926EAE, payboxes, 10, 16, 12, 8, 14));
			_paylines.push(new Payline5Data(90, LinesEmbed5x4.Line_090, PayboxesEmbed5x4.Paybox_090, 0xF75394, payboxes, 0, 6, 17, 8, 4));
			_paylines.push(new Payline5Data(91, LinesEmbed5x4.Line_091, PayboxesEmbed5x4.Paybox_091, 0xFFA089, payboxes, 15, 11, 2, 13, 19));
			_paylines.push(new Payline5Data(92, LinesEmbed5x4.Line_092, PayboxesEmbed5x4.Paybox_092, 0x8F509D, payboxes, 0, 11, 17, 13, 4));
			_paylines.push(new Payline5Data(93, LinesEmbed5x4.Line_093, PayboxesEmbed5x4.Paybox_093, 0xA2ADD0, payboxes, 15, 6, 2, 8, 19));
			_paylines.push(new Payline5Data(94, LinesEmbed5x4.Line_094, PayboxesEmbed5x4.Paybox_094, 0xFF43A4, payboxes, 0, 1, 12, 3, 4));
			_paylines.push(new Payline5Data(95, LinesEmbed5x4.Line_095, PayboxesEmbed5x4.Paybox_095, 0xFC6C85, payboxes, 5, 6, 17, 8, 9));
			_paylines.push(new Payline5Data(96, LinesEmbed5x4.Line_096, PayboxesEmbed5x4.Paybox_096, 0xCDA4DE, payboxes, 10, 11, 2, 13, 14));
			_paylines.push(new Payline5Data(97, LinesEmbed5x4.Line_097, PayboxesEmbed5x4.Paybox_097, 0xFCE883, payboxes, 15, 16, 7, 18, 19));
			_paylines.push(new Payline5Data(98, LinesEmbed5x4.Line_098, PayboxesEmbed5x4.Paybox_098, 0xC5E384, payboxes, 0, 1, 17, 3, 4));
			_paylines.push(new Payline5Data(99, LinesEmbed5x4.Line_099, PayboxesEmbed5x4.Paybox_099, 0xFFB653, payboxes, 15, 16, 2, 18, 19));
		}
		protected override function InitHorizontalPaylines(payboxes:Vector.<PayboxData>):void
		{
			super.InitHorizontalPaylines(payboxes);
			_horizontalPaylines.push(new Payline5Data(0, LinesEmbed5x4.Line_000, PayboxesEmbed5x4.Paybox_000, 0xCD9575, payboxes, 0, 1, 2, 3, 4));
			_horizontalPaylines.push(new Payline5Data(1, LinesEmbed5x4.Line_001, PayboxesEmbed5x4.Paybox_001, 0xFDD9B5, payboxes, 5, 6, 7, 8, 9));
			_horizontalPaylines.push(new Payline5Data(2, LinesEmbed5x4.Line_002, PayboxesEmbed5x4.Paybox_002, 0x78DBE2, payboxes, 10, 11, 12, 13, 14));
		}
	}
}