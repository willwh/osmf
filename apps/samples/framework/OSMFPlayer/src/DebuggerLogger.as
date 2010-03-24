/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package
{
	import org.osmf.logging.ILogger;
	
	public class DebuggerLogger implements ILogger
	{
		public function DebuggerLogger(name:String, debugger:Debugger)
		{
			_category = name;
			
			this.name = name;
			this.debugger = debugger;
		}
		
		public function debug(message:String, ...rest):void
		{
			log(LEVEL_DEBUG, message, rest);
		}
		
		public function info(message:String, ...rest):void
		{
			log(LEVEL_INFO, message, rest);
		}
		
		public function warn(message:String, ...rest):void
		{
			log(LEVEL_WARN, message, rest);
		}
		
		public function error(message:String, ...rest):void
		{
			log(LEVEL_ERROR, message, rest);
		}
		
		public function fatal(message:String, ...rest):void
		{
			log(LEVEL_FATAL, message, rest);
		}
		
		public function get category():String
		{
			return _category;
		}
		
		// Internals
		//
		
		public function log(level:String, message:String, params:Array):void
		{
			var msg:String = "";
			
			// add name and params
			msg += "[" + name + "] " + applyParams(message, params);
			
			// trace the message
			debugger.send(level, msg);
		}
		
		/**
		 * Returns a string with the parameters replaced.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function applyParams(message:String, params:Array):String
		{
			var result:String = message;
			var numParams:int = params.length;
			
			for (var i:int = 0; i < numParams; i++)
			{
				result = result.replace(new RegExp("\\{" + i + "\\}", "g"), params[i]);
			}
			
			return result;
		}
		
		private var _category:String;
		private var name:String;
		private var debugger:Debugger;
		
		private static const LEVEL_DEBUG:String = "DEBUG";
		private static const LEVEL_WARN:String = "WARN";
		private static const LEVEL_INFO:String = "INFO";
		private static const LEVEL_ERROR:String = "ERROR";
		private static const LEVEL_FATAL:String = "FATAL";
	}
}