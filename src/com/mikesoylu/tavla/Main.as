package com.mikesoylu.tavla {
	import com.mikesoylu.fortia.*;
	import flash.desktop.*;
	import flash.events.*;
	import flash.display.*;
	import flash.ui.*;
	
	/**
	 * @author bms
	 */
	public class Main extends fGame {
		
		public function Main():void {
			super(MenuScene);
			
			fLocalize.addDictionary({
				playButton: "Play"
			});
			
			// listen to deactivation
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		
		private function deactivate(e:Event):void {
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
		}
	}
}