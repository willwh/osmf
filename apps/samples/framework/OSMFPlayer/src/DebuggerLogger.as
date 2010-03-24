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
	import org.osmf.logging.Logger;
	
	public class DebuggerLogger extends Logger
	{
		public function DebuggerLogger(category:String, debugger:Debugger)
		{
			super(category);
			
			this.debugger = debugger;
		}
		
		override public function debug(message:String, ...rest):void
		{
			logMessage(LEVEL_DEBUG, message, rest);
		}
		
		override public function info(message:String, ...rest):void
		{
			logMessage(LEVEL_INFO, message, rest);
		}
		
		override public function warn(message:String, ...rest):void
		{
			logMessage(LEVEL_WARN, message, rest);
		}
		
		override public function error(message:String, ...rest):void
		{
			logMessage(LEVEL_ERROR, message, rest);
		}
		
		override public function fatal(message:String, ...rest):void
		{
			logMessage(LEVEL_FATAL, message, rest);
		}
		
		// Internals
		//
		
		private function logMessage(level:String, message:String, params:Array):void
		{
			var msg:String = "";
			
			// add name and params
			msg += "[" + category + "] " + applyParams(message, params);
			
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
		
		private var debugger:Debugger;
		
		private static const LEVEL_DEBUG:String = "DEBUG";
		private static const LEVEL_WARN:String = "WARN";
		private static const LEVEL_INFO:String = "INFO";
		private static const LEVEL_ERROR:String = "ERROR";
		private static const LEVEL_FATAL:String = "FATAL";
	}
}