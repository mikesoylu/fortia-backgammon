package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.fAssetManager;
	import com.mikesoylu.fortia.fImage;
	import com.mikesoylu.fortia.fSprite;
	
	/**
	 * @author bms
	 */
	public class Dice extends fSprite {
		private var dots:Vector.<fImage>;
		public function Dice() {
			super();
			var bg:fImage = new fImage(fAssetManager.getTexture("dice.png"));
			addChild (bg);
			
			// fill in the dots but make them invisible
			dots = new Vector.<fImage>();
			for (var i:int = 0; i < 6; i++) {
				var dot:fImage = new fImage(fAssetManager.getTexture("marker.png"));
				dot.visible = false;
				dots.push(dot);
				addChild(dot);
			}
		}
		
		/** this is used to update the graphics of the dice */
		public function setDotsToNumber(num:int):void {
			if (num < 1 || num > 6) {
				throw new Error(num + " is not a valid die number");
			}
			for (var i:int = 0; i < 6; i++) {
				if (i + 1 > num) {
					dot.visible = false;
					continue;
				}
				var dot:fImage = dots[i];
				dot.x = (i % 3 - 1) * fAssetManager.getTexture("dice.png").width * 0.2;
				dot.y = (i / 3 - 0.5) * fAssetManager.getTexture("dice.png").width * 0.4;
				dot.visible = true;
			}
		}
	}
}