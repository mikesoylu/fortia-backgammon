package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.animation.Transitions;
	import starling.core.Starling;
	
	/**
	 * @author bms
	 */
	public class Dice extends fSprite {
		private var dots:Vector.<fImage>;
		private var restX:Number = 0;
		private var restY:Number = 0;
		public function Dice(restX:Number, restY:Number) {
			super();
			this.restX = restX;
			this.restY = restY;
			var bg:fImage = new fImage(fAssetManager.getTexture("dice.png"));
			addChild (bg);
			
			// fill in the dots but make them invisible
			dots = new Vector.<fImage>();
			for (var i:int = 0; i < 6; i++) {
				var dot:fImage = new fImage(fAssetManager.getTexture("diceMarker.png"));
				dot.visible = false;
				dots.push(dot);
				addChild(dot);
			}
		}
		
		/** roll the dice */
		public function roll():int {
			var rand:int = Math.floor(Math.random() * 6) + 1;
			// double check the number
			rand = fUtil.clamp(1, 6, rand);
			
			// update gfx
			setDotsToNumber(rand);
			
			x = -width;
			y = fGame.height / 2;
			
			// do dice roll animation
			var dx:Number = (Math.random() + 0.25) * fGame.width * 0.5;
			var dy:Number = (Math.random() + 0.25) * fGame.height * 0.5;
			Starling.juggler.tween(this, 0.5, { transition:Transitions.EASE_OUT, scale:1, x:dx, y:dy } );
			
			// place dice to its resting place after some time
			Starling.juggler.tween(this, 0.5, { transition:Transitions.EASE_OUT, scale:0.5, x:restX, y:restY, delay:2 } );
			return rand;
		}
		
		/** this is used to update the graphics of the dice. num must be [1, 6] */
		private function setDotsToNumber(num:int):void {
			// fix the num
			num--;
			// set graphics accordingly
			for (var i:int = 0; i < 6; i++) {
				var dot:fImage = dots[i];
				if (i > num) {
					dot.visible = false;
					continue;
				}
				dot.x = (i % 3 - 1) * fAssetManager.getTexture("dice.png").width * 0.2;
				dot.y = (Math.floor(i / 3.0) - 0.5) * fAssetManager.getTexture("dice.png").width * 0.4;
				dot.visible = true;
			}
		}
	}
}