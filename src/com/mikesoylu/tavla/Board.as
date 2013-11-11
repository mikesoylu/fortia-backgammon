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
		/** this is where the broken pieces stay */
		private var brokenLines:Object;
		
		/** player turn */
		private var currentPlayer:String = Piece.BLACK;
		
		/** selection related properties */
		private var selectionMarker:Quad;
		private var selectedLine:Line = null;
		
		public function Board() {
			super();
			
			// the background (this is the only touchable thing)
			var bg:Quad = new Quad(fGame.width, fGame.height, 0x111111);
			addChild(bg);
			
			// marker
			selectionMarker = new Quad(fAssetManager.getTexture("white.png").height, fGame.height, 0x331111);
			selectionMarker.pivotX = selectionMarker.width / 2;
			selectionMarker.visible = false;
			addChild(selectionMarker);
			
			// init the lines
			brokenLines = new Object();
			brokenLines[Piece.BLACK] = new Line( { x:0, y:0 }, true);
			brokenLines[Piece.WHITE] = new Line( { x:0, y:0 }, false);
			
			collectedLines = new Object();
			collectedLines[Piece.BLACK] = new Line( { x:0, y:0 }, true);
			collectedLines[Piece.WHITE] = new Line( { x:0, y:0 }, false);
			
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
				lines[i] = new Line({ x:x, y:y }, i < 12);
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
			
			// make this touchable so touch events can come from the background
			touchable = true;
			
			// start listening to touches
			addEventListener(TouchEvent.TOUCH, onTouch);
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
						if (null == piece || piece.type != currentPlayer)
							return;
						selectedLine = line;
						selectionMarker.x = line.rootPosition.x;
						selectionMarker.visible = true;
					} else {
						// check if we can move there
						if (null != piece && piece.type != currentPlayer &&
							!line.hasSinglePiece())
							return;
						
						// check if we're breaking a piece with this move
						if (null != piece  &&
							(piece.type != currentPlayer && line.hasSinglePiece())) {
							// breaking
						}
						line.push(selectedLine.pop());
						selectedLine = null;
						selectionMarker.visible = false;
					}
				}
			}
		}
		
		private function isPlayerCollecting(player:String):Boolean {
			// you can't collect if you have a broken tile
			if (null != brokenLines[player].peek())
				return false;
			
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