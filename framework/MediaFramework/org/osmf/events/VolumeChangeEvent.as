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
	 * A trait that implements the IAudible interface dispatches
	 * this event when its <code>volume</code> property has changed.
	 */	
	public class VolumeChangeEvent extends TraitEvent
	{
		/**
		 * The VolumeChangeEvent.VOLUME_CHANGE constant defines the value
		 * of the type property of the event object for a volumeChange
		 * event.
		 * 
		 * @eventType VOLUME_CHANGE 
		 */	
		public static const VOLUME_CHANGE:String = "volumeChange";
		
		/**
		 * Constructor
		 * 
		 * @param oldVolume Previous volume.
		 * @param newVolume New volume.
		 */		
		public function VolumeChangeEvent(oldVolume:Number, newVolume:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_oldVolume = oldVolume;
			_newVolume = newVolume;
			
			super(VOLUME_CHANGE, bubbles, cancelable);
		}
		
		/**
		 * Old <code>volume</code> value before it was changed. 
		 */		
		public function get oldVolume():Number
		{
			return _oldVolume;
		}
		
		/**
		 * New <code>volume</code> value resulting from this change.
		 */		
		public function get newVolume():Number
		{
			return _newVolume;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new VolumeChangeEvent(_oldVolume,_newVolume,bubbles,cancelable);
		}
		
		// Internals
		//
		
		private var _oldVolume:Number;
		private var _newVolume:Number;
		
	}
}