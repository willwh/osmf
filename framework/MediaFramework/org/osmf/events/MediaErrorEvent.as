/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.events
{
	import flash.events.Event;
	
	/**
	 * A MediaElement dispatches a MediaErrorEvent when it encounters an error. 
	 */
	public class MediaErrorEvent extends MediaEvent
	{
		/**
		 * The MediaErrorEvent.MEDIA_ERROR constant defines the value of the
		 * type property of the event object for a mediaError event.
		 * 
		 * @eventType MEDIA_ERROR 
		 */	
		public static const MEDIA_ERROR:String = "mediaError";

		/**
		 * Constructor.
		 * 
		 * @param error The error that this event encapsulates.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 **/
		public function MediaErrorEvent(error:MediaError, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(MEDIA_ERROR, bubbles, cancelable);
			
			_error = error;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new MediaErrorEvent(error, bubbles, cancelable);
		}
		
		/**
		 * The error that this event encapsulates.
		 **/
		public function get error():MediaError
		{
			return _error;
		}
		
		private var _error:MediaError;
	}
}