package com.gotchaslots.common.data.session
{
	import com.gotchaslots.common.data.session.machines.MachinesSessionCollection;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.slots.data.session.rare.RareSessionData;
	import com.gotchaslots.slots.data.session.wallet.WalletSessionData;
	
	public class SessionData extends EventDispatcherEx
	{
		// members
		private var _wallet:WalletSessionData;
		private var _rare:RareSessionData;
		private var _machines:MachinesSessionCollection;
		
		// properteis
		public function get Wallet():WalletSessionData
		{
			return _wallet;
		}
		public function set Wallet(value:WalletSessionData):void
		{
			_wallet = value;
		}
		
		public function get Rare():RareSessionData
		{
			return _rare;
		}
		public function set Rare(value:RareSessionData):void
		{
			_rare = value;
		}
		
		public function get Machines():MachinesSessionCollection
		{
			return _machines;
		}
		public function set Machines(value:MachinesSessionCollection):void
		{
			_machines = value;
		}
		
		// class
		public function SessionData()
		{
			super();
			
			_wallet = new WalletSessionData();
			_wallet.Load();
			_wallet.StartJackpot();
			_wallet.Save();
			
			_rare = new RareSessionData();
			_rare.Load();
			
			_machines = new MachinesSessionCollection();
			_machines.Load();
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			if (_wallet)
			{
				_wallet.Dispose();
				_wallet = null;
			}
			
			if (_rare)
			{
				_rare.Dispose();
				_rare = null;
			}
			
			if (_machines)
			{
				_machines.Dispose();
				_machines = null;
			}
		}
		
		// machine state
		public function FixSession():void
		{
			Wallet.Fix();
			Rare.Fix();
			Machines.Fix();
		}
	}
}