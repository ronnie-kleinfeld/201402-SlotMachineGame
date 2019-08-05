package com.gotchaslots.slots.data.machine.bonusGame.curtain
{
	import com.gotchaslots.slots.assets.bonusGame.curtain.animals.AnimalsEmbed;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtain.BaseCurtainData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.AppearCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainItem.MotionCurtainItemData;
	import com.gotchaslots.slots.data.machine.bonusGame.curtain.curtainLevel.CurtainLevelData;
	
	import flash.geom.Rectangle;
	
	public class AnimalsCurtainData extends BaseCurtainData
	{
		public override function get StartPopupMessage():String
		{
			return "Animals";
		}
		
		// properties
		protected override function get BGClass():Class
		{
			return null;
		}
		
		// class
		public function AnimalsCurtainData()
		{
			super();
		}
		protected override function InitLevelsAndItems():void
		{
			super.InitLevelsAndItems();
			
			var curtainLevel:CurtainLevelData;
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, AnimalsEmbed.AnimalBG, "Animals", "Select an Animal", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(179, 226, 160, 135), AnimalsEmbed.Animal2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(485, 275, 155, 145), AnimalsEmbed.Animal3, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, AnimalsEmbed.DragonBG, "Animals", "Select an Dragon", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(0, 69, 350, 350), AnimalsEmbed.Dragon3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(670, 313, 89, 77), AnimalsEmbed.Dragon5, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, AnimalsEmbed.GroundhogBG, "Animals", "Select an Groundhog", 1, true);
			curtainLevel.CurtainItems.push(new AppearCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(-11, 194, 360, 268), AnimalsEmbed.Groundhog1, "", "", ""));
			curtainLevel.CurtainItems.push(new AppearCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(466, 262, 147, 108), AnimalsEmbed.Groundhog2, "", "", ""));
			curtainLevel.CurtainItems.push(new AppearCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(665, 251, 99, 89), AnimalsEmbed.Groundhog3, "", "", ""));
			_curtainLevels.push(curtainLevel);
			
			curtainLevel = new CurtainLevelData(_curtainLevels.length, AnimalsEmbed.MonkeyBG, "Animals", "Select an Monkey", 1, true);
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(20, 205, 130, 180), AnimalsEmbed.Monkey1, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(218, 21, 85, 98), AnimalsEmbed.Monkey2, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(269, 316, 115, 98), AnimalsEmbed.Monkey3, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(461, 264, 87, 138), AnimalsEmbed.Monkey4, "", "", ""));
			curtainLevel.CurtainItems.push(new MotionCurtainItemData(curtainLevel.CurtainItems.length, new Rectangle(592, 220, 208, 182), AnimalsEmbed.Monkey5, "", "", ""));
			_curtainLevels.push(curtainLevel);
		}
		protected override function InitMap():void
		{
			_mapRect = new Rectangle(590, 10, 200, 100);
		}
	}
}