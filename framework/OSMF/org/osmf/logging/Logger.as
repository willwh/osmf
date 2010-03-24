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
package org.osmf.logging
{
	/**
	 * Logger defines the capabilities of a logger, the object that OSMF
	 * applications interact with to write logging messages.
	 * 
	 * Logging messages are designated with the following levels:
	 * 
	 * DEBUG: Designates informational level messages that are fine 
	 * 		grained and most helpful when debugging an application.
	 * 
	 * INFO: Designates informational messages that highlight the progress 
	 * 		of the application at coarse-grained level.
	 * 
	 * WARN: Designates events that could be harmful to the application operation.
	 * 
	 * ERROR: Designates error events that might still allow the application 
	 * 		to continue running.
	 * 
	 * FATAL: Designates events that are very harmful and will eventually lead 
	 * 		to application failure.
	 * 
	 * The message logging functions take the format of 
	 * 	function_name(message:String, ...rest):void
	 * 
	 * Where:
	 * 		message:String — The information to log. This string can contain 
	 * 			special marker characters of the form {x}, where x is a zero 
	 * 			based index that will be replaced with the additional parameters 
	 * 			found at that index if specified.
	 * 
	 * 		...rest — Additional parameters that can be subsituted in the str 
	 * 			parameter at each "{x}" location, where x is an integer (zero based) 
	 * 			index value into the Array of values specified. 
	 * 
	 * 			for instance:       
	 * 				logger.debug("here is some channel info {0} and {1}", 15.4, true);
	 * 				This will log the following String:
	 * 					"here is some channel info 15.4 and true"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class Logger
	{
		/**
		 * Constructor.
		 * 
		 * @param category The category value for the logger.
		 **/
		public function Logger(category:String)
		{
			super();
			
			_category = category;
		}
		
		/**
		 * The category value for the logger.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 **/
		public function get category():String
		{
			return _category;
		}
		
		/**
		 * Logs a message with a "debug" level.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function debug(message:String, ... rest):void
		{
		}
		
		/**
		 * Logs a message with a "info" level.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function info(message:String, ... rest):void
		{
		}
		
		/**
		 * Logs a message with a "warn" level.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function warn(message:String, ... rest):void
		{
		}
		
		/**
		 * Logs a message with a "error" level.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function error(message:String, ... rest):void
		{
		}
		
		/**
		 * Logs a message with a "fatal" level.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function fatal(message:String, ... rest):void
		{
		}
		
		private var _category:String;
	}
}