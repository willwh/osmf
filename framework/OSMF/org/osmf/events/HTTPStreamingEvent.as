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
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.events
{
	import flash.events.Event;

	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataMode;
	
	[ExcludeClass]
	
	/**
	 * @private
	 *
	 * This is an event class for common stream events. The stream could be 
	 * http stream or any other types of stream.
	 * 
	 */ 
	public class HTTPStreamingEvent extends Event
	{
		/**
		 * Dispatched when the end of a fragment/chunk has been reached.
		 */
		public static const FRAGMENT_END:String = "fragmentEnd";
		
		/**
		 * Dispatched when the duration of the current fragment/chunk has been calculated.
		 */
		public static const FRAGMENT_DURATION:String = "fragmentDuration";

		/**
		 * Dispatched when the file handler has encounter an error.
		 */
		public static const FILE_ERROR:String = "fileError";
		
		/**
		 * Dispatched when the index handler has encouter an error.
		 */
		public static const INDEX_ERROR:String = "indexError";
		
		/**
		 * Dispacthed when script data needs to be passed between streaming objects.
		 */
		public static const SCRIPT_DATA:String = "scriptData";

		/**
		 * Default constructor.
		 */
		public function HTTPStreamingEvent(
				type:String, 
				bubbles:Boolean = false, 
				cancelable:Boolean = false,
				fragmentDuration:Number = 0,
				scriptDataObject:FLVTagScriptDataObject = null,
				scriptDataMode:String = FLVTagScriptDataMode.NORMAL
				)
		{
			super(type, bubbles, cancelable);
			
			_fragmentDuration = fragmentDuration;
			_scriptDataObject = scriptDataObject;
			_scriptDataMode   = scriptDataMode;
		}
		
		/**
		 * Fragment duration.
		 */
		public function get fragmentDuration():Number
		{
			return _fragmentDuration;
		}
		
		/**
		 * Script data object.
		 */
		public function get scriptDataObject():FLVTagScriptDataObject
		{
			return _scriptDataObject;
		}
		
		/**
		 * Script data mode.
		 */
		public function get scriptDataMode():String
		{
			return _scriptDataMode;
		}

		/**
		 * Clones the event.
		 */
		override public function clone():Event
		{
			return new HTTPStreamingEvent(
							type, 
							bubbles, 
							cancelable, 
							fragmentDuration, 
							scriptDataObject, 
							scriptDataMode
					);
		}
		
		/// Internals
		private var _fragmentDuration:Number;
		private var _scriptDataObject:FLVTagScriptDataObject;
		private var _scriptDataMode:String;
	}
}