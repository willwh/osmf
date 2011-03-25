/*****************************************************
*  
*  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.events
{
	import flash.events.Event;
	
	/**
	 * An AlternativeAudioEvent is dispatched when the properties of an AlternativeAudioTrait
	 * change.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */		
	public class AlternativeAudioEvent extends Event
	{
		/**
		 * The AlternativeAudioEvent.STREAM_CHANGE constant defines the value
		 * of the type property of the event object for a streamChange
		 * event.
		 * 
		 * @eventType STREAM_CHANGE  
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */		
		public static const STREAM_CHANGE:String = "streamChange";
		
		/**
		 * The AlternativeAudioEvent.NUM_ALTERNATIVE_AUDIO_CHANGE constant defines the value
		 * of the type property of the event object for a numAlternativeAudioChange
		 * event.
		 * 
		 * @eventType NUM_ALTERNATIVE_AUDIO_CHANGE 
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */ 
		public static const NUM_ALTERNATIVE_AUDIO_CHANGE:String = "numAlternativeAudioChange";
		
		/**
		 * Constructor.
		 * 
		 * @param type Event type.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 * @param sourceChanging Flag signaling an audio source change.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */		
		public function AlternativeAudioEvent
			( type:String
			, bubbles:Boolean=false
			, cancelable:Boolean=false
			, streamChanging:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_streamChanging = streamChanging;
		}
		
		/**
		 * The new switching value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get streamChanging():Boolean
		{
			return _streamChanging;
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new AlternativeAudioEvent(type, bubbles, cancelable, _streamChanging);
		}
		
		private var _streamChanging:Boolean;	
	}
}
