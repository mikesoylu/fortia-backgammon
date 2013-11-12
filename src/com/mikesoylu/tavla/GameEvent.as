package com.mikesoylu.tavla {
	import starling.events.Event;
	
	/**
	 * this is used to inform the game scene about game states
	 * @author bms
	 */
	public class GameEvent extends Event {
		/** we use static consts because AS3 doesn't have enums */
		public static const TURN_ENDED:String = "turnEnded";
		public static const PLAYER_WON:String = "playerWon";
		public static const CAN_COLLECT:String = "canCollect";
		
		public function GameEvent(type:String, data:Object=null) {
			super(type, false, data);
		}
	}
}