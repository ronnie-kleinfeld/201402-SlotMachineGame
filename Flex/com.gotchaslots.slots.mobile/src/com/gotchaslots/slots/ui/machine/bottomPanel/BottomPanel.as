package com.gotchaslots.slots.ui.machine.bottomPanel
{
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	import com.gotchaslots.common.ui.common.components.gradientBG.RotatedGradientBG;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.AutoSpinButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.BetDownButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.BetUpButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.MaxBetButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.PayTableButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.PaylinesDownButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.PaylinesUpButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.SpeedSpinButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.buttons.SpinButton;
	import com.gotchaslots.slots.ui.machine.bottomPanel.textFields.BetHeaderTextField;
	import com.gotchaslots.slots.ui.machine.bottomPanel.textFields.BetValueTextField;
	import com.gotchaslots.slots.ui.machine.bottomPanel.textFields.PaylinesHeaderTextField;
	import com.gotchaslots.slots.ui.machine.bottomPanel.textFields.PaylinesValueTextField;
	import com.gotchaslots.slots.ui.machine.bottomPanel.textFields.TotalBetHeaderTextField;
	import com.gotchaslots.slots.ui.machine.bottomPanel.textFields.TotalBetValueTextField;
	
	import flash.events.Event;
	
	public class BottomPanel extends BaseBG
	{
		// members
		private var _payTable:PayTableButton;
		private var _paylinesDown:PaylinesDownButton;
		private var _paylinesUp:PaylinesUpButton;
		private var _betDown:BetDownButton;
		private var _betUp:BetUpButton;
		private var _maxBet:MaxBetButton;
		private var _spin:SpinButton;
		private var _autoSpin:AutoSpinButton;
		
		// class
		public function BottomPanel()
		{
			super(800, 140);
			
			Init();
		}
		
		private function Init():void
		{
			// gradient bg
			addChild(new RotatedGradientBG(W, H, 0, 0xbf5deb, 0xa823e0));
			
			// pay table
			_payTable = new PayTableButton();
			_payTable.x = 6;
			_payTable.y = 34;
			addChild(_payTable);
			
			// paylines
			var paylinesValue:PaylinesValueTextField = new PaylinesValueTextField();
			paylinesValue.x = 119;
			paylinesValue.y = 40;
			addChild(paylinesValue);
			
			var paylinesHeader:PaylinesHeaderTextField = new PaylinesHeaderTextField();
			paylinesHeader.x = 115;
			paylinesHeader.y = 70;
			addChild(paylinesHeader);
			
			_paylinesDown = new PaylinesDownButton();
			_paylinesDown.x = 120;
			_paylinesDown.y = 92;
			addChild(_paylinesDown);
			
			_paylinesUp = new PaylinesUpButton();
			_paylinesUp.x = 168;
			_paylinesUp.y = 92;
			addChild(_paylinesUp);
			
			// bet
			var betValue:BetValueTextField = new BetValueTextField();
			betValue.x = 220;
			betValue.y = 40;
			addChild(betValue);
			
			var betHeader:BetHeaderTextField = new BetHeaderTextField();
			betHeader.x = 216;
			betHeader.y = 70;
			addChild(betHeader);
			
			_betDown = new BetDownButton();
			_betDown.x = 221;
			_betDown.y = 92;
			addChild(_betDown);
			
			_betUp = new BetUpButton();
			_betUp.x = 269;
			_betUp.y = 92;
			addChild(_betUp);			
			
			// total bet
			var totalBetValueTextField:TotalBetValueTextField = new TotalBetValueTextField();
			totalBetValueTextField.x = 324;
			totalBetValueTextField.y = 40;
			addChild(totalBetValueTextField);
			
			var totalBetHeaderTextField:TotalBetHeaderTextField = new TotalBetHeaderTextField();
			totalBetHeaderTextField.x = 318;
			totalBetHeaderTextField.y = 72;
			addChild(totalBetHeaderTextField);
			
			// max bet
			_maxBet = new MaxBetButton();
			_maxBet.addEventListener(BottomPanelEvent.MaxBetButtonClicked, OnMaxBetButtonClicked);
			_maxBet.x = 450;
			_maxBet.y = 34;
			addChild(_maxBet);
			
			// spin
			_spin = new SpinButton();
			_spin.addEventListener(BottomPanelEvent.SpinButtonClicked, OnSpinButtonClicked);
			_spin.x = 563;
			_spin.y = 6;
			addChild(_spin);
			
			// auto spin
			_autoSpin = new AutoSpinButton();
			_autoSpin.addEventListener(BottomPanelEvent.AutoSpinButtonClicked, OnAutoSpinButtonClicked);
			_autoSpin.x = 704;
			_autoSpin.y = 8;
			addChild(_autoSpin);
			
			// speed spin
			var speedSpin:SpeedSpinButton = new SpeedSpinButton();
			speedSpin.x = 704;
			speedSpin.y = 74;
			addChild(speedSpin);
		}
		public override function Dispose():void
		{
			_maxBet.removeEventListener(BottomPanelEvent.MaxBetButtonClicked, OnMaxBetButtonClicked);
			_spin.removeEventListener(BottomPanelEvent.SpinButtonClicked, OnSpinButtonClicked);
			_autoSpin.removeEventListener(BottomPanelEvent.AutoSpinButtonClicked, OnAutoSpinButtonClicked);
			
			super.Dispose();
		}
		
		// methods
		public function Enable():void
		{
			_paylinesUp.SetEnabled();
			_paylinesDown.SetEnabled();
			_betUp.SetEnabled();
			_betDown.SetEnabled();
			_maxBet.SetEnabled();
			_spin.SetEnabled();
		}
		public function Disable():void
		{
			_paylinesUp.SetDisabled();
			_paylinesDown.SetDisabled();
			_betUp.SetDisabled();
			_betDown.SetDisabled();
			_maxBet.SetDisabled();
			_spin.SetDisabled();
		}
		
		// events
		protected function OnMaxBetButtonClicked(event:Event):void
		{
			dispatchEvent(new Event(BottomPanelEvent.MaxBetButtonClicked));
		}
		protected function OnSpinButtonClicked(event:Event):void
		{
			dispatchEvent(new Event(BottomPanelEvent.SpinButtonClicked));
		}
		protected function OnAutoSpinButtonClicked(event:Event):void
		{
			dispatchEvent(new Event(BottomPanelEvent.AutoSpinButtonClicked));
		}
	}
}