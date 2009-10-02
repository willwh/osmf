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
	import org.osmf.media.MediaElement;
	
	import flash.events.Event;
	
	/**
	 * MediaEvent is the base class for events which are dispatched by a MediaElement. 
	 */
	public class MediaEvent extends Event
	{
		/**
		 * Constructor.
		 * 
		 * @param type The event type of the action that triggered this
		 * event.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
		 **/
		public function MediaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * The MediaElement for this event.
		 **/
		public function get media():MediaElement
		{
			return target as MediaElement;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 **/
		override public function clone():Event
		{
			return new MediaEvent(type, bubbles, cancelable);
		}
	}
}