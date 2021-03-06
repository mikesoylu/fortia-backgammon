package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import flash.geom.Point;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.*;
	
	/**
	 * The checker board
	 * @author bms
	 */
	public class Board extends fLayer {
		/** number of pieces each player gets initially (readonly - set by constructor) */
		private var NUM_PLAYER_PIECES:int;
		
		/** lines that contain pieces, clockwise order starting from bottom right */
		private var lines:Vector.<Line>;
		
		/** this is where the collected pieces stay */
		private var collectedLines:Object;
		
		/** this is where the broken pieces stay */
		private var brokenLines:Object;
		
		/** player turn getters */
		private var _currentPlayer:String = Piece.BLACK;
		public function get currentPlayer():String {
			return _currentPlayer;
		}
		public function get nextPlayer():String {
			return (_currentPlayer == Piece.BLACK)? Piece.WHITE : Piece.BLACK;
		}
		
		/** selection related fields */
		private var selectionMarker:Quad;
		private var selectedLine:Line = null;
		private var playerIndicator:fImage;
		
		/** this holds the possible moves each player can make in a turn */
		private var availableMoves:Array = [];
		
		public function Board(shortGame:Boolean = false) {
			super();
			
			// the background (this is the only touchable thing)
			var bg:Quad = new Quad(fGame.width, fGame.height, 0x111111);
			addChild(bg);
			
			playerIndicator = new fImage(fAssetManager.getTexture("select.png"), 0, fGame.height, false);
			playerIndicator.smoothing = "none";
			playerIndicator.width = fGame.width;
			playerIndicator.pivotY = playerIndicator.height;
			playerIndicator.visible = false;
			playerIndicator.scaleY = 0;
			addChild(playerIndicator);
			
			// add seperator
			var seperator:Quad = new Quad(fAssetManager.getTexture("white.png").width, fGame.height, 0x181818);
			seperator.x = fGame.width / 2 - seperator.width / 2;
			seperator.touchable = false;
			addChild(seperator);
			
			// marker
			selectionMarker = new Quad(fAssetManager.getTexture("white.png").height, fGame.height, 0x2F2F2F);
			selectionMarker.pivotX = selectionMarker.width / 2;
			selectionMarker.visible = false;
			addChild(selectionMarker);
			
			// init the lines
			collectedLines = new Object();
			collectedLines[Piece.WHITE] = new Line( { x:fGame.width / 2,
				y:fGame.height + fAssetManager.getTexture("white.png").height }, -1, false);
			collectedLines[Piece.BLACK] = new Line( { x:fGame.width / 2,
				y: -fAssetManager.getTexture("white.png").height }, -1, true);
			
			brokenLines = new Object();
			brokenLines[Piece.WHITE] = new Line( { x:fGame.width / 2,
				y:fGame.height - fAssetManager.getTexture("white.png").height }, 24, true, true);
			brokenLines[Piece.BLACK] = new Line( { x:fGame.width / 2,
				y: fAssetManager.getTexture("white.png").height }, -1, false, true);
			
			lines = new Vector.<Line>();
			for (var i:int = 0; i < 24; i++) {
				var x:Number;
				var y:Number;
				
				// find where to put the pieces
				if (i < 12) {
					x = Number(13 - (i + 1)) * fGame.width / 13.0;
					y = fGame.height - fAssetManager.getTexture("white.png").height / 2;
				} else {
					x = Number(i%12 + 1) * fGame.width / 13.0;
					y = fAssetManager.getTexture("white.png").height / 2;
				}
				
				// add an offset at the middle
				if (i < 12) {
					if (i % 12 < 6)
						x += fAssetManager.getTexture("white.png").height / 2;
					else
						x -= fAssetManager.getTexture("white.png").height / 2;
				} else {
					if (i % 12 >= 6)
						x += fAssetManager.getTexture("white.png").height / 2;
					else
						x -= fAssetManager.getTexture("white.png").height / 2;
				}

				lines[i] = new Line({ x:x, y:y }, i, i < 12);
				var marker:fImage = new fImage(fAssetManager.getTexture("marker.png"), x, y);
				marker.pivotY = fAssetManager.getTexture("white.png").height;
				marker.rotation = Number(i >= 12) * Math.PI;
				if (i < 12) {
					Starling.juggler.add(fUtil.enterBelow(marker));
				} else {
					Starling.juggler.add(fUtil.enterAbove(marker));
				}
				addChild(marker);
			}
			
			// create the initial pieces
			if (shortGame) {
				lines[8].createPieces(2, this, Piece.WHITE);
				
				lines[15].createPieces(2, this, Piece.BLACK);
				
				NUM_PLAYER_PIECES = 2;
			} else {
				lines[0].createPieces(2, this, Piece.BLACK);
				lines[5].createPieces(5, this, Piece.WHITE);
				lines[7].createPieces(3, this, Piece.WHITE);
				lines[11].createPieces(5, this, Piece.BLACK);
				
				lines[23].createPieces(2, this, Piece.WHITE);
				lines[18].createPieces(5, this, Piece.BLACK);
				lines[16].createPieces(3, this, Piece.BLACK);
				lines[12].createPieces(5, this, Piece.WHITE);
				
				NUM_PLAYER_PIECES = 15;
			}
			
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
			
			// show player indicator
			if (!playerIndicator.visible) {
				playerIndicator.visible = true;
			}
			if (Piece.BLACK == _currentPlayer) {
				playerIndicator.y = fGame.height;
				Starling.juggler.tween(playerIndicator, 0.5, { scaleY:1 } );
			} else {
				playerIndicator.y = 0;
				Starling.juggler.tween(playerIndicator, 0.5, { scaleY: -1 } );
			}
			// advance turn
			_currentPlayer = nextPlayer;
			fGame.log(_currentPlayer + "player's turn");
		}
		
		/** called by game scene for easthetics */
		public function endTurnAnim():void {
			Starling.juggler.tween(playerIndicator, 0.5, { scaleY:0 } );
		}
		
		/** this is called by game scene to collect the current selected piece */
		public function collect():void {
			if (null != selectedLine && null != selectedLine.peek() &&
				null == brokenLines[_currentPlayer].peek()) {
				// sort moves so we don't use an unnecessary one
				availableMoves.sort();
				
				// find out how much we need to go to collect
				var minMove:int;
				if (_currentPlayer == Piece.BLACK)
					minMove = 23 - selectedLine.index
				else
					minMove = selectedLine.index;
				
				var moveInd:int = -1;
				// try to find a fitting move
				for (var i:int = 0; i < availableMoves.length; i++) {
					if (availableMoves[i] > minMove) {
						moveInd = i;
						break;
					}
				}
				
				if (moveInd == -1) {
					return;
				} else {
					// we have a move so splice it out
					availableMoves.splice(moveInd, 1);
					if (availableMoves.length == 0) {
						// inform game scene that we're out of moves
						dispatchEvent(new GameEvent(GameEvent.TURN_ENDED));
					}
				}
				
				collectedLines[currentPlayer].push(selectedLine.pop());
				selectedLine = null;
				selectionMarker.visible = false;
				checkPlayerHasWon();
			}
		}
		
		/** this checks if the current player has won */
		private function checkPlayerHasWon():void {
			if (collectedLines[_currentPlayer].length == NUM_PLAYER_PIECES) {
				dispatchEvent(new GameEvent(GameEvent.PLAYER_WON));
			}
		}
		
		/** make the selection indicator flicker */
		private function flickerIndicator():void {
			var callCount:int = 5;
			var timerCallback:Function = function():void {
				if (callCount-- > 0) {
					selectionMarker.visible = !selectionMarker.visible;
					Starling.juggler.delayCall(timerCallback, 0.05);
				} else {
					selectionMarker.visible = true;
				}
			}
			timerCallback();
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
						if (null == piece || piece.type != _currentPlayer || availableMoves.length == 0)
							return;
						// are we trying to select while we have broken pieces
						if (null != brokenLines[_currentPlayer].peek() && line != brokenLines[_currentPlayer])
							return;
						
						// check if we can collect
						if (canPlayerCollect())
							dispatchEvent(new GameEvent(GameEvent.CAN_COLLECT));
						
						selectedLine = line;
						selectionMarker.x = line.rootPosition.x;
						selectionMarker.visible = true;
					} else {
						// check if we can move there
						if (null != piece && piece.type != _currentPlayer && !line.hasSinglePiece()) {
							flickerIndicator();
							return;
						}
						
						var diff:int = line.index - selectedLine.index;
						// check if we're going backwards but only if we're not re-entering
						if (null == brokenLines[_currentPlayer].peek()) {
							if (Piece.BLACK == _currentPlayer) {
								if (diff < 0) {
									flickerIndicator();
									return;
								}
							} else if (diff > 0) {
								flickerIndicator();
								return;
							}
						}
						fGame.log(diff.toString());
						
						// just de-select if we chose the same line
						if (diff == 0) {
							selectedLine = null;
							selectionMarker.visible = false;
							return;
						}
						fGame.log(diff.toString());
						// check if we have an available move
						var moveInd:int = availableMoves.indexOf(Math.abs(diff));
						if (moveInd == -1) {
							flickerIndicator();
							return;
						} else {
							// we have a move so splice it out
							availableMoves.splice(moveInd, 1);
							if (availableMoves.length == 0) {
								// inform game scene that we're out of moves
								dispatchEvent(new GameEvent(GameEvent.TURN_ENDED));
							}
						}
						
						// check if we're breaking a piece
						if (line.hasSinglePiece() && null != piece && _currentPlayer != piece.type) {
							brokenLines[nextPlayer].push(line.pop());
						}
						
						line.push(selectedLine.pop());
						selectedLine = null;
						selectionMarker.visible = false;
					}
				}
			}
		}
		
		/** check if the current player can collect pieces */
		private function canPlayerCollect():Boolean {
			var player:String = _currentPlayer;
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
			
			// figure out which line we're on
			if (y < fGame.height / 2) {
				ind = 12 + Math.floor(x / (fGame.width / 13.0));
				// are we selecting the middle?
				if (ind == 18)
					return brokenLines[_currentPlayer];
				// fix a bit because of the offset in the middle
				if (ind > 18) ind--;
				ind = fUtil.clamp(12, 23, ind);
			} else {
				ind = 11 - Math.floor(x / (fGame.width / 13.0));
				// are we selecting the middle?
				if (ind == 5)
					return brokenLines[_currentPlayer];
				// fix a bit because of the offset in the middle
				if (ind < 6) ind++;
				ind = fUtil.clamp(0, 11, ind);
			}
			
			// get line
			return lines[ind];
		}
	}
}