package org.openvideoplayer.events
{
	import flash.events.Event;
	
	/**
	 * A MediaPlayer dispatches this event
	 * when its <code>playhead</code> property has changed.
	 * This value is updated at the interval set by 
	 * the MediaPlayer's <code>playheadUpdateInterval</code> property.
	 * @see org.openvideoplayer.players.MediaPlayer#playhead
	 */	     
	public class PlayheadChangeEvent extends TraitEvent
	{       	
		/**
		 * The PlayheadChangeEvent.PLAYHEAD_CHANGE constant defines the value of the
		 * type property of the event object for a playheadChange event. 
		 */	
		public static const PLAYHEAD_CHANGE:String = "playheadChange";
			
		/**
		 * Constructor
		 * 
		 * 
		 * @param newPosition New position of the playhead.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 */		
		public function PlayheadChangeEvent(newPosition:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			_newPosition = newPosition;
			
			super(PLAYHEAD_CHANGE, bubbles, cancelable);
		}
			
		/**
		 * New value of <code>position</code> resulting from this change. 
		 */		
		public function get newPosition():Number
		{
			return _newPosition;
		}
					
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new PlayheadChangeEvent(_newPosition, bubbles, cancelable);
		}
			
		// Internals
		//
				
		private var _newPosition:Number;		    
	}
}
		
