package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.textures.Texture;
	
	/**
	 * A single checker piece
	 * @author bms
	 */
	public class Piece extends fImage {
		/** Player sides. (We use static consts because AS3 doesn't have enums) */
		public static const WHITE:String = "white";
		public static const BLACK:String = "black";
		
		public var type:String;
		public function Piece(x:Number, y:Number, type:String) {
			super(fAssetManager.getTexture(type + ".png"), x, y);
			this.type = type;
		}
	}
}