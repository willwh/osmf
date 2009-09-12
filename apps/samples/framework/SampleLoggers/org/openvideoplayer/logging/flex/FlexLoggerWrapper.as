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
package org.openvideoplayer.logging.flex
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.openvideoplayer.logging.ILogger;
	
	public class FlexLoggerWrapper implements org.openvideoplayer.logging.ILogger
	{
		public function FlexLoggerWrapper(logger:mx.logging.ILogger)
		{
			this.logger = logger;
		}

		/**
		 * @inheritDoc
		 */
		public function debug(message:String, ...parameters):void
		{
			var args:Array = parameters.concat();
			args.unshift(message);
			logger.debug.apply(logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function info(message:String, ...parameters):void
		{
			var args:Array = parameters.concat();
			args.unshift(message);
			logger.info.apply(logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function warn(message:String, ...parameters):void
		{
			var args:Array = parameters.concat();
			args.unshift(message);
			logger.warn.apply(logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function error(message:String, ...parameters):void
		{
			var args:Array = parameters.concat();
			args.unshift(message);
			logger.error.apply(logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fatal(message:String, ...parameters):void
		{
			var args:Array = parameters.concat();
			args.unshift(message);
			logger.fatal.apply(logger, args);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debugEnabled():Boolean
		{
			return mx.logging.Log.isDebug();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get infoEnabled():Boolean
		{
			return mx.logging.Log.isInfo();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get warnEnabled():Boolean
		{
			return mx.logging.Log.isWarn();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorEnabled():Boolean
		{
			return mx.logging.Log.isError();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fatalEnabled():Boolean
		{
			return mx.logging.Log.isFatal();
		}
		
		// internal
		//
		
		private var logger:mx.logging.ILogger;
	}
}