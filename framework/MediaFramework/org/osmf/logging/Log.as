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
	 * Usually, there is one instance of ILoggerFactory per OSMF application. Log is the
	 * designated holder of the logger factory for the OSMF application as well as OSMF 
	 * media framework to access the global logger factory. 
	 */
	public class Log
	{
		/**
		 * OSMF application, if decides to use the logging framework, should call this function
		 * to set logger factory once at the start of the application. 
		 * 
		 * @param factory Reference to the logger factory
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static function set loggerFactory(factory:ILoggerFactory):void
		{
			_loggerFactory = factory;
		}
		
		/**
		 * Once the loggerFactory property has been initialized, the rest of the application
		 * should use this property to access the logger factory.
		 * 
		 * @return the loggerFactory
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static function get loggerFactory():ILoggerFactory
		{
			return _loggerFactory;
		}
		
		/**
		 * This is a convenient function for the OSMF application developer to call to 
		 * get a hold on a logger.
		 * 
		 * @param name The name that identifies a particular logger
		 * @return the logger identified by the name
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static function getLogger(name:String):ILogger
		{
			CONFIG::LOGGING
			{
				if (_loggerFactory == null)
				{
					_loggerFactory = new TraceLoggerFactory();
				}
			}
			
			return (_loggerFactory == null)? null : _loggerFactory.getLogger(name);
		}

		// Internals
		//
		
		private static var _loggerFactory:ILoggerFactory;
	}
}