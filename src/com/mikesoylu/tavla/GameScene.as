package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.events.*;
	
	/**
	 * @author bms
	 */
	public class GameScene extends fScene {
		private var board:Board;
		private var isWhitesTurn:Boolean = true;
		private var dice:Dice;
		
		public function GameScene() {
			super();
		}
		
		public override function init(e:Event):void {
			super.init(e);
			
			board = new Board();
			addChild(board);
			
			dice = new Dice();
			addChild(dice);
		}
		
		public override function update(dt:Number):void {
			super.update(dt);
		}
		
		public override function destroy():void {
			super.destroy();
			// clear variables
			removeChild(board);
			board = null;
		}
	}
}