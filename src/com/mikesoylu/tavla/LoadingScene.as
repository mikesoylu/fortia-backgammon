package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import com.mikesoylu.tavla.assets.*;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * We'll do all the loading and setup here
	 * @author bms
	 */
	public class LoadingScene extends fScene {
		
		public override function init(e:Event):void {
			super.init(e);
			
			// add localization dictionaries (ideally should be a json file)
			fLocalize.addDictionary({
				playButton: "Play Game",
				playShortButton: "Play Short Game",
				loading: "Loading...",
				rollDice: "Roll Dice",
				collectButton: "Collect Piece",
				endTurn: "End Turn",
				whiteTurn: "Start White's Turn",
				blackTurn: "Start Black's Turn",
				skipTurn: "Skip Turn",
				whiteWon: "White Won!",
				blackWon: "Black Won!"
			});
			
			// show a loading text
			var loadingText:TextField = new TextField(100, 40, fLocalize.get("loading"));
			loadingText.pivotX = loadingText.width / 2;
			loadingText.pivotY = loadingText.height / 2;
			loadingText.x = fGame.width / 2;
			loadingText.y = fGame.height / 2;
			addChild(loadingText);
			
			// add a game asset manager
			fAssetManager.addManager("game");
			// decide which assets to use
			if (fGame.isHighDefinition)
				fAssetManager.enqueue("game", HDAssets);
			else
				fAssetManager.enqueue("game", SDAssets);
			
			fAssetManager.loadQueues(function():void {
				// change scene on load
				fGame.scene = new MenuScene();
			});
		}
	}
}