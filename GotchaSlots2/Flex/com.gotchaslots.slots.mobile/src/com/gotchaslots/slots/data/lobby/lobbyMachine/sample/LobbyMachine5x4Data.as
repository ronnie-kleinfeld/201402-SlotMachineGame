package com.gotchaslots.slots.data.lobby.lobbyMachine.sample
{
	import com.gotchaslots.slots.assets.machines.machine5x4.Machine5x4Embed;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.LobbyMachine5x4Data;
	import com.gotchaslots.slots.data.machine.symbol.NormalSymbolData;
	import com.gotchaslots.common.data.session.level.LevelData;
	
	public final class LobbyMachine5x4Data extends LobbyMachine5x4Data
	{
		// properties
		public override function get MachineName():String
		{
			return "Machine 5x4";
		}
		protected override function get Factor():Number
		{
			return 1.1;
		}
		public override function get MaxPaylines():int
		{
			return 33;
		}
		public override function get OpensOnLevel():LevelData
		{
			return new LevelData(1);
		}
		protected override function get ReelsBGPngClass():Class
		{
			return Machine5x4Embed.ReelsBG;
		}
		protected override function get FramePngClass():Class
		{
			return Machine5x4Embed.FrameBG;
		}
		public override function get IsCommingSoon():Boolean
		{
			return false;
		}
		
		// class
		public function LobbyMachine5x4Data(id:int)
		{
			super(id);
		}
		protected override function InitNormalSymbols():void
		{
			super.InitNormalSymbols();
			
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_00, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_01, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_02, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_03, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_04, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_05, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_06, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_07, 5, 3, 2, 2));
			AddNormalSymbol(new NormalSymbolData(Symbols.Symbols.length, Machine5x4Embed.Symbol_08, 5, 3, 2, 2));
			
			Symbols.SetPreviewSymbol = 8;
		}
	}
}