/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.net
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * The NetClient class provides support for handling
	 * callbacks dynamically from an RTMP server that is streaming
	 * to an AudioElement or VideoElement. 
	 * 
	 * <p>Use this class to listen for callbacks on the NetConnection
	 * and NetStream created by a NetLoader's load operation.</p>
	 * <p>Assign the value of the <code>client</code>
	 * property of the NetConnection or NetStream
	 * to an instance of the NetClient class.
	 * Then use the NetClient's <code>addHandler()</code>
	 * and <code>removeHandler()</code> methods to register and unregister handlers for
	 * the NetStream callbacks. 
	 * The names of these callbacks are the constants with names beginning with "ON_" 
	 * enumerated in the NetStreamCodes class.</p>
	 * 
	 * @see NetLoader
	 * @see NetStreamCodes
	 * @see flash.net.NetConnection
	 * @see flash.net.NetStream
	 */	
	dynamic public class NetClient extends Proxy
	{
		/**
		 * Adds a handler for the specified callback name.
		 * 
		 * <p>If multiple handlers register for the same callback,
		 * the result of the callback is an array holding the results
		 * of each handler's invocation.
		 * </p>
		 * <p>
		 * This example sets up handler for the <code>ON_METADATA</code>
		 * callback.
		 * <listing>
		 * function onMetaData(value:Object):void
		 * {
		 * 	trace("Got metadata.");
		 * }
		 * 
		 * var stream:NetStream;
		 * var client:NetClient = (stream.client as NetClient); //assign the stream to the NetClient
		 * client.addHandler(NetStreamCodes.ON_METADATA, onMetaData); //add the handler
		 * </listing>
		 * </p>
		 * 
		 * @param name Name of callback to handle.
		 * The callback names are enumerated in the 
		 * and NetStreamCodes class.
		 * @param handler Handler to add.
		 * @see NetStreamCodes
		 */		
		public function addHandler(name:String,handler:Function):void
		{
			var handlersForName:Array 
				= handlers.hasOwnProperty(name)
					? handlers[name]
					: (handlers[name] = []);
			
			if (handlersForName.indexOf(handler) == -1)
			{
				handlersForName.push(handler);
			}
		}
		
		/**
		 * Removes a handler method for the specified callback name.
		 * 
		 * @param name Name of callback for whose handler is being removed.
		 * The callback names are those constants enumerated in the
		 * NetStreamCodes class that have the prefix "ON_", such as 
		 * ON_CUE_POINT, ON_IMAGE_DATA, etc.
		 * @param handler Handler to remove.
		 * @return Returns <code>true</code> if the specified handler was found and
		 * successfully removed. 
		 * @see NetStreamCodes
		 */		
		public function removeHandler(name:String,handler:Function):Boolean
		{
			var result:Boolean;
			
			if (handlers.hasOwnProperty(name) )
			{
				var handlersForName:Array = handlers[name];
				var index:int = handlersForName.indexOf(handler);
			
				if (index != -1)
				{
					handlersForName.splice(index,1);
					
					result = true;
				}
			}
			
			return result;	
		}
		
		// Proxy Overrides
		//
		
		/**
		 * @inheritDoc
		 * @private
		 */		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
			return invokeHandlers(methodName,args);
        }
        
        /**
		 * @inheritDoc
		 * @private
		 */
		override flash_proxy function getProperty(name:*):* 
		{
			var result:*;
			trace('NetClient' + name);
			if (handlers.hasOwnProperty(name))
			{
				result 
					=  function():*
						{
							return invokeHandlers(arguments.callee.name,arguments);
						}
				
				result.name = name;
			}
			
			return result;
		}
				
		// Internals
		//
		
		/**
		 * @private
		 * 
		 * Holds an array of handlers per callback name. 
		 */		
		private var handlers:Dictionary = new Dictionary();
		
		/**
		 * @private
		 * 
		 * Utility method that invokes the handlers for the specified
		 * callback name.
		 *  
		 * @param name The callback name to invoke the handlers for.
		 * @param args The arguments to pass to the individual handlers on
		 * invoking them.
		 * @return <code>null</code> if no handlers have been added for the
		 * specified callback, or otherwise an array holding the result of
		 * each individual handler invokation. 
		 * 
		 */				
		private function invokeHandlers(name:String,args:Array):*
		{
			var result:Array;
			
        	if (handlers.hasOwnProperty(name))
			{
				result = [];
				var handlersForName:Array = handlers[name];
				for each (var handler:Function in handlersForName)
				{
					result.push(handler.apply(null,args));
				}
			}
			
			return result;
		}
	}
}