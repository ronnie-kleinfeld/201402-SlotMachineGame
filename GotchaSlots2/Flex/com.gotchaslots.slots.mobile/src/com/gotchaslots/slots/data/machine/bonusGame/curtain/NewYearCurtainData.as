package com.gotchaslots.slots.data.machine.bonusGame.curtain
{
	import com.gotchaslots.slots.assets.bonusGame.curtain.newYear.NewYearEmbed;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtain.BaseCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.MotionCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainLevel.CurtainLevelData;
	
	import flash.geom.Rectangle;
	
	public class NewYearCurtainData extends BaseCurtainData
	{
		public override function get StartPopupMessage():String
		{
			return "New Year";
		}
		
		// properties
		protected override function get BGClass():Class
		{
			return null;
		}
		
		// class
		public function NewYearCurtainData()
		{
			super();
		}
		protected override function InitLevelsAndItems():void
		{
			super.InitLevelsAndItems();
			
			var curtainLevel:CurtainLevelData;
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, NewYearEmbed.FlowerBG, "NewYear", "Select an Flower", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(452, 33, 0, 0), NewYearEmbed.Flower1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(2, 20, 0, 0), NewYearEmbed.Flower2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(211, 141, 0, 0), NewYearEmbed.Flower3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(551, 137, 0, 0), NewYearEmbed.Flower4, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, NewYearEmbed.IcemanBG, "NewYear", "Select an Iceman", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(66, 243, 0, 0), NewYearEmbed.Iceman1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(243, 263, 0, 0), NewYearEmbed.Iceman2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(451, 253, 0, 0), NewYearEmbed.Iceman3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(615, 245, 0, 0), NewYearEmbed.Iceman4, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, NewYearEmbed.TreeBG, "NewYear", "Select an Tree", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(65, 186, 0, 0), NewYearEmbed.Tree2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(181, 110, 0, 0), NewYearEmbed.Tree3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(511, 244, 0, 0), NewYearEmbed.Tree4, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(643, 206, 0, 0), NewYearEmbed.Tree5, "", "", ""));
			_curtainLevels.push(curtainLevel);
		}
		protected override function InitMap():void
		{
			_mapRect = new Rectangle(590, 10, 200, 100);
		}
	}
}