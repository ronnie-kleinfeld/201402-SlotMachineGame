package com.gotchaslots.slots.data.machine.bonusGame.curtain
{
	import com.gotchaslots.slots.assets.bonusGame.curtain.traffic.TrafficEmbed;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtain.BaseCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.MotionCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainLevel.CurtainLevelData;
	
	import flash.geom.Rectangle;
	
	public class TrafficCurtainData extends BaseCurtainData
	{
		public override function get StartPopupMessage():String
		{
			return "Traffic";
		}
		
		// properties
		protected override function get BGClass():Class
		{
			return null;
		}
		
		// class
		public function TrafficCurtainData()
		{
			super();
		}
		protected override function InitLevelsAndItems():void
		{
			super.InitLevelsAndItems();
			
			var curtainLevel:CurtainLevelData;
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, TrafficEmbed.TrainBG, "Traffic", "Select an Train", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(76, 142, 0, 0), TrafficEmbed.Train1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(-88, 188, 0, 0), TrafficEmbed.Train2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(412, 253, 0, 0), TrafficEmbed.Train3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(523, 225, 0, 0), TrafficEmbed.Train4, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(207, 350, 0, 0), TrafficEmbed.Train5, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(211, 211, 0, 0), TrafficEmbed.Train6, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, TrafficEmbed.TruckBG, "Traffic", "Select an Truck", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(27, 277, 0, 0), TrafficEmbed.Truck1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(176, 256, 0, 0), TrafficEmbed.Truck2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(412, 282, 0, 0), TrafficEmbed.Truck6, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(655, 257, 0, 0), TrafficEmbed.Truck5, "", "", ""));
			_curtainLevels.push(curtainLevel);
		}
		protected override function InitMap():void
		{
			_mapRect = new Rectangle(590, 10, 200, 100);
		}
	}
}