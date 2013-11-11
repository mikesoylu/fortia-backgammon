package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.display.Button;
	import starling.events.*;
	
	/**
	 * @author bms
	 */
	public class MenuScene extends fScene {
		private var playButton:Button;
		
		public override function init(e:Event):void {
			super.init(e);
			playButton = new Button(fAssetManager.getTexture("button.png"), fLocalize.get("playButton"));
			playButton.pivotX = playButton.width / 2;
			playButton.pivotY = playButton.height / 2;
			playButton.x = fGame.width / 2;
			playButton.y = fGame.height / 2;
			playButton.addEventListener(Event.TRIGGERED, function():void {
				fGame.scene = new GameScene();
			});
			addChild(playButton);
		}
	}
}