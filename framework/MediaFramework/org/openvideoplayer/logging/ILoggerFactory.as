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
package org.openvideoplayer.logging
{
	/**
	 * ILoggerFactory defines a logger factory that serves as the initial contact
	 * point for OSMF applications to get a hold on various loggers. Usually in an OSMF
	 * application there is one instance of ILoggerFactory object and multiple instances
	 * of ILogger object
	 */
	public interface ILoggerFactory
	{
		/**
		 * Creates and returns a logger for the given name.
		 * 
		 * @param name the name of the logger
		 * @return the logger
		 */
		function getLogger(name:String):ILogger;
	}
}