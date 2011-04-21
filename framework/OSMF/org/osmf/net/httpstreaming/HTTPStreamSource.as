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
	 * HTTPStreamSource is an utility class which is responsable for
	 * downloading and local buffering HDS streams.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
	public class HTTPStreamSource
	{
		/**
		 * Default constructor.
		 * 
		 * @param dispatcher A dispatcher object used by HTTPStreamSource to
		 * 					 dispatch any event. 
		 **/
		public function HTTPStreamSource(dispatcher:IEventDispatcher)
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
				_urlStream.close();
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
				_savedBytes.length = 0; 
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
			_isComplete = true;
			
			CONFIG::LOGGING
			{
				logger.debug(" loading complete. It took " + _downloadDuration + "sec.");	
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
		
		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamSource");
		}
	}
}

//	import flash.events.Event;
//	import flash.events.EventDispatcher;
//	import flash.events.IOErrorEvent;
//	import flash.events.NetStatusEvent;
//	import flash.events.ProgressEvent;
//	import flash.events.SecurityErrorEvent;
//	import flash.net.URLLoader;
//	import flash.net.URLLoaderDataFormat;
//	import flash.net.URLStream;
//	import flash.utils.ByteArray;
//	import flash.utils.IDataInput;
//	
//	import org.osmf.elements.f4mClasses.BootstrapInfo;
//	import org.osmf.events.HTTPStreamingEvent;
//	import org.osmf.events.HTTPStreamingFileHandlerEvent;
//	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
//	import org.osmf.media.URLResource;
//	import org.osmf.metadata.Metadata;
//	import org.osmf.metadata.MetadataNamespaces;
//	import org.osmf.net.NetStreamCodes;
//	import org.osmf.net.StreamingURLResource;
//	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FFileHandler;
//	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FIndexHandler;
//	
//	CONFIG::LOGGING 
//	{	
//		import org.osmf.logging.Logger;
//	}
//	
//	[ExcludeClass]
//
//	/**
//	 * @private
//	 */
//	public class HTTPStreamingDataSource
//	{
//		/**
//		 * Constructor
//		 */
//		public function HTTPStreamingDataSource(resource:StreamingURLResource)
//		{
//			_savedBytes = new ByteArray();
//			
//			this.resource = resource;
//			this.fileHandler  = new HTTPStreamingF4FFileHandler();
//			this.indexHandler = new HTTPStreamingF4FIndexHandler(fileHandler);
//				
//			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.REQUEST_LOAD_INDEX, onRequestLoadIndexFile);	
//		}
//		
//		/**
//		 * Index information.
//		 */
//		public function get indexInfo():HTTPStreamingIndexInfoBase
//		{
//			return _indexInfo;
//		}
//		public function set indexInfo(value:HTTPStreamingIndexInfoBase):void
//		{
//			_indexInfo = value;
//		}
//
//		public function get seekTarget():Number
//		{
//			return _seekTarget;
//		}
//		public function set seekTarget(value:Number):void
//		{
//			_seekTarget = value;
//		}
//
//		public function get bufferRemaining():Number
//		{
//			return _bufferRemaining;
//		}
//		public function set bufferRemaining(value:Number):void
//		{
//			_bufferRemaining = bufferRemaining;
//		}
//
//		public function get endSegment():Boolean
//		{
//			return _endSegment;
//		}
//		
//		public function set endSegment(value:Boolean):void
//		{
//			_endSegment = value;
//		}
//		
//		public function get dataAvailable():Boolean
//		{
//			return _dataAvailable;
//		}
//		
//		public function set dataAvailable(value:Boolean):void
//		{
//			_dataAvailable = value;
//		}
//
//		public function get loadComplete():Boolean
//		{
//			return _loadComplete;
//		}
//		
//		public function set loadComplete(value:Boolean):void
//		{
//			_loadComplete = value;
//		}
//
//		public function get urlStream():URLStream
//		{
//			return _urlStream;			
//		}
//		
//		public function get savedBytes():ByteArray
//		{
//			return _savedBytes;
//		}
//		public function readBytes():void
//		{
//			_urlStream.readBytes(_savedBytes);
//		}
//		
//		public function openStream():void
//		{
//			_urlStream = new URLStream();
//			_urlStream.addEventListener(ProgressEvent.PROGRESS				, onURLStatus		, false, 0, true);	
//			_urlStream.addEventListener(Event.COMPLETE						, onURLComplete		, false, 0, true);
//			_urlStream.addEventListener(IOErrorEvent.IO_ERROR				, onVideoURLError	, false, 0, true);
//			_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR	, onVideoURLError	, false, 0, true);
//
//		}
//		
//		public function load():void
//		{
//			_urlStream.load(nextRequest.urlRequest);
//		}
//		
//		public function getInput():IDataInput
//		{
//			return byteSource(_urlStream, fileHandler.inputBytesNeeded)
//		}
//		
//		public function initializeIndex():void
//		{
//			if (indexInfo != null)
//				indexHandler.initialize(indexInfo);
//		}
//		
//		public function initialize(url:String):void
//		{
//			fileHandler = new HTTPStreamingF4FFileHandler();
//			
//			var bootstrap:BootstrapInfo = null;
//			var streamMetadata:Object;
//			var xmpMetadata:ByteArray;
//			
//			var httpMetadata:Metadata = resource.getMetadataValue(MetadataNamespaces.HTTP_STREAMING_METADATA) as Metadata;
//			if (httpMetadata != null)
//			{
//				bootstrap = httpMetadata.getValue(
//					MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP_KEY + url) as BootstrapInfo;
//				streamMetadata = httpMetadata.getValue(
//					MetadataNamespaces.HTTP_STREAMING_STREAM_METADATA_KEY + url);
//				xmpMetadata = httpMetadata.getValue(
//					MetadataNamespaces.HTTP_STREAMING_XMP_METADATA_KEY + url) as ByteArray;
//			}
//			
//			// saayan fix: live
//			var serverBaseURLs:Vector.<String> = httpMetadata.getValue(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY) as Vector.<String>;
//			var indexInfoResource:URLResource = new StreamingURLResource(serverBaseURLs[0].toString() + "/" + url);
//			var resourceMetadata:Metadata = new Metadata();
//			resourceMetadata.addValue(MetadataNamespaces.HTTP_STREAMING_BOOTSTRAP_KEY, bootstrap);
//			resourceMetadata.addValue(MetadataNamespaces.HTTP_STREAMING_STREAM_METADATA_KEY, streamMetadata);
//			resourceMetadata.addValue(MetadataNamespaces.HTTP_STREAMING_XMP_METADATA_KEY, xmpMetadata);
//			resourceMetadata.addValue(MetadataNamespaces.HTTP_STREAMING_SERVER_BASE_URLS_KEY,serverBaseURLs);
//			
//			indexInfoResource.addMetadataValue(MetadataNamespaces.HTTP_STREAMING_METADATA, resourceMetadata);
//			indexInfo = HTTPStreamingUtils.createF4FIndexInfo(indexInfoResource);
//			indexHandler.initialize(indexInfo);
//		}
//		
//		public function closeStream():void
//		{
//			if (_urlStream != null && _urlStream.connected)
//				_urlStream.close();
//		}
//		
//		public function flushFileSegment():void
//		{
//			fileHandler.flushFileSegment(_urlStream);
//		}
//		
//		public function byteSource(input:IDataInput, numBytes:Number):IDataInput
//		{
//			if (numBytes < 0)
//			{
//				return null;
//			}
//			
//			if (numBytes)
//			{
//				if (_savedBytes.bytesAvailable + input.bytesAvailable < numBytes)
//				{
//					return null;
//				}
//			}
//			else
//			{
//				if (_savedBytes.bytesAvailable + input.bytesAvailable < 1)
//				{
//					return null;
//				}
//			}
//			
//			if (_savedBytes.bytesAvailable)
//			{
//				var needed:int = numBytes - _savedBytes.bytesAvailable;
//				if (needed > 0)
//				{
//					input.readBytes(_savedBytes, _savedBytes.length, needed);
//				}
//				
//				return _savedBytes;
//			}
//			_savedBytes.length = 0;
//			return input;
//		}
//
//		/**
//		 * @private
//		 * Event handler for REQUEST_LOAD_INDEX - the framework uses this event to request for reloading
//		 * of bootstrap information ( usually in LIVE cases where bootstrap information is continously updated).
//		 * 
//		 **/
//		private function onRequestLoadIndexFile(event:HTTPStreamingIndexHandlerEvent):void
//		{
//			var urlLoader:URLLoader = new URLLoader(event.request);
//			var requestContext:Object = event.requestContext;
//			if (event.binaryData)
//			{
//				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
//			}
//			else
//			{
//				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
//			}
//			
//			urlLoader.addEventListener(Event.COMPLETE, onIndexLoadComplete);
//			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIndexURLError);
//			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexURLError);
//			
//			function onIndexLoadComplete(innerEvent:Event):void
//			{
//				urlLoader.removeEventListener(Event.COMPLETE, onIndexLoadComplete);
//				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexURLError);
//				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexURLError);
//
//				if (indexHandler != null) {
//					indexHandler.processIndexData(urlLoader.data, requestContext);
//				}
//			}
//			
//			function onIndexURLError(errorEvent:Event):void
//			{
//				urlLoader.removeEventListener(Event.COMPLETE, onIndexLoadComplete);
//				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexURLError);
//				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexURLError);
//
//				CONFIG::LOGGING
//				{			
//					logger.error("HTTPStreamingDataSource onRequestLoadIndexFileAlt error");
//					logger.error("URLStream: " + _urlStream );
//					logger.error("index url error: " + errorEvent );
//					logger.error( "******* attempting to download the index file (bootstrap) caused error!" );
//				}
//				
//				handleURLError();
//			}
//		}
//
//		private function handleURLError():void
//		{
//			if (dispatcher != null)
//			{
//				// We map all URL errors to Play.StreamNotFound.
//				dispatcher.dispatchEvent
//							( new NetStatusEvent
//								( NetStatusEvent.NET_STATUS
//									, false
//									, false
//									, {code:NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND, level:"error"}
//								)
//							);
//			}
//		}
//		
//		private function onURLStatus(progressEvent:ProgressEvent):void
//		{
//			_dataAvailable = true;
//		}
//		private function onURLComplete(event:Event):void
//		{
//			_loadComplete = true;
//			var fragId1:String = nextRequest.urlRequest.url.substr(nextRequest.urlRequest.url.indexOf("Frag")+4,nextRequest.urlRequest.url.length);
//			var fragDuration1:Number = indexHandler.getFragmentDuration(uint(fragId1));
//			_bufferRemaining += fragDuration1;
//			//	trace("audio: ", nextRequestAlt.urlRequest.url, fragDuration1);
//			//	trace("audio buffer: ", audioBufferRemaining, fileHandler.audioInput.bytesAvailable, " bytes");			
//		}
//		
//		private function onVideoURLError(event:Event):void
//		{		
//			CONFIG::LOGGING
//			{			
//				logger.error("URLStream: " + _urlStream );
//				logger.error("video error event: " + event );
//				logger.error( "******* attempting to download video fragment caused error event!" );
//			}
//			
//			handleURLError();
//		}
//
//		
//		public var resource:StreamingURLResource = null;
//		public var dispatcher:EventDispatcher = null;
//		public var fileHandler:HTTPStreamingFileHandlerBase = null; 
//		public var indexHandler:HTTPStreamingIndexHandlerBase = null; 
//		public var nextRequest:HTTPStreamRequest = null;
//		
//		private var _seekTarget:Number = 0;
//		private var _bufferRemaining:Number = 0;
//		private var _endSegment:Boolean = false;
//		private var _dataAvailable:Boolean = false;
//		private var _loadComplete:Boolean = false;
//		
//		private var _indexInfo:HTTPStreamingIndexInfoBase = null;
//		private var _urlStream:URLStream = null;
//		private var _savedBytes:ByteArray = null;  
//		
//		CONFIG::LOGGING
//		{
//			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamingDataSource");
//		}
//	}
//}