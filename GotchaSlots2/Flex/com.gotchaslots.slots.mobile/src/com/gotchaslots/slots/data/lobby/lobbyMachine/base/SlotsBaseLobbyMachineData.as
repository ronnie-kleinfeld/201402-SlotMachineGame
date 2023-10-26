package com.gotchaslots.slots.data.lobby.lobbyMachine.base
{
	import com.gotchaslots.slots.assets.machine.symbols.SymbolsEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.lobby.lobbyMachine.base.CommonLobbyMachineData;
	import com.gotchaslots.slots.data.machine.SlotsMachineDataEvent;
	import com.gotchaslots.slots.data.machine.bonusGame.base.BaseBonusGameData;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.symbol.BombSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.BonusGameSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.FreeSpinsSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.MiniSpinSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.MultiplierSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.NormalSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	import com.gotchaslots.slots.data.machine.symbol.WildSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.collectibles.AceSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.collectibles.GoldSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.collectibles.KingSymbolData;
	import com.gotchaslots.slots.data.machine.valuator.bonusGame.BonusGameValuatorsData;
	import com.gotchaslots.slots.data.machine.valuator.collectibles.AceValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.collectibles.GoldValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.collectibles.KingValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.column.ColumnValuatorsData;
	import com.gotchaslots.slots.data.machine.valuator.scatter.BombValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.scatter.FreeSpinsValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.scatter.MiniSpinValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.scatter.MultiplierValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.strike.StrikeValuatorsData;
	import com.gotchaslots.slots.data.machine.valuator.symetric.SymetricValuatorsData;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.data.session.level.LevelData;
	import com.gotchaslots.common.data.session.machines.CommonMachineSessionDataEvent;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.slots.data.session.machines.SlotsMachineSessionDataEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class SlotsBaseLobbyMachineData extends CommonLobbyMachineData
	{
		// members
		private var _normalSymbolsFunction:Function;
		private var _maxPaylines:int;
		
		private var _symbols:SymbolsData;
		protected var _valuatorsClass:Vector.<Class>;
		private var _paylines:BasePaylinesData;
		private var _matrixPreviewPng:Bitmap;
		
		private var _bonusGameDataClass:Class;
		private var _bonusGameData:BaseBonusGameData;
		
		// properties
		public final function get MaxPaylines():int
		{
			return _maxPaylines;
		}
		
		protected function get ColumnFramesClass():Vector.<Class>
		{
			throw new MustOverrideError();
		}
		public final function get ColumnFramePngs():Vector.<Bitmap>
		{
			var columnFramePngs:Vector.<Bitmap> = new Vector.<Bitmap>();
			if (ColumnFramesClass)
			{
				for (var i:int = 0; i < ColumnFramesClass.length; i++)
				{
					columnFramePngs.push(new ColumnFramesClass[i]());
				}
			}
			return columnFramePngs;
		}
		protected function get SymetricFramesClass():Vector.<Class>
		{
			throw new MustOverrideError();
		}
		public final function get SymetricFramePngs():Vector.<Bitmap>
		{
			var symetricFramePngs:Vector.<Bitmap> = new Vector.<Bitmap>();
			if (SymetricFramesClass)
			{
				for (var i:int = 0; i < SymetricFramesClass.length; i++)
				{
					symetricFramePngs.push(new SymetricFramesClass[i]());
				}
			}
			return symetricFramePngs;
		}
		protected function get PayboxFramesClass():Vector.<Class>
		{
			throw new MustOverrideError();
		}
		public final function get PayboxFramePngs():Vector.<Bitmap>
		{
			var payboxFramePngs:Vector.<Bitmap> = new Vector.<Bitmap>();
			if (PayboxFramesClass)
			{
				for (var i:int = 0; i < PayboxFramesClass.length; i++)
				{
					payboxFramePngs.push(new PayboxFramesClass[i]());
				}
			}
			return payboxFramePngs;
		}
		public final function get Symbols():SymbolsData
		{
			return _symbols;
		}
		public final function get ValuatorsClass():Vector.<Class>
		{
			return _valuatorsClass;
		}
		protected function get PaylinesClass():Class
		{
			throw new MustOverrideError();
		}
		public final function get Paylines():BasePaylinesData
		{
			if (_paylines == null)
			{
				_paylines = new PaylinesClass(MaxPaylines);
			}
			return _paylines;
		}
		
		public final function get DiagonalWinLimitPayout():Number
		{
			return _symbols.MaxPayout;
		}
		
		// preview status
		public final function get ShowPendingFreeSpinsStatus():int
		{
			if (IsOpen && (MachineSession.FreeSpinsPendingCount > 0))
			{
				return MachineSession.FreeSpinsPendingCount;
			}
			else
			{
				return 0;
			}
		}
		public final function get ShowPendingBonusGameStatus():Boolean
		{
			return IsOpen && MachineSession.IsBonusGamePending;
		}
		
		protected function get MatrixPreviewClass():Class
		{
			throw new MustOverrideError();
		}
		public function get MatrixPreviewPng():Bitmap
		{
			if (!_matrixPreviewPng)
			{
				_matrixPreviewPng = new MatrixPreviewClass();
			}
			return _matrixPreviewPng;
		}
		
		public function get BonusGameData():BaseBonusGameData
		{
			if (!_bonusGameData)
			{
				_bonusGameData = new _bonusGameDataClass();
			}
			return _bonusGameData;
		}
		public function set BonusGameData(value:BaseBonusGameData):void
		{
			_bonusGameData = value;
		}
		
		// class
		public function SlotsBaseLobbyMachineData(id:int, machineName:String, normalSymbolsFunction:Function, bonusGameDataClass:Class, serverSymbolFileName:String, setPreviewSymbolID:int, factor:Number, maxPaylines:int, opensOnLevel:LevelData,
											 isComingSoon:Boolean, depreciationRatio:Number, strikeValuator:Boolean, freeSpinsScatterValuator:Boolean, bombScatterValuator:Boolean, miniSpinScatterValuator:Boolean,
											 collectiblesScatterValuator:Boolean, bonusGameValuator:Boolean, columnValuator:Boolean, symetricValuator:Boolean, multiplierScatterValuator:Boolean)
		{
			super(id, machineName, factor, opensOnLevel, isComingSoon, depreciationRatio);
			
			_normalSymbolsFunction = normalSymbolsFunction;
			_maxPaylines = maxPaylines;
			
			Main.Instance.Session.Machines.AddNewMachineSession(ID);
			MachineSession.addEventListener(CommonMachineSessionDataEvent.NewMachineChanged, OnMachineSessionNewMachineChanged);
			MachineSession.addEventListener(SlotsMachineSessionDataEvent.BonusGameChanged, OnMachineSessionBonusGameChanged);
			Main.Instance.Session.Wallet.addEventListener(SessionDataEvent.LevelIncreased, OnSessionDataLevelIncreased);
			
			InitNormalSymbols(factor);
			Symbols.SetPreviewSymbol = setPreviewSymbolID;
			Symbols.ServerSymbolFileName = serverSymbolFileName;
			
			InitValuatorsClass(factor, strikeValuator, freeSpinsScatterValuator, bombScatterValuator, miniSpinScatterValuator, collectiblesScatterValuator, bonusGameValuator, bonusGameDataClass, columnValuator, symetricValuator, multiplierScatterValuator);
			
			_bonusGameDataClass = bonusGameDataClass;
		}
		protected function InitNormalSymbols(factor:Number):void
		{
			_symbols = new SymbolsData();
			_symbols.InitNormalSymbols(_normalSymbolsFunction(factor));
			
			_symbols.AddSymbol(new WildSymbolData(_symbols.Symbols.length, SymbolsEmbed.Wild, Factor), true);
		}
		protected function InitValuatorsClass(factor:Number, strikeValuator:Boolean, freeSpinsScatterValuator:Boolean, bombScatterValuator:Boolean, miniSpinScatterValuator:Boolean,
											  collectiblesScatterValuator:Boolean, bonusGameValuator:Boolean, bonusGameDataClass:Class, columnValuator:Boolean, symetricValuator:Boolean, multiplierScatterValuator:Boolean):void
		{
			_valuatorsClass = new Vector.<Class>();
			
			if (strikeValuator)
			{
				AddStrikeValuator();
			}
			if (freeSpinsScatterValuator)
			{
				AddFreeSpinsScatterValuator();
			}
			
			if (bombScatterValuator)
			{
				AddBombScatterValuator(factor);
			}
			if (miniSpinScatterValuator)
			{
				AddMiniSpinScatterValuator(factor);
			}
			if (collectiblesScatterValuator)
			{
				//AddCollectiblesScatterValuator(factor);
			}
			if (bonusGameValuator)
			{
				AddBonusGameValuator(factor);
			}
			if (columnValuator)
			{
				AddColumnValuator();
			}
			if (symetricValuator)
			{
				AddSymetricValuator();
			}
			if (multiplierScatterValuator)
			{
				AddMultiplierScatterValuator(factor);
			}
		}
		public override function Dispose():void
		{
			if (_symbols)
			{
				_symbols.Dispose();
				_symbols = null;
			}
			
			while (_valuatorsClass && _valuatorsClass.length > 0)
			{
				_valuatorsClass.pop();
			}
			_valuatorsClass = null;
			
			if (_paylines)
			{
				_paylines.Dispose();
				_paylines = null;
			}
			
			_matrixPreviewPng = null;
			
			Main.Instance.Session.Wallet.removeEventListener(SessionDataEvent.LevelIncreased, OnSessionDataLevelIncreased);
			
			if (MachineSession)
			{
				MachineSession.removeEventListener(CommonMachineSessionDataEvent.NewMachineChanged, OnMachineSessionNewMachineChanged);
				MachineSession.removeEventListener(SlotsMachineSessionDataEvent.BonusGameChanged, OnMachineSessionBonusGameChanged);
			}
			
			super.Dispose();
		}
		
		// add symbols
		protected function AddNormalSymbol(normalSymbol:NormalSymbolData):void
		{
			_symbols.AddSymbol(normalSymbol, false);
		}
		
		// add valuators
		private final function AddBombScatterValuator(factor:Number):void
		{
			_valuatorsClass.push(BombValuatorData);
			_symbols.AddSymbol(new BombSymbolData(_symbols.Symbols.length, SymbolsEmbed.Bomb, factor), false);
		}
		private final function AddMiniSpinScatterValuator(factor:Number):void
		{
			_valuatorsClass.push(MiniSpinValuatorData);
			_symbols.AddSymbol(new MiniSpinSymbolData(_symbols.Symbols.length, SymbolsEmbed.MiniSpin, factor), false);
		}
		private final function AddCollectiblesScatterValuator(factor:Number):void
		{
			_valuatorsClass.push(AceValuatorData);
			_symbols.AddSymbol(new AceSymbolData(_symbols.Symbols.length, SymbolsEmbed.Ace, factor), false);
			
			_valuatorsClass.push(GoldValuatorData);
			_symbols.AddSymbol(new GoldSymbolData(_symbols.Symbols.length, SymbolsEmbed.Gold, factor), false);
			
			_valuatorsClass.push(KingValuatorData);
			_symbols.AddSymbol(new KingSymbolData(_symbols.Symbols.length, SymbolsEmbed.King, factor), false);
		}
		private final function AddStrikeValuator():void
		{
			_valuatorsClass.push(StrikeValuatorsData);
		}
		private final function AddBonusGameValuator(factor:Number):void
		{
			_valuatorsClass.push(BonusGameValuatorsData);
			_symbols.AddSymbol(new BonusGameSymbolData(_symbols.Symbols.length, SymbolsEmbed.BonusGame, factor), false);
		}
		private final function AddColumnValuator():void
		{
			_valuatorsClass.push(ColumnValuatorsData);
		}
		private final function AddSymetricValuator():void
		{
			_valuatorsClass.push(SymetricValuatorsData);
		}
		private final function AddMultiplierScatterValuator(factor:Number):void
		{
			_valuatorsClass.push(MultiplierValuatorData);
			_symbols.AddSymbol(new MultiplierSymbolData(_symbols.Symbols.length, SymbolsEmbed.Multiplier, factor), false);
		}
		private final function AddFreeSpinsScatterValuator():void
		{
			_valuatorsClass.push(FreeSpinsValuatorData);
			_symbols.AddSymbol(new FreeSpinsSymbolData(_symbols.Symbols.length, SymbolsEmbed.FreeSpins, Factor), false);
		}
		
		// events
		protected override function OnSessionDataLevelIncreased(event:SessionDataEvent):void
		{
			super.OnSessionDataLevelIncreased(event);
			
			if (event.WalletSession.GetLevel.LevelNumber >= OpensOnLevel.LevelNumber)
			{
				dispatchEvent(new Event(SlotsMachineDataEvent.PendingBonusGameStatusChanged));
			}
		}
		protected function OnMachineSessionBonusGameChanged(event:Event):void
		{
			dispatchEvent(new Event(SlotsMachineDataEvent.PendingBonusGameStatusChanged));
		}
	}
}