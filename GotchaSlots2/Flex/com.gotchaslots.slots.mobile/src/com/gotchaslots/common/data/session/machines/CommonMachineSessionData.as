package com.gotchaslots.common.data.session.machines
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.base.ISession;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.data.session.machines.SlotsMachineSessionDataEvent;

	public class CommonMachineSessionData extends EventDispatcherEx implements ISession
	{
		// members
		protected var _machinesSessionCollection:MachinesSessionCollection;
		protected var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		protected var _id:int;							// serialize
		protected var _isInvite4Unlocked:Boolean;			// serialize
		
		protected var _newMachine:Boolean;				// serialize
		
		// properties
		public function get LobbyMachine():SlotsBaseLobbyMachineData
		{
			if (!_lobbyMachine)
			{
				for (var i:int = 0; i < Main.Instance.Machines.length; i++)
				{
					if (Main.Instance.Machines[i].ID == ID)
					{
						return Main.Instance.Machines[i];
					}
				}
			}
			return _lobbyMachine;
		}
		
		public function get ID():int
		{
			return _id;
		}
		
		public function get IsInvite4Unlocked():Boolean
		{
			return _isInvite4Unlocked;
		}
		public function set IsInvite4Unlocked(value:Boolean):void
		{
			if (_isInvite4Unlocked != value)
			{
				_isInvite4Unlocked = value;
				dispatchEvent(new SlotsMachineSessionDataEvent(CommonMachineSessionDataEvent.IsInvite4Unlocked, this, 0));
				_machinesSessionCollection.Save();
			}
		}
		
		public function get NewMachine():Boolean
		{
			return _newMachine;
		}
		public function set NewMachine(value:Boolean):void
		{
			if (_newMachine != value)
			{
				_newMachine = value;
				dispatchEvent(new SlotsMachineSessionDataEvent(CommonMachineSessionDataEvent.NewMachineChanged, this, 0));
				_machinesSessionCollection.Save();
				
				if (!_newMachine && LobbyMachine.ID != Main.Instance.Machines[0].ID)
				{
					Main.Instance.Session.Rare.AddPendingNewMachinePopups(ID);
					Main.Instance.XServices.Social.ShareNewMachine(LobbyMachine);
				}
			}
		}
		
		// class
		public function CommonMachineSessionData(id:int, machinesSessionCollection:MachinesSessionCollection)
		{
			super();
			
			_id = id;
			_machinesSessionCollection = machinesSessionCollection;
			
			_isInvite4Unlocked = false;
			
			_newMachine = true;
		}
		
		// serialize
		public function Deserialize(object:Object):void
		{
			_id = object.ID;
			_isInvite4Unlocked = object.IsInvite4Unlocked;
			_newMachine = object.NewMachine;
		}
		public function Serialize():Object
		{
			var result:Object = new Object();
			result.ID = ID;
			result.IsInvite4Unlocked = _isInvite4Unlocked;
			result.NewMachine = _newMachine;
			return result;
		}
		
		// fix
		public function Fix():void
		{
		}
	}
}