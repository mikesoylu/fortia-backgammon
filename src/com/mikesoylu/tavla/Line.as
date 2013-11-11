package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import flash.geom.Vector3D;
	/**
	 * @author bms
	 */
	public class Line {
		/** the position of the first piece in the line */
		public var rootPosition:Vector3D;
		
		private var pieces:Vector.<Piece>;
		/** the direction of piece placement */
		private var expandUpwards:Boolean = true;
		
		private static const PIECE_PLACEMENT_FACTOR:Number = 0.5;
		
		/** this takes an object for the pos param because Object literals look good in code */
		public function Line(pos:Object, expandUpwards:Boolean) {
			// fill in the instance properties
			rootPosition = new Vector3D(pos.x, pos.y);
			this.expandUpwards = expandUpwards;
			// init the list
			pieces = new Vector.<Piece>();
		}
		
		public function pop():Piece {
			if (pieces.length > 0)
				return pieces.pop();
			return null;
		}
		
		public function peek():Piece {
			if (pieces.length > 0)
				return pieces[pieces.length - 1];
			return null;
		}
		
		public function push(p:Piece):void {
			p.x = rootPosition.x;
			p.y = rootPosition.y + (expandUpwards ? -1.0 : 1.0) *
				pieces.length * p.height * PIECE_PLACEMENT_FACTOR;
			pieces.push(p);
		}
		
		/** creates num new pieces in the line */
		public function createPieces(num:int, root:fLayer, type:String):void {
			while (num > 0) {
				var np:Piece = new Piece(rootPosition.x, rootPosition.y, type);
				root.addChild(np);
				np.y += (expandUpwards ? -1.0 : 1.0) * pieces.length * np.height * PIECE_PLACEMENT_FACTOR;
				pieces.push(np);
				num--;
			}
		}
	}
}