package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import flash.geom.Vector3D;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	/**
	 * A line of pieces
	 * @author bms
	 */
	public class Line {
		/** the position of the first piece in the line */
		public var rootPosition:Vector3D;
		
		/** the index of the line according to Board.lines */
		public var index:int;
		
		private var pieces:Vector.<Piece>;
		/** the direction of piece placement */
		private var expandUpwards:Boolean = true;
		
		private static const PIECE_PLACEMENT_FACTOR:Number = 0.5;
		
		/** this is used to compress the pieces so they're more tightly packed */
		private var compress:Boolean;
		
		/** this takes an object {x,y} for the pos param because Object literals look good in code */
		public function Line(pos:Object, index:int, expandUpwards:Boolean, compress:Boolean = false) {
			// fill in the instance properties
			this.index = index;
			this.expandUpwards = expandUpwards;
			this.compress = compress;
			rootPosition = new Vector3D(pos.x, pos.y);
			
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
		
		public function get length():uint {
			return pieces.length;
		}
		
		public function hasSinglePiece():Boolean {
			return 1 == pieces.length;
		}
		
		public function push(p:Piece):void {
			// pull piece to front
			var prn:DisplayObjectContainer = p.parent;
			p.removeFromParent(false);
			prn.addChild(p);
			
			// update position
			var x:Number = rootPosition.x;
			var y:Number = rootPosition.y + (expandUpwards ? -1.0 : 1.0) *
				pieces.length * p.height * PIECE_PLACEMENT_FACTOR * (compress?0.5:1);
			Starling.juggler.tween(p, 0.5, { transition:Transitions.EASE_IN_OUT, x:x, y:y } );
			
			// register
			pieces.push(p);
		}
		
		/** creates num new pieces in the line */
		public function createPieces(num:int, root:fLayer, type:String):void {
			while (num > 0) {
				var np:Piece = new Piece(rootPosition.x, rootPosition.y, type);
				root.addChild(np);
				np.y += (expandUpwards ? -1.0 : 1.0) * pieces.length * np.height * PIECE_PLACEMENT_FACTOR * (compress?0.5:1);
				pieces.push(np);

				// animate
				if (np.y > fGame.height/2)
					Starling.juggler.add(fUtil.enterBelow(np));
				else
					Starling.juggler.add(fUtil.enterAbove(np));
				num--;
			}
		}
	}
}