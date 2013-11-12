package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.*;
	
	/**
	 * A simple menu scene
	 * @author bms
	 */
	public class MenuScene extends fScene {
		private var playButton:Button;
		private var playShortButton:Button;
		
		public override function init(e:Event):void {
			super.init(e);
			playButton = new Button(fAssetManager.getTexture("button.png"), fLocalize.get("playButton"));
			playButton.pivotX = playButton.width / 2;
			playButton.pivotY = playButton.height / 2;
			playButton.x = fGame.width / 2;
			playButton.y = fGame.height / 2 - playButton.height;
			playButton.addEventListener(Event.TRIGGERED, function():void {
				fGame.scene = new GameScene();
			});
			addChild(playButton);
			
			// add a short game button (for debug)
			playShortButton = new Button(fAssetManager.getTexture("button.png"), fLocalize.get("playShortButton"));
			playShortButton.pivotX = playShortButton.width / 2;
			playShortButton.pivotY = playShortButton.height / 2;
			playShortButton.x = fGame.width / 2;
			playShortButton.y = fGame.height / 2 + playShortButton.height;
			playShortButton.addEventListener(Event.TRIGGERED, function():void {
				fGame.scene = new GameScene(true);
			});
			addChild(playShortButton);
			
			Starling.juggler.add(fUtil.enterAbove(playButton));
			Starling.juggler.add(fUtil.enterBelow(playShortButton));
		}
		public override function destroy():void {
			super.destroy();
			
			// stay safe
			removeChild(playButton);
			removeChild(playShortButton);
			playButton = null;
			playShortButton = null;
		}
	}
}