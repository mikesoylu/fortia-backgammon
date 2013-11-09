package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.display.Button;
	import starling.events.*;
	
	/**
	 * @author bms
	 */
	public class MenuScene extends fScene {
		
		public function MenuScene() {
			super();
		}
		
		public override function init(e:Event):void {
			super.init(e);
			var playButton = new Button(fAssetManager.getTexture("button"), fLocalize.get("playButton"));
			addChild(playButton);
		}
		
		public override function update(dt:Number):void {
			super.update(dt);
		}
		
		public override function destroy():void {
			super.destroy();
		}
	}
}