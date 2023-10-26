package com.gotchaslots.common.data
{
	import com.gotchaslots.slots.assets.TextFieldsHandler;
	import com.gotchaslots.slots.data.application.SlotsApplicationData;
	import com.gotchaslots.common.data.device.DeviceData;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.LobbyMachine3x3Data;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.LobbyMachine5x3Data;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.LobbyMachine5x4Data;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.LobbyMachine5x5Data;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.LobbyMachineNormalSymbolsData;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.common.data.lobby.lobbyMachine.dummy.ComingSoonDummyData;
	import com.gotchaslots.common.data.lobby.pages.PageData;
	import com.gotchaslots.slots.data.machine.SlotsMachineData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.AircraftCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.AnimalsCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.BoatCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.CarCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.ChristmasCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.EasterCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.FunnyCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.HalloweenCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.HolidayCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.MapCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.NewYearCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.SportsCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.TrafficCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.WeatherCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.ZooCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.higherLower.HigherLowerData;
	import com.gotchaslots.common.data.session.SessionData;
	import com.gotchaslots.common.data.session.level.LevelData;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	import com.gotchaslots.common.utils.xServices.XServicesHandler;
	
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class Main extends EventDispatcherEx
	{
		// singleton
		private static var _instance:Main;
		public static function get Instance():Main
		{
			if (_instance == null)
			{
				_instance = new Main();
			}
			return _instance;
		}
		
		// consts
		public function get CurrentVersion():String
		{
			if (!_version || _version == "")
			{
				var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
				var ns:Namespace = appXml.namespace();
				_version = appXml.ns::versionNumber;
			}
			return _version;
		}
		public function get AppName():String
		{
			if (!_appName || _appName == "")
			{
				var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
				var ns:Namespace = appXml.namespace();
				_appName = appXml.ns::name;
			}
			return _appName;
		}
		
		// members
		private var _initialized:Boolean;
		
		private var _version:String;
		private var _appName:String;
		
		private var _device:DeviceData;
		private var _application:SlotsApplicationData;
		private var _session:SessionData;
		private var _machines:Vector.<SlotsBaseLobbyMachineData>;
		private var _pages:Vector.<PageData>;
		private var _activeMachine:SlotsMachineData;
		private var _xServices:XServicesHandler;
		private var _sounds:SlotsSoundsManager;
		private var _textFields:TextFieldsHandler;
		private var _timer:TimerEx;
		
		// properteis
		public function get Initialized():Boolean
		{
			return _initialized;
		}
		
		public function get Device():DeviceData
		{
			return _device;
		}
		
		public function get Application():SlotsApplicationData
		{
			return _application;
		}
		
		public function get Session():SessionData
		{
			return _session;
		}
		
		public function get Machines():Vector.<SlotsBaseLobbyMachineData>
		{
			return _machines;
		}
		
		public function get Pages():Vector.<PageData>
		{
			return _pages;
		}
		
		public function get ActiveMachine():SlotsMachineData
		{
			return _activeMachine;
		}
		public function set ActiveMachine(value:SlotsMachineData):void
		{
			if (_activeMachine != value)
			{
				_activeMachine = value;
			}
		}
		public function CreateActiveMachine(lobbyMachine:SlotsBaseLobbyMachineData):void
		{
			if (lobbyMachine && !ActiveMachine)
			{
				ActiveMachine = new SlotsMachineData(lobbyMachine);
				ActiveMachine.Init();
				Main.Instance.Session.Rare.RecentActiveMachineID = Main.Instance.ActiveMachine.LobbyMachine.ID;
				dispatchEvent(new Event(MainEvent.ActiveMachineDataCreated));
			}
		}
		public function RemoveActiveMachine():void
		{
			if (ActiveMachine)
			{
				dispatchEvent(new Event(MainEvent.RemoveActiveMachineView));
			}
		}
		
		public function get XServices():XServicesHandler
		{
			return _xServices;
		}
		public function get Sounds():SlotsSoundsManager
		{
			return _sounds;
		}
		public function get TextFields():TextFieldsHandler
		{
			return _textFields;
		}
		
		// class
		public function Main()
		{
			super();
		}
		public function Init(stage:Stage):void
		{
			_device = new DeviceData(stage);
			_application = new SlotsApplicationData();
			_session = new SessionData();
			InitMachines();
			InitPages();
			ActiveMachine = null;
			_xServices = new XServicesHandler();
			_sounds = new SlotsSoundsManager();
			_textFields = new TextFieldsHandler();
			InitTimer();
			
			_initialized = true;
		}
		private function InitMachines():void
		{
			_machines = new Vector.<SlotsBaseLobbyMachineData>();
			
			_machines.push(new ComingSoonDummyData(600, LobbyMachineNormalSymbolsData.ComingSoonNormalSymbols));
			
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Cars",		LobbyMachineNormalSymbolsData.CarsNormalSymbols,		CarCurtainData,			"Cars.png",			0, 1, 25,		new LevelData(1),	false, 0.80, true, true, true, true, false, true, true, true, true));			
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Valentines",	LobbyMachineNormalSymbolsData.ValentinesNormalSymbols,	HigherLowerData,		"Valentines.png",	4, 1, 15,		new LevelData(2),	false, 0.80, true, true, true, true, false, true, true, true, true));						
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Weather",		LobbyMachineNormalSymbolsData.WeatherNormalSymbols,		WeatherCurtainData,		"Weather.png",		8, 1, 25,		new LevelData(3),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Airplane",	LobbyMachineNormalSymbolsData.AirplaneNormalSymbols,	AircraftCurtainData,	"Airplane.png",		1, 1, 40,		new LevelData(4),	false, 0.80, true, true, true, true, false, true, true, true, true));							
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Chef",		LobbyMachineNormalSymbolsData.ChefNormalSymbols,		HigherLowerData,		"Chef.png",			0, 1, 50,		new LevelData(5),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Medical",		LobbyMachineNormalSymbolsData.MedicalNormalSymbols,		HigherLowerData,		"Medical.png",		7, 1, 100,		new LevelData(10),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Medical",		LobbyMachineNormalSymbolsData.MedicalNormalSymbols,		HigherLowerData,		"Medical.png",		7, 1, 25,		new LevelData(15),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Meow",		LobbyMachineNormalSymbolsData.MeowNormalSymbols,		ZooCurtainData,			"Meow.png",			9, 1, 25,		new LevelData(20),	false, 0.80, true, true, true, true, false, true, true, true, true));			
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Easter",		LobbyMachineNormalSymbolsData.EasterNormalSymbols,		EasterCurtainData,		"Easter.png",		5, 1, 25,		new LevelData(25),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Halloween",	LobbyMachineNormalSymbolsData.HalloweenNormalSymbols,	HalloweenCurtainData,	"Halloween.png",	2, 1, 9,		new LevelData(30),	false, 0.80, true, true, true, true, false, true, true, true, true));							
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Valentines",	LobbyMachineNormalSymbolsData.ValentinesNormalSymbols,	HigherLowerData,		"Valentines.png",	4, 1, 40,		new LevelData(35),	false, 0.80, true, true, true, true, false, true, true, true, true));						
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Halloween",	LobbyMachineNormalSymbolsData.HalloweenNormalSymbols,	HalloweenCurtainData,	"Halloween.png",	2, 1, 25,		new LevelData(40),	false, 0.80, true, true, true, true, false, true, true, true, true));							
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Avatar",		LobbyMachineNormalSymbolsData.AvatarNormalSymbols,		FunnyCurtainData,		"Avatar.png",		0, 1, 9,		new LevelData(45),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Easter",		LobbyMachineNormalSymbolsData.EasterNormalSymbols,		EasterCurtainData,		"Easter.png",		5, 1, 9,		new LevelData(50),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Avatar",		LobbyMachineNormalSymbolsData.AvatarNormalSymbols,		FunnyCurtainData,		"Avatar.png",		0, 1, 40,		new LevelData(55),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Cosmetic",	LobbyMachineNormalSymbolsData.CosmeticNormalSymbols,	HigherLowerData,		"Cosmetic.png",		1, 1, 25,		new LevelData(60),	false, 0.80, true, true, true, true, false, true, true, true, true));						
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Meow",		LobbyMachineNormalSymbolsData.MeowNormalSymbols,		ZooCurtainData,			"Meow.png",			9, 1, 40,		new LevelData(65),	false, 0.80, true, true, true, true, false, true, true, true, true));			
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Diving",		LobbyMachineNormalSymbolsData.DivingNormalSymbols,		TrafficCurtainData,		"Diving.png",		5, 1, 50,		new LevelData(70),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Tourism",		LobbyMachineNormalSymbolsData.TourismNormalSymbols,		HigherLowerData,		"Tourism.png",		6, 1, 100,		new LevelData(75),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Christmas",	LobbyMachineNormalSymbolsData.ChristmasNormalSymbols,	ChristmasCurtainData,	"Christmas.png",	10, 1, 25,		new LevelData(80),	false, 0.80, true, true, true, true, false, true, true, true, true));							
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Sports",		LobbyMachineNormalSymbolsData.SportsNormalSymbols,		SportsCurtainData,		"Sports.png",		7, 1, 9,		new LevelData(85),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Tourism",		LobbyMachineNormalSymbolsData.TourismNormalSymbols,		HigherLowerData,		"Tourism.png",		6, 1, 25,		new LevelData(90),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Cheese",		LobbyMachineNormalSymbolsData.CheeseNormalSymbols,		HigherLowerData,		"Cheese.png",		1, 1, 25,		new LevelData(95),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Sports",		LobbyMachineNormalSymbolsData.SportsNormalSymbols,		SportsCurtainData,		"Sports.png",		7, 1, 50,		new LevelData(100),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Airplane",	LobbyMachineNormalSymbolsData.AirplaneNormalSymbols,	AircraftCurtainData,	"Airplane.png",		1, 1, 15,		new LevelData(105),	false, 0.80, true, true, true, true, false, true, true, true, true));							
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Christmas",	LobbyMachineNormalSymbolsData.ChristmasNormalSymbols,	ChristmasCurtainData,	"Christmas.png",	10, 1, 100,		new LevelData(110),	false, 0.80, true, true, true, true, false, true, true, true, true));							
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Cheese",		LobbyMachineNormalSymbolsData.CheeseNormalSymbols,		HigherLowerData,		"Cheese.png",		1, 1, 9,		new LevelData(115),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Cars",		LobbyMachineNormalSymbolsData.CarsNormalSymbols,		CarCurtainData,			"Cars.png",			0, 1, 9,		new LevelData(120),	false, 0.80, true, true, true, true, false, true, true, true, true));			
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Beach",		LobbyMachineNormalSymbolsData.BeachNormalSymbols,		BoatCurtainData,		"Beach.png",		1, 1, 40,		new LevelData(125),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Cosmetic",	LobbyMachineNormalSymbolsData.CosmeticNormalSymbols,	HigherLowerData,		"Cosmetic.png",		1, 1, 40,		new LevelData(130),	false, 0.80, true, true, true, true, false, true, true, true, true));						
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Diving",		LobbyMachineNormalSymbolsData.DivingNormalSymbols,		TrafficCurtainData,		"Diving.png",		5, 1, 100,		new LevelData(135),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x4Data(_machines.length, "Animals",		LobbyMachineNormalSymbolsData.AnimalsNormalSymbols,		AnimalsCurtainData,		"Animals.png",		0, 1, 15,		new LevelData(140),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Weather",		LobbyMachineNormalSymbolsData.WeatherNormalSymbols,		WeatherCurtainData,		"Weather.png",		8, 1, 50,		new LevelData(145),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Classic",		LobbyMachineNormalSymbolsData.ClassicNormalSymbols,		HolidayCurtainData,		"Classic.png",		1, 1, 100,		new LevelData(150),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Flags",		LobbyMachineNormalSymbolsData.FlagsNormalSymbols,		MapCurtainData,			"Flags.png",		2, 1, 40,		new LevelData(155),	false, 0.80, true, true, true, true, false, true, true, true, true));			
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Flags",		LobbyMachineNormalSymbolsData.FlagsNormalSymbols,		MapCurtainData,			"Flags.png",		2, 1, 15,		new LevelData(160),	false, 0.80, true, true, true, true, false, true, true, true, true));			
			_machines.push(new LobbyMachine5x5Data(_machines.length, "Classic",		LobbyMachineNormalSymbolsData.ClassicNormalSymbols,		HolidayCurtainData,		"Classic.png",		1, 1, 9,		new LevelData(165),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Chinese",		LobbyMachineNormalSymbolsData.ChineseNormalSymbols,		NewYearCurtainData,		"Chinese.png",		2, 1, 15,		new LevelData(170),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine3x3Data(_machines.length, "Beach",		LobbyMachineNormalSymbolsData.BeachNormalSymbols,		BoatCurtainData,		"Beach.png",		1, 1, 27,		new LevelData(175),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Animals",		LobbyMachineNormalSymbolsData.AnimalsNormalSymbols,		AnimalsCurtainData,		"Animals.png",		0, 1, 25,		new LevelData(180),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Chef",		LobbyMachineNormalSymbolsData.ChefNormalSymbols,		HigherLowerData,		"Chef.png",			0, 1, 100,		new LevelData(185),	false, 0.80, true, true, true, true, false, true, true, true, true));				
			_machines.push(new LobbyMachine5x3Data(_machines.length, "Chinese",		LobbyMachineNormalSymbolsData.ChineseNormalSymbols,		NewYearCurtainData,		"Chinese.png",		2, 1, 40,		new LevelData(190),	false, 0.80, true, true, true, true, false, true, true, true, true));				
		}
		private function InitPages():void
		{
			_pages = new Vector.<PageData>();
			var page:PageData = new PageData((_pages.length + 1).toString());
			for (var i:int = 0; i < _machines.length; i++)
			{
				if (!(_machines[i] is ComingSoonDummyData))
				{
					page.AddLobbyMachine(	_machines[i])
					
					if (page.LobbyMachines.length == 4)
					{
						_pages.push(page);
						page = new PageData((_pages.length + 1).toString());
					}
				}
			}
			
			while (page.LobbyMachines.length < 4)
			{
				page.AddLobbyMachine(GetMachineByMachineClass(ComingSoonDummyData));
			}
			_pages.push(page);
		}
		private function InitTimer():void
		{
			_timer = new TimerEx(1000);
			_timer.addEventListener(TimerEvent.TIMER, OnTimer);
			_timer.start();
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			if (_device)
			{
				_device.Dispose();
				_device = null;
			}
			
			if (_application)
			{
				_application.Dispose();
				_application = null;
			}
			
			if (_session)
			{
				_session.Dispose();
				_session = null;
			}
			
			while (_machines && _machines.length > 0)
			{
				var lobbyMachine:SlotsBaseLobbyMachineData = _machines.pop();
				lobbyMachine.Dispose();
				lobbyMachine = null;
			}
			_machines = null;
			
			while (_pages && _pages.length > 0)
			{
				var page:PageData = _pages.pop();
				page.Dispose();
				page = null;
			}
			_pages = null;
			
			if (_activeMachine)
			{
				_activeMachine.Dispose();
				_activeMachine = null;
			}
			
			if (_xServices)
			{
				_xServices.Dispose();
				_xServices = null;
			}
			
			if (_sounds)
			{
				_sounds.Dispose();
				_sounds = null;
			}
			
			_textFields = null;
			
			if (_timer)
			{
				_timer.Dispose();
				_timer = null;
			}
		}
		
		// methods
		public function GetLobbyMachineByMachineID(id:int):SlotsBaseLobbyMachineData
		{
			for (var i:int = 0; i < Machines.length; i++)
			{
				if (Machines[i].ID == id)
				{
					return Machines[i];
				}
			}
			
			return null;
		}
		public function GetMachineByMachineClass(lobbyMachineClass:Class):SlotsBaseLobbyMachineData
		{
			var result:SlotsBaseLobbyMachineData;
			
			for (var i:int = 0; i < _machines.length; i++)
			{
				result = _machines[i];
				if (result is lobbyMachineClass)
				{
					break;
				}
			}
			
			return result;
		}
		protected function OnTimer(event:Event):void
		{
			dispatchEvent(new MainEvent(MainEvent.Timer));
		}
	}
}