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
		
		/** these are just booleans because there are only two players */
		private var isWhitesTurn:Boolean = true;
		private var isPlayerWhite:Boolean = true;
		
		/** selection related properties */
		private var selectionMarker:Quad;
		private var selectedLine:Line = null;
		
		public function Board() {
			super();
			
			// the background (this is the only touchable thing)
			var bg:Quad = new Quad(fGame.width, fGame.height, 0x111111);
			addChild(bg);
			
			selectionMarker = new Quad(fAssetManager.getTexture("white.png").height, fGame.height, 0x331111);
			selectionMarker.pivotX = selectionMarker.width / 2;
			addChild(selectionMarker);
			
			// fill in the vec so we don't get a null ref.
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
		
		public override function update(dt:Number):void {
			super.update(dt);
		}
		
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this as DisplayObject);
			if (null != touch) {
				var loc:Point = touch.getLocation(this);
				if (TouchPhase.BEGAN == touch.phase) {
					// check if we're selecting or placing the piece
					var line:Line = getLineAt(loc.x, loc.y);
					if (null == line)
						return;
					if (null == selectedLine) {
						selectedLine = line;
						selectionMarker.x = line.rootPosition.x;
					} else {
						line.push(selectedLine.pop());
						selectedLine = null;
					}
				}
			}
		}
		
		/** used to get the right piece under the touch */
		private function getLineAt(x:Number, y:Number):Line {
			var ind:int = 0;
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