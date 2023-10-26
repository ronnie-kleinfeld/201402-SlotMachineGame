package com.gotchaslots.slots.data.machine.bonusGame.curtain
{
	import com.gotchaslots.slots.assets.bonusGame.curtain.funny.FunnyEmbed;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtain.BaseCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.MotionCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainLevel.CurtainLevelData;
	
	import flash.geom.Rectangle;
	
	public class FunnyCurtainData extends BaseCurtainData
	{
		public override function get StartPopupMessage():String
		{
			return "Funny";
		}
		
		// properties
		protected override function get BGClass():Class
		{
			return null;
		}
		
		// class
		public function FunnyCurtainData()
		{
			super();
		}
		protected override function InitLevelsAndItems():void
		{
			super.InitLevelsAndItems();
			
			var curtainLevel:CurtainLevelData;
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, FunnyEmbed.GhostBG, "Funny", "Select an Ghost", 2, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(7, 20, 0, 0), FunnyEmbed.Ghost1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(214, 62, 0, 0), FunnyEmbed.Ghost2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(105, 233, 0, 0), FunnyEmbed.Ghost3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(321, 320, 0, 0), FunnyEmbed.Ghost4, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(471, 298, 0, 0), FunnyEmbed.Ghost5, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(712, 265, 0, 0), FunnyEmbed.Ghost6, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, FunnyEmbed.HouseBG, "Funny", "Select an House", 2, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(57, 190, 0, 0), FunnyEmbed.House1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(248, 254, 0, 0), FunnyEmbed.House2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(464, 299, 0, 0), FunnyEmbed.House3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(621, 256, 0, 0), FunnyEmbed.House4, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(428, 158, 0, 0), FunnyEmbed.House5, "", "", ""));
			_curtainLevels.push(curtainLevel);
		}
		protected override function InitMap():void
		{
			_mapRect = new Rectangle(590, 10, 200, 100);
		}
	}
}