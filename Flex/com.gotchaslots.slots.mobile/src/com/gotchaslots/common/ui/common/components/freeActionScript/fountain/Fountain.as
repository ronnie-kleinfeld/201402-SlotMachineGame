﻿package com.gotchaslots.common.ui.common.components.freeActionScript.fountain{	import com.gotchaslots.common.ui.common.components.SpriteEx;	import com.greensock.TweenMax;		import flash.display.Bitmap;	import flash.events.Event;	import flash.filters.BlurFilter;
		public class Fountain extends SpriteEx	{		private var _bitmapClass:Class;		private var _bitmap:Bitmap;		private var _container:SpriteEx;		private var _mask:SpriteEx;				private var minSize:int = 10;		private var dx:Number;		private var dy:Number;				private var _popScale:Number = 2;		private var _popDuration:Number = .2;		private var _minD:Number = -2;		private var _maxD:Number = 2;		private var _maxDisplacement:Number = .5;				public function Fountain(bitmapClass:Class)		{			_bitmapClass = bitmapClass;						_container = new SpriteEx;			_bitmap = new _bitmapClass();			_bitmap.smoothing = true;						var maxSize:int = _bitmap.width;						var range:int = maxSize - minSize;			_container.scaleX = _container.scaleY = (minSize + Math.random() * range) / maxSize;						addChild(_container);			_container.addChild(_bitmap);						_container.x = -int(_container.width / 2);			_container.y = -int(_container.height / 2);		}				public function get radius():Number		{			return _container.width / 2;		}				public function pop():void		{			_mask = new SpriteEx();			_container.addChild(_mask);			_bitmap.mask = _mask;						TweenMax.to(this, _popDuration, {scaleX: _popScale, scaleY: _popScale, alpha: 0, onComplete: OnPopComplete});			_container.filters = [new BlurFilter(2, 2, 1)];		}				public function destroy():void		{			TweenMax.killTweensOf(this);		}				private function OnPopComplete():void		{			dispatchEvent(new Event(Event.COMPLETE));		}	}}