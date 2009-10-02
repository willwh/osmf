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
	import flash.utils.Dictionary;
	
	/**
	 * This class implements ILoggerFactory. It is the associated logger factory
	 * for the TraceLogger. 
	 */
	public class TraceLoggerFactory implements ILoggerFactory
	{
		public function TraceLoggerFactory()
		{
			loggers = new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		public function getLogger(name:String):ILogger
		{
			var logger:ILogger = loggers[name];
			
			if (logger == null)
			{
				logger = new TraceLogger(name);
				loggers[name] = logger;
			}
			
			return logger;
		}
		
		// internal
		//
		
		private var loggers:Dictionary;
	}
}