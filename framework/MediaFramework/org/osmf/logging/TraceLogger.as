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
	 * This class implements the ILogger interface. This is just a 
	 * "bare-bone" implementation. It intends to provide a quick out-of-box
	 * logging solution. It writes all the messages to the debug console. 
	 * However, it does not allow users to do message-level-based logging
	 * control.
	 */
	public class TraceLogger implements ILogger
	{
		public function TraceLogger(name:String)
		{
			this.name = name;
		}

		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ...params):void
		{
			log(LEVEL_DEBUG, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ...params):void
		{
			log(LEVEL_INFO, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ...params):void
		{
			log(LEVEL_WARN, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ...params):void
		{
			log(LEVEL_ERROR, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ...params):void
		{
			log(LEVEL_FATAL, message, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean
		{
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean
		{
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean
		{
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean
		{
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean
		{
			return true;
		}

		// internal
		//
		
		/**
		 * This function does the actual logging - sending the message to the debug 
		 * console using the trace statement. It also applies the parameters, if any, 
		 * to the message string.
		 */
		protected function log(level:String, message:String, params:Array):void
		{
			var msg:String = "";
			
			// add datetime
			msg += new Date().toLocaleString() + " [" + level + "] ";
			
			// add name and params
			msg += "[" + name + "] " + applyParams(message, params);
			
			// trace the message
			trace(msg);
		}
		
		/**
		 * Returns a string with the parameters replaced.
		 */
		protected function applyParams(message:String, params:Array):String
		{
			var result:String = message;
			var numParams:int = params.length;
			
			for (var i:int = 0; i < numParams; i++)
			{
				result = result.replace(new RegExp("\\{" + i + "\\}", "g"), params[i]);
			}
			
			return result;
		}
		
		private var name:String;
		
		private static const LEVEL_DEBUG:String = "DEBUG";
		private static const LEVEL_WARN:String = "WARN";
		private static const LEVEL_INFO:String = "INFO";
		private static const LEVEL_ERROR:String = "ERROR";
		private static const LEVEL_FATAL:String = "FATAL";
	}
}