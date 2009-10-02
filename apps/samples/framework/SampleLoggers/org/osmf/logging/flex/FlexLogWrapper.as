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
package org.osmf.logging.flex
{
	import mx.logging.ILoggingTarget;
	import mx.logging.Log;
	
	import org.osmf.logging.ILoggerFactory;
	import org.osmf.logging.ILogger;
	
	/**
	 * This class implements ILoggerFactory of the OSMF logging framework and it
	 * wraps the Log class of the FLEX logging API.
	 */
	public class FlexLogWrapper implements ILoggerFactory
	{
		public function FlexLogWrapper()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function getLogger(name:String):ILogger
		{
			return new FlexLoggerWrapper(mx.logging.Log.getLogger(name));
		}
		
		public function addTarget(target:ILoggingTarget):void
		{
			mx.logging.Log.addTarget(target);
		}
	}
}