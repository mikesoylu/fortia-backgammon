package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	
	/**
	 * @author bms
	 */
	public class Board extends fLayer {
		// lines that contain pieces, clockwise order starting from bottom right
		private var lines:Vector.<Line>;
		
		public function Board() {
			super();
			// fill in the vec so we don't get a null ref.
			lines = new Vector.<Line>();
			for (var i:int = 0; i < 24; i++) {
				var x:Number;
				var y:Number;
				if (i < 12) {
					x = Number(13 - (i + 1)) * fGame.width / 13.0;
					y = fGame.height - fAssetManager.getTexture("white.png").height;
				} else {
					x = Number(i%12 + 1) * fGame.width / 13.0;
					y = fAssetManager.getTexture("white.png").height;
				}
				lines[i] = new Line( { x:x, y:y }, i < 12);
				var marker:fImage = new fImage(fAssetManager.getTexture("marker.png"), x, y);
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
		}
		
		public override function update(dt:Number):void {
			super.update(dt);
			
		}
	}
}