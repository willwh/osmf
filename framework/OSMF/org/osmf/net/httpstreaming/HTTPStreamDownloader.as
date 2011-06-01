/*****************************************************
 *  
 *  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.net.httpstreaming
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.osmf.net.NetStreamCodes;
	CONFIG::LOGGING
	{
		import org.osmf.logging.Logger;
	}
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * HTTPStreamDownloader is an utility class which is responsable for
	 * downloading and local buffering HDS streams.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
	public class HTTPStreamDownloader
	{
		/**
		 * Default constructor.
		 * 
		 * @param dispatcher A dispatcher object used by HTTPStreamDownloader to
		 * 					 dispatch any event. 
		 **/
		public function HTTPStreamDownloader(dispatcher:IEventDispatcher)
		{
			_dispatcher = dispatcher;
		}
		
		/**
		 * Returns true if the HTTP stream source is open and false otherwise.
		 **/
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		/**
		 * Returns true if the HTTP stream source has been completly downloaded.
		 **/
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
		
		/**
		 * Returns true if the HTTP stream source has data available for processing.
		 **/
		public function get hasData():Boolean
		{
			return _hasData;
		}

		/**
		 * Returns the duration of the last download in seconds.
		 */
		public function get downloadDuration():Number
		{
			return _downloadDuration;
		}
		
		/**
		 * Returns the bytes count for the last download.
		 */
		public function get downloadBytesCount():Number
		{
			return _downloadBytesCount;
		}
		
		/**
		 * Opens the HTTP stream source and start downloading the data 
		 * immediately. It will automatically close any previous opended
		 * HTTP stream source.
		 **/
		public function open(request:URLRequest):void
		{
			if (isOpen)
				close();
					
			_isComplete = false;
			_hasData = false;
			
			if (_savedBytes == null)
			{
				_savedBytes = new ByteArray();
			}
			
			if (_urlStream == null)
			{
				_urlStream = new URLStream();
				_urlStream.addEventListener(Event.OPEN, onOpen);
				_urlStream.addEventListener(Event.COMPLETE, onComplete);
				_urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_urlStream.addEventListener(IOErrorEvent.IO_ERROR, onError);
				_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			}
			
			if (_urlStream != null && request != null)
			{
				CONFIG::LOGGING
				{
					logger.debug("loading :" + request.url.toString());	
				}

				_downloadBeginDate = new Date();
				_downloadBytesCount = 0;
				_urlStream.load(request);
			}
		}
		
		/**
		 * Closes the HTTP stream source. It closes any open connection
		 * and also clears any buffered data.
		 * 
		 * @param dispose Flag to indicate if the underlying objects should 
		 * 				  also be disposed. Defaults to <code>false</code>
		 * 				  as is recommended to reuse these objects. 
		 **/ 
		public function close(dispose:Boolean = false):void
		{
			_isOpen = false;
			_isComplete = false;
			_hasData = false;
			
			if (_savedBytes != null)
			{
				_savedBytes.length = 0;
				if (dispose)
				{
					_savedBytes = null;
				}
			}
			
			if (_urlStream != null)
			{
				if (_urlStream.connected)
				{
					_urlStream.close();
				}
				if (dispose)
				{
					_urlStream.removeEventListener(Event.OPEN, onOpen);
					_urlStream.removeEventListener(Event.COMPLETE, onComplete);
					_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
					_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
					_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
					_urlStream = null;
				}
			}
		}
		
		/**
		 * Returns a buffer containing a specified number of bytes or null if 
		 * there are not enough bytes available.
		 * 
		 * @param numBytes The number of the bytes to be returned. 
		 **/
		public function getBytes(numBytes:int = 0):IDataInput
		{
			if ( !isOpen || numBytes < 0)
			{
				return null;
			}
			
			if (numBytes == 0)
			{
				numBytes = 1;
			}
			
			var totalAvailableBytes:int = _savedBytes.bytesAvailable + _urlStream.bytesAvailable;
			if (totalAvailableBytes == 0)
			{
				_hasData = false;
			}
			
			if (totalAvailableBytes < numBytes)
			{
				return null;
			}
			
			// use first the previous saved bytes and complete as needed
			// with bytes from the actual stream.
			if (_savedBytes.bytesAvailable)
			{
				var needed:int = numBytes - _savedBytes.bytesAvailable;
				if (needed > 0)
				{
					_urlStream.readBytes(_savedBytes, _savedBytes.length, needed);
				}
				
				return _savedBytes;
			}
			
			// make sure that the saved bytes buffer is empty 
			// and return the actual stream.
			_savedBytes.length = 0;
			return _urlStream;
		}
		
		/**
		 * Saves all remaining bytes from the HTTP stream source to
		 * internal buffer to be available in the future.
		 **/
		public function saveBytes():void
		{
			if (_urlStream != null && _urlStream.connected && _urlStream.bytesAvailable)
			{
				_urlStream.readBytes(_savedBytes);
			}
			else
			{
				if (_savedBytes != null)
				{	
					_savedBytes.length = 0;
				}
			}
		}
		
		/**
		 * Returns a string representation of this object.
		 **/
		public function toString():String
		{
			// TODO : add request url to this string
			return "HTTPStreamSource";
		}
		
		/// Event handlers
		/**
		 * @private
		 * Called when the connection has been open.
		 **/
		private function onOpen(event:Event):void
		{
			_isOpen = true;
		}
		
		/**
		 * @private
		 * Called when all data has been downloaded.
		 **/
		private function onComplete(event:Event):void
		{
			_downloadEndDate = new Date();
			_downloadDuration = (_downloadEndDate.valueOf() - _downloadBeginDate.valueOf())/1000.0;
			_downloadBytesCount = _urlStream.bytesAvailable;
			
			_isComplete = true;
			
			CONFIG::LOGGING
			{
				logger.debug(" loading complete. It took " + _downloadDuration + " sec.");	
			}
		}
		
		/**
		 * @private
		 * Called when additional data has been received.
		 **/
		private function onProgress(event:Event):void
		{
			_hasData = true;			
		}	
		
		/**
		 * @private
		 * Called when an error occurred while downloading.
		 **/
		private function onError(event:Event):void
		{
			CONFIG::LOGGING
			{			
				logger.error("URLStream: " + _urlStream );
				logger.error("video error event: " + event );
				logger.error( "******* attempting to download video fragment caused error event!" );
			}
			
			if (_dispatcher != null)
			{
				// We map all URL errors to Play.StreamNotFound.
				_dispatcher.dispatchEvent
						( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
								, false
								, false
								, {code:NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND, level:"error"}
							)
						);
			}
		}
		
		/// Internals
		private var _isOpen:Boolean = false;
		private var _isComplete:Boolean = false;
		private var _hasData:Boolean = false;
		private var _savedBytes:ByteArray = null;
		private var _urlStream:URLStream = null;
		private var _dispatcher:IEventDispatcher = null;
		
		private var _downloadBeginDate:Date = null;
		private var _downloadEndDate:Date = null;
		private var _downloadDuration:Number = 0;
		private var _downloadBytesCount:Number = 0;
		
		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamDownloader");
		}
	}
}
