package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.display.Button;
	import starling.events.*;
	
	/**
	 * @author bms
	 */
	public class GameScene extends fScene {
		/** the container object for the pices */
		private var board:Board;
		
		/** the dice visual */
		private var diceA:Dice;
		private var diceB:Dice;
		
		/** roll dice button */
		private var rollDiceButton:Button;
		
		public override function init(e:Event):void {
			super.init(e);
			
			board = new Board();
			addChild(board);
			
			diceA = new Dice();
			diceA.visible = false;
			addChild(diceA);
			
			diceB = new Dice();
			diceB.visible = false;
			addChild(diceB);
			
			rollDiceButton = new Button(fAssetManager.getTexture("button.png"), fLocalize.get("rollButton"));
			rollDiceButton.pivotX = rollDiceButton.width / 2;
			rollDiceButton.pivotY = rollDiceButton.height / 2;
			rollDiceButton.x = fGame.width / 2;
			rollDiceButton.y = fGame.height / 2;
			rollDiceButton.addEventListener(Event.TRIGGERED, function():void {
				board.advanceState( [diceA.roll(), diceB.roll()]);
				diceA.visible = true;
				diceB.visible = true;
			});
			addChild(rollDiceButton);
		}
		
		public override function destroy():void {
			super.destroy();
			// clear variables
			removeChild(board);
			board = null;
		}
	}
}