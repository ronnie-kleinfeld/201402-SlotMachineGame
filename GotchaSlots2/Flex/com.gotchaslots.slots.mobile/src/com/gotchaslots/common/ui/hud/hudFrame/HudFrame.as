package com.gotchaslots.common.ui.hud.hudFrame
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.schedulers.scheduler.base.BaseScheduler;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	
	import flash.display.Bitmap;
	
	public class HudFrame extends BasePng
	{
		// class
		public function HudFrame()
		{
			var scheduler:BaseScheduler = Main.Instance.Application.Schedulers.GetCurrentSchedule();
			var bitmap:Bitmap;
			if (scheduler && scheduler.FrameClass)
			{
				bitmap = new scheduler.FrameClass();
			}
			
			super(Main.Instance.Device.DesignRectangle.width, Main.Instance.Device.DesignRectangle.height, bitmap);
			
			mouseEnabled = false;
		}
	}
}