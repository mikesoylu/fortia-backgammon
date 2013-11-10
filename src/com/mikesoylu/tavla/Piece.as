package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.textures.Texture;
	
	/**
	 * @author bms
	 */
	public class Piece extends fImage {
		public static const WHITE:String = "white";
		public static const BLACK:String = "black";
		
		public var type:String;
		public function Piece(x:Number, y:Number, type:String) {
			super(fAssetManager.getTexture(type + ".png"), x, y);
			this.type = type;
		}
	}
}