package com.gotchaslots.slots.utils.sounds
{
	import com.gotchaslots.slots.assets.sounds.SoundsEmbed;
	import com.gotchaslots.common.utils.sounds.CommonSoundsManager;
	
	import flash.utils.Dictionary;
	
	public class SlotsSoundsManager extends CommonSoundsManager
	{
		// consts
		public static const Click:String = "4baeb38348ca419b8657f5e1207c7932Click";
		public static const TopPanel_Click:String = "4baeb38348ca419b8657f5e1207c7932TopPanel_Click";
		public static const App_Load:String = "4baeb38348ca419b8657f5e1207c7932App_Load";
		public static const TimerBonus_TimerBonus_Ready:String = "4baeb38348ca419b8657f5e1207c7932TimerBonus_TimerBonus_Ready";
		public static const TimerBonus_TimerBonus_Collect:String = "4baeb38348ca419b8657f5e1207c7932TimerBonus_TimerBonus_Collect";
		public static const SoundOn:String = "4baeb38348ca419b8657f5e1207c7932SoundOn";
		public static const SoundOff:String = "4baeb38348ca419b8657f5e1207c7932SoundOff";
		public static const Popup_LevelUp_Shown:String = "4baeb38348ca419b8657f5e1207c7932Popup_LevelUp_Shown";
		public static const Popup_NewMachine_Shown:String = "4baeb38348ca419b8657f5e1207c7932Popup_NewMachine_Shown";
		public static const Popup_Collect_WinToBalance:String = "4baeb38348ca419b8657f5e1207c7932Popup_Collect_WinToBalance";
		public static const Slide:String = "4baeb38348ca419b8657f5e1207c7932Slide";
		public static const MachinePreview_MachineInfoButton_Click:String = "4baeb38348ca419b8657f5e1207c7932MachinePreview_MachineInfoButton_Click";
		public static const MachinePreview_Click:String = "4baeb38348ca419b8657f5e1207c7932MachinePreview_Click";
		public static const Up:String = "Up";
		public static const Down:String = "Down";
		public static const Machine_BottomPanel_PayTable:String = "4baeb38348ca419b8657f5e1207c7932Machine_BottomPanel_PayTable";
		public static const Machine_BottomPanel_Auto_On:String = "4baeb38348ca419b8657f5e1207c7932Machine_BottomPanel_Auto_On";
		public static const Machine_BottomPanel_Auto_Off:String = "4baeb38348ca419b8657f5e1207c7932Machine_BottomPanel_Auto_Off";
		public static const Machine_BottomPanel_Speed_Fast:String = "4baeb38348ca419b8657f5e1207c7932Machine_BottomPanel_Speed_Fast";
		public static const Machine_BottomPanel_Speed_Slow:String = "4baeb38348ca419b8657f5e1207c7932Machine_BottomPanel_Speed_Slow";
		public static const Machine_Sequence_Spinning:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Spinning";
		public static const Machine_Sequence_Reel_Stop:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Reel_Stop";
		public static const Machine_Sequence_Won:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Won";
		public static const Machine_Sequence_NoWin:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_NoWin";
		public static const Machine_Sequence_Bomb_Blink:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Bomb_Blink";
		public static const Machine_Sequence_Bomb_Boom:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Bomb_Boom";
		public static const Machine_Sequence_MiniSpin_Spin:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_MiniSpin_Spin";
		public static const Machine_Sequence_MiniSpin_Stop:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_MiniSpin_Stop";
		public static const Machine_Sequence_Collectibles_Blink:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Collectibles_Blink";
		public static const Machine_Sequence_Collectibles_SymbolToCollectibles:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Collectibles_SymbolToCollectibles";
		public static const Machine_Sequence_Column_Flipper2:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Column_Flipper2";
		public static const Machine_Sequence_Symetric_Flipper2:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Symetric_Flipper2";
		public static const Machine_Sequence_Strike_Blink:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Strike_Blink";
		public static const Machine_Sequence_MegaWin_Animation:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_MegaWin_Animation";
		public static const Machine_Sequence_ExtraBigWin_Animation:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_ExtraBigWin_Animation";
		public static const Machine_Sequence_BigWin_Animation:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_BigWin_Animation";
		public static const Machine_Sequence_ToWin:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_ToWin";
		public static const Machine_Sequence_FiveInARow_Animation:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_FiveInARow_Animation";
		public static const Machine_Sequence_FourInARow_Animation:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_FourInARow_Animation";
		public static const Machine_Sequence_BonusGame_Blink:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_BonusGame_Blink";
		public static const Machine_Sequence_BonusGame_Popup_Start:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_BonusGame_Popup_Start";
		public static const Machine_Sequence_BonusGame_Popup_End:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_BonusGame_Popup_End";
		public static const Machine_Sequence_Multiplier_Blink:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_Multiplier_Blink";
		public static const Machine_Sequence_FreeSpins_Blink:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_FreeSpins_Blink";
		public static const Machine_Sequence_FreeSpins_SymbolToFreeSpinsRibbon:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_FreeSpins_SymbolToFreeSpinsRibbon";
		public static const Machine_Sequence_WinToBalance:String = "4baeb38348ca419b8657f5e1207c7932Machine_Sequence_WinToBalance";
		public static const Machine_BonusGame_HigherLower_Spin:String = "4baeb38348ca419b8657f5e1207c7932Machine_BonusGame_HigherLower_Spin";
		public static const Won:String = "4baeb38348ca419b8657f5e1207c7932Won";
		public static const NoWin:String = "4baeb38348ca419b8657f5e1207c7932NoWin";
		
		// class
		protected override function InitSounds():void
		{
			_soundsEmbed = new Dictionary();
			_soundsEmbed[Click] = SoundsEmbed.Click;
			_soundsEmbed[Machine_BonusGame_HigherLower_Spin] = SoundsEmbed.Machine_BonusGame_HigherLower_Spin;
			_soundsEmbed[TopPanel_Click] = SoundsEmbed.TopPanel_Click;
			_soundsEmbed[App_Load] = SoundsEmbed.App_Load;
			_soundsEmbed[TimerBonus_TimerBonus_Ready] = SoundsEmbed.TimerBonus_TimerBonus_Ready;
			_soundsEmbed[TimerBonus_TimerBonus_Collect] = SoundsEmbed.TimerBonus_TimerBonus_Collect;
			_soundsEmbed[SoundOn] = SoundsEmbed.SoundOn;
			_soundsEmbed[SoundOff] = SoundsEmbed.SoundOff;
			_soundsEmbed[Popup_LevelUp_Shown] = SoundsEmbed.Popup_LevelUp_Shown;
			_soundsEmbed[Popup_NewMachine_Shown] = SoundsEmbed.Popup_NewMachine_Shown;
			_soundsEmbed[Popup_Collect_WinToBalance] = SoundsEmbed.Popup_Collect_WinToBalance;
			_soundsEmbed[Slide] = SoundsEmbed.Slide;
			_soundsEmbed[MachinePreview_MachineInfoButton_Click] = SoundsEmbed.MachinePreview_MachineInfoButton_Click;
			_soundsEmbed[MachinePreview_Click] = SoundsEmbed.MachinePreview_Click;
			_soundsEmbed[Up] = SoundsEmbed.Up;
			_soundsEmbed[Down] = SoundsEmbed.Down;
			_soundsEmbed[Machine_BottomPanel_PayTable] = SoundsEmbed.Machine_BottomPanel_PayTable;
			_soundsEmbed[Machine_BottomPanel_Auto_On] = SoundsEmbed.Machine_BottomPanel_Auto_On;
			_soundsEmbed[Machine_BottomPanel_Auto_Off] = SoundsEmbed.Machine_BottomPanel_Auto_Off;
			_soundsEmbed[Machine_BottomPanel_Speed_Fast] = SoundsEmbed.Machine_BottomPanel_Speed_Fast;
			_soundsEmbed[Machine_BottomPanel_Speed_Slow] = SoundsEmbed.Machine_BottomPanel_Speed_Slow;
			_soundsEmbed[Machine_Sequence_Spinning] = SoundsEmbed.Machine_Sequence_Spinning;
			_soundsEmbed[Machine_Sequence_Reel_Stop] = SoundsEmbed.Machine_Sequence_Reel_Stop;
			_soundsEmbed[Machine_Sequence_Won] = SoundsEmbed.Machine_Sequence_Won;
			_soundsEmbed[Machine_Sequence_NoWin] = SoundsEmbed.Machine_Sequence_NoWin;
			_soundsEmbed[Machine_Sequence_Bomb_Blink] = SoundsEmbed.Machine_Sequence_Bomb_Blink;
			_soundsEmbed[Machine_Sequence_Bomb_Boom] = SoundsEmbed.Machine_Sequence_Bomb_Boom;
			_soundsEmbed[Machine_Sequence_MiniSpin_Spin] = SoundsEmbed.Machine_Sequence_MiniSpin_Spin;
			_soundsEmbed[Machine_Sequence_MiniSpin_Stop] = SoundsEmbed.Machine_Sequence_MiniSpin_Stop;
			_soundsEmbed[Machine_Sequence_Collectibles_Blink] = SoundsEmbed.Machine_Sequence_Collectibles_Blink;
			_soundsEmbed[Machine_Sequence_Collectibles_SymbolToCollectibles] = SoundsEmbed.Machine_Sequence_Collectibles_SymbolToCollectibles;
			_soundsEmbed[Machine_Sequence_Column_Flipper2] = SoundsEmbed.Machine_Sequence_Column_Flipper2;
			_soundsEmbed[Machine_Sequence_Symetric_Flipper2] = SoundsEmbed.Machine_Sequence_Symetric_Flipper2;
			_soundsEmbed[Machine_Sequence_Strike_Blink] = SoundsEmbed.Machine_Sequence_Strike_Blink;
			_soundsEmbed[Machine_Sequence_MegaWin_Animation] = SoundsEmbed.Machine_Sequence_MegaWin_Animation;
			_soundsEmbed[Machine_Sequence_ExtraBigWin_Animation] = SoundsEmbed.Machine_Sequence_ExtraBigWin_Animation;
			_soundsEmbed[Machine_Sequence_BigWin_Animation] = SoundsEmbed.Machine_Sequence_BigWin_Animation;
			_soundsEmbed[Machine_Sequence_ToWin] = SoundsEmbed.Machine_Sequence_ToWin;
			_soundsEmbed[Machine_Sequence_FiveInARow_Animation] = SoundsEmbed.Machine_Sequence_FiveInARow_Animation;
			_soundsEmbed[Machine_Sequence_FourInARow_Animation] = SoundsEmbed.Machine_Sequence_FourInARow_Animation;
			_soundsEmbed[Machine_Sequence_BonusGame_Blink] = SoundsEmbed.Machine_Sequence_BonusGame_Blink;
			_soundsEmbed[Machine_Sequence_BonusGame_Popup_Start] = SoundsEmbed.Machine_Sequence_BonusGame_Popup_Start;
			_soundsEmbed[Machine_Sequence_BonusGame_Popup_End] = SoundsEmbed.Machine_Sequence_BonusGame_Popup_End;
			_soundsEmbed[Machine_Sequence_Multiplier_Blink] = SoundsEmbed.Machine_Sequence_Multiplier_Blink;
			_soundsEmbed[Machine_Sequence_FreeSpins_Blink] = SoundsEmbed.Machine_Sequence_FreeSpins_Blink;
			_soundsEmbed[Machine_Sequence_FreeSpins_SymbolToFreeSpinsRibbon] = SoundsEmbed.Machine_Sequence_FreeSpins_SymbolToFreeSpinsRibbon;
			_soundsEmbed[Machine_Sequence_WinToBalance] = SoundsEmbed.Machine_Sequence_WinToBalance;
			_soundsEmbed[Won] = SoundsEmbed.Won;
			_soundsEmbed[NoWin] = SoundsEmbed.NoWin;
		}
	}
}