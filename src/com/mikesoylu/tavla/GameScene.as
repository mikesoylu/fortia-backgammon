package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.display.Button;
	import starling.events.*;
	
	/**
	 * @author bms
	 */
	public class GameScene extends fScene {
		/** States in a player's turn. (We use static consts because AS3 doesn't have enums) */
		private static const PLAY_STATE:String = "playState";
		private static const SKIP_STATE:String = "skipState";
		private static const ROLL_STATE:String = "rollState";
		private var state:String = PLAY_STATE;
		
		/** the container object for the pices */
		private var board:Board;
		
		/** the dice visual */
		private var diceA:Dice;
		private var diceB:Dice;
		
		/** roll dice/skip/end button */
		private var actionButton:Button;
		/** collect pieces button (invisible at the beginning) */
		private var collectButton:Button;
		
		public override function init(e:Event):void {
			super.init(e);
			
			board = new Board();
			board.addEventListener(GameEvent.TURN_ENDED, onTurnEnded);
			board.addEventListener(GameEvent.TURN_ENDED, onTurnEnded);
			addChild(board);
			
			// get width beforehand because we cant query diceA before init'ing it
			var dwidth:Number = fAssetManager.getTexture("dice.png").width / 2;
			diceA = new Dice(fGame.width * 0.75 - dwidth, fGame.height / 2);
			diceA.visible = false;
			addChild(diceA);
			
			diceB = new Dice(fGame.width * 0.75 + dwidth, fGame.height / 2);
			diceB.visible = false;
			addChild(diceB);
			
			// this is for rolling the dice/advancing game
			actionButton = new Button(fAssetManager.getTexture("button.png"), fLocalize.get("whiteTurn"));
			actionButton.pivotX = actionButton.width / 2;
			actionButton.pivotY = actionButton.height / 2 - actionButton.height;
			actionButton.x = fGame.width / 2;
			actionButton.y = fGame.height / 2;
			actionButton.addEventListener(Event.TRIGGERED, function():void {
				// select how to deal with the button depending on state
				switch(state) {
					case ROLL_STATE:
						board.advanceState( [diceA.roll(), diceB.roll()]);
						if (!diceA.visible || !diceB.visible) {
							diceA.visible = true;
							diceB.visible = true;
						}
						actionButton.text = fLocalize.get("skipTurn");
						state = SKIP_STATE;
						break;

					case SKIP_STATE:
						board.endTurn();
						actionButton.text = fLocalize.get(board.nextPlayer + "Turn");
						state = ROLL_STATE;
						break;

					case PLAY_STATE:
						actionButton.text = fLocalize.get("rollDice");
						state = ROLL_STATE;
						break;
				}
				
			});
			addChild(actionButton);
			
			// button for collecting pieces
			collectButton = new Button(fAssetManager.getTexture("button.png"), fLocalize.get("collectButton"));
			collectButton.pivotX = collectButton.width / 2;
			collectButton.pivotY = collectButton.height / 2 - collectButton.height;
			collectButton.x = fGame.width / 2;
			collectButton.y = fGame.height / 2;
			collectButton.visible = false;
			collectButton.addEventListener(Event.TRIGGERED, function():void {
				board.collect();
			});
			addChild(collectButton);
		}
		
		private function onTurnEnded(e:GameEvent):void {
			if (state == SKIP_STATE) {
				board.endTurn();
				actionButton.text = fLocalize.get(board.nextPlayer + "Turn");
				state = PLAY_STATE;
			}
		}
		
		public override function destroy():void {
			super.destroy();
			// clear variables
			removeChild(board);
			board = null;
		}
	}
}