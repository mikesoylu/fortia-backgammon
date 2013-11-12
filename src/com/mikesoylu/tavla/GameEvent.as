package com.mikesoylu.tavla {
	import starling.events.Event;
	
	/**
	 * this is used to inform the Game Scene that the turn has ended
	 * @author bms
	 */
	public class GameEvent extends Event {
		/** we use static consts because AS3 doesn't have enums */
		public static const TURN_ENDED:String = "turnEnded";
		
		public function GameEvent(type:String, data:Object=null) {
			super(type, false, data);
		}
	}
}