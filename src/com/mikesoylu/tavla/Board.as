package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.*;
	
	/**
	 * @author bms
	 */
	public class Board extends fLayer {
		/** lines that contain pieces, clockwise order starting from bottom right */
		private var lines:Vector.<Line>;
		
		/** this is where the collected pieces stay */
		private var collectedLines:Object;
		
		/** player turn */
		private var currentPlayer:String = Piece.BLACK;
		
		/** selection related properties */
		private var selectionMarker:Quad;
		private var selectedLine:Line = null;
		private var playerIndicator:fImage;
		
		/** this holds the possible moves we can make in a turn */
		private var availableMoves:Array = [];
		
		public function Board() {
			super();
			
			// the background (this is the only touchable thing)
			var bg:Quad = new Quad(fGame.width, fGame.height, 0x111111);
			addChild(bg);
			
			playerIndicator = new fImage(fAssetManager.getTexture("select.png"), 0, fGame.height, false);
			playerIndicator.smoothing = "none";
			playerIndicator.width = fGame.width;
			playerIndicator.pivotY = playerIndicator.height;
			addChild(playerIndicator);
			
			// marker
			selectionMarker = new Quad(fAssetManager.getTexture("white.png").height, fGame.height, 0x331111);
			selectionMarker.pivotX = selectionMarker.width / 2;
			selectionMarker.visible = false;
			addChild(selectionMarker);
			
			// init the lines
			collectedLines = new Object();
			collectedLines[Piece.BLACK] = new Line( { x:-1000, y:0 }, -1, true);
			collectedLines[Piece.WHITE] = new Line( { x:-1000, y:0 }, -1, false);
			
			lines = new Vector.<Line>();
			for (var i:int = 0; i < 24; i++) {
				var x:Number;
				var y:Number;
				if (i < 12) {
					x = Number(13 - (i + 1)) * fGame.width / 13.0;
					y = fGame.height - fAssetManager.getTexture("white.png").height / 2;
				} else {
					x = Number(i%12 + 1) * fGame.width / 13.0;
					y = fAssetManager.getTexture("white.png").height / 2;
				}
				lines[i] = new Line({ x:x, y:y }, i, i < 12);
				var marker:fImage = new fImage(fAssetManager.getTexture("marker.png"), x, y);
				marker.pivotY = fAssetManager.getTexture("white.png").height;
				marker.rotation = Number(i >= 12) * Math.PI;
				addChild(marker);
			}
			
			// create the initial pieces
			lines[0].createPieces(2, this, Piece.BLACK);
			lines[5].createPieces(5, this, Piece.WHITE);
			lines[7].createPieces(3, this, Piece.WHITE);
			lines[11].createPieces(5, this, Piece.BLACK);
			
			lines[23].createPieces(2, this, Piece.WHITE);
			lines[18].createPieces(5, this, Piece.BLACK);
			lines[16].createPieces(3, this, Piece.BLACK);
			lines[12].createPieces(5, this, Piece.WHITE);
			
			// make this touchable so touch events can come from the background quad
			touchable = true;
			
			// start listening to touches
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/** this is called by the game scene, ends turn */
		public function advanceState(diceNums:Array):void {
			// add two more moves if we have a double
			if (diceNums[0] == diceNums[1]) {
				diceNums.push(diceNums[0]);
				diceNums.push(diceNums[0]);
			}
			availableMoves = diceNums;
			selectedLine = null;
			selectionMarker.visible = false;
			
			if (Piece.BLACK == currentPlayer) {
				currentPlayer = Piece.WHITE;
				playerIndicator.y = 0;
				playerIndicator.scaleY = -1;
			} else {
				currentPlayer = Piece.BLACK;
				playerIndicator.y = fGame.height;
				playerIndicator.scaleY = 1;
			}
		}
		
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this as DisplayObject);
			if (null != touch) {
				var loc:Point = touch.getLocation(this);
				if (TouchPhase.BEGAN == touch.phase) {
					var line:Line = getLineAt(loc.x, loc.y);
					var piece:Piece = line.peek();
					
					// check if we're selecting or placing the piece
					if (null == selectedLine) {
						if (null == piece || piece.type != currentPlayer || availableMoves.length == 0)
							return;
						selectedLine = line;
						selectionMarker.x = line.rootPosition.x;
						selectionMarker.visible = true;
					} else {
						// check if we can move there
						if (null != piece && piece.type != currentPlayer)
							return;
						var diff:int = line.index - selectedLine.index;
						// check if we're going backwards
						if (Piece.BLACK == currentPlayer) {
							if (diff < 0)
								return;
						} else if (diff > 0) {
							return;
						}
						// just de-select if we chose the same line
						if (diff == 0) {
							selectedLine = null;
							selectionMarker.visible = false;
							return;
						}
						// check if we have an available move
						var moveInd:int = availableMoves.indexOf(Math.abs(diff));
						if (moveInd == -1) {
							return;
						} else {
							// we have a move so splice it out
							availableMoves.splice(moveInd, 1);
						}
						
						line.push(selectedLine.pop());
						selectedLine = null;
						selectionMarker.visible = false;
					}
				}
			}
		}
		
		private function isPlayerCollecting(player:String):Boolean {
			// check if the player has pieces outside (can be optimized but not called that often)
			for (var i:int = 0; i < 24; i++) {
				var piece:Piece = lines[i].peek();
				if (null == piece || piece.type != player)
					continue;
				
				if (Piece.BLACK == player && i < 23 - 6) {
					return false;
				} else if (Piece.WHITE == player && i > 5) {
					return false;
				}
			}
			
			return true;
		}
		
		/** used to get the right piece under the touch */
		private function getLineAt(x:Number, y:Number):Line {
			var ind:int;
			// correct the position
			x -= fAssetManager.getTexture("white.png").width / 2;
			
			// figure out which line we're on
			if (y < fGame.height / 2) {
				ind = 12 + Math.floor(x / (fGame.width / 13.0));
				ind = fUtil.clamp(12, 23, ind);
			} else {
				ind = 11 - Math.floor(x / (fGame.width / 13.0));
				ind = fUtil.clamp(0, 11, ind);
			}
			// get line
			return lines[ind];
		}
	}
}