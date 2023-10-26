package com.gotchaslots.common.utils.sounds
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.utils.consts.CommonConsts;
	import com.gotchaslots.common.utils.error.NotImplementedError;
	
	import flash.events.Event;
	import flash.media.AudioPlaybackMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class CommonSoundsManager
	{
		// members
		protected var _soundsEmbed:Dictionary;
		protected var _soundChannels:Dictionary;
		
		// class
		public function CommonSoundsManager()
		{
			InitSounds();
			_soundChannels = new Dictionary();
			
			SoundMixer.soundTransform = new SoundTransform(CommonConsts.DEFAULT_VOLUME);
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.VolumeChanged, OnVolumeChanged);
		}
		protected function InitSounds():void
		{
			throw new NotImplementedError();
		}
		public function Dispose():void
		{
			StopAll();
			_soundsEmbed = new Dictionary();
			_soundChannels = new Dictionary();
		}
		
		// methods
		public function Play(key:String, repeat:Boolean = false):void
		{
			try
			{
				if (Main.Instance.Session.Rare.Volume)
				{
					var sound:Sound;
					var soundChannel:SoundChannel = new SoundChannel();
					
					if (_soundChannels[key] == null)
					{
						sound = new _soundsEmbed[key]()
					}
					else
					{
						sound = _soundChannels[key];
					}
					
					if (sound != null)
					{
						soundChannel = sound.play(0, repeat ? 9999 : 0);
					}
				}
			}
			catch (error:Error)
			{
			}
		}
		public function Stop(key:String):void
		{
			if (_soundChannels[key])
			{
				SoundChannel(_soundChannels[key]).stop();
			}
		}
		public function StopAll():void
		{
			for (var key:String in _soundChannels)
			{
				SoundChannel(_soundChannels[key]).stop();
			}
		}
		
		// events
		protected function OnVolumeChanged(event:Event):void
		{
			StopAll();
		}
	}
}