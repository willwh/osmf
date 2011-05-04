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
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.osmf.events.HTTPStreamingEvent;
	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
	import org.osmf.media.MediaResourceBase;

	CONFIG::LOGGING
	{
		import org.osmf.logging.Logger;
	}
	
	[ExcludeClass]
	
	/**
	 * Dispatched when the bootstrap information has been downloaded and parsed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indexReady", type="org.osmf.events.HTTPStreamingIndexHandlerEvent")]

	/**
	 * Dispatched when rates information becomes available. The rates usually becomes available
	 * when the bootstrap information has been parsed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="ratesReady", type="org.osmf.events.HTTPStreamingIndexHandlerEvent")]

	/**
	 * Dispatched when the index handler or file handler obtain the current fragment duration.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="fragmentDuration", type="org.osmf.events.HTTPStreamingEvent")]

	/**
	 * Dispatched when the index handler or file handler provides additional script data tags.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="scriptData", type="org.osmf.events.HTTPStreamingEvent")]

	/**
	 * Dispatched when the index handler encounters an unrecoverable error, such as an invalid 
	 * bootstrap box or an empty server base url.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indexError", type="org.osmf.events.HTTPStreamingEvent")]

	/**
	 * Dispatched when the file handler encounters an unrecoverable error, such as an invalid 
	 * file structure or incomplete tags.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="fileError", type="org.osmf.events.HTTPStreamingEvent")]

	/**
	 * @private
	 * 
	 * HTTPStreamSourceHandler is class which manages a specific HTTPStreamSource.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
 	public class HTTPStreamSourceHandler extends EventDispatcher
	{
		/**
		 * Default constructor.
		 **/
		public function HTTPStreamSourceHandler(factory:HTTPStreamingFactory, resource:MediaResourceBase)
		{
			_fileHandler = factory.createFileHandler(resource);
			if (_fileHandler == null)
			{
				throw new ArgumentError("Null file handler in HTTPStreamSourceHandler constructor. Probably invalid factory object or resource."); 
			}
			_indexHandler = factory.createIndexHandler(resource, _fileHandler);
			if (_indexHandler == null)
			{
				throw new ArgumentError("Null index handler in HTTPStreamSourceHandler constructor. Probably invalid factory object or resource."); 
			}
			_indexInfo = factory.createIndexInfo(resource);
			
			CONFIG::LOGGING
			{
				if (_indexInfo == null)
				{
					logger.debug("Null index info in HTTPStreamSourceHandler constructor. Probably invalid factory object or resource."); 
				}
			}
			
			_fileHandler.addEventListener(HTTPStreamingEvent.FRAGMENT_DURATION, onFragmentDuration);
			_fileHandler.addEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
			_fileHandler.addEventListener(HTTPStreamingEvent.FILE_ERROR, onError);
			
			_indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.INDEX_READY, onIndexReady);
			_indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.RATES_READY, onRatesReady);
			_indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.REQUEST_LOAD_INDEX, onRequestLoadIndex);
//			_indexHandler.addEventListener(DVRStreamInfoEvent.DVRSTREAMINFO, onDVRStreamInfo);
			_indexHandler.addEventListener(HTTPStreamingEvent.FRAGMENT_DURATION, onFragmentDuration);
			_indexHandler.addEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
			_indexHandler.addEventListener(HTTPStreamingEvent.INDEX_ERROR, onError);
			
			_endFragment = true;
		}
		
		/**
		 * Initializes the stream handler. If the internal index information
		 * is null then the provided parameter will be used for initialization.
		 */
		public function initialize(param:Object):void
		{
			_indexHandler.initialize( _indexInfo != null ? _indexInfo : param);
		}
		
		/**
		 * Gets stream information from the underlying objects.
		 */
		public function dvrGetStreamInfo(param:Object):void
		{
			_indexHandler.dvrGetStreamInfo(_indexInfo != null ? _indexInfo : param);
		}

		/**
		 * Gets the request which will download the fragment
		 * containing the specified time.
		 */
		public function getFileForTime(time:Number):HTTPStreamRequest
		{
			return _indexHandler.getFileForTime(time, _qualityLevel);
		}
		
		/**
		 * Gets the request which will download the next fragment.
		 */
		public function getNextFile():HTTPStreamRequest
		{
			return _indexHandler.getNextFile(_qualityLevel);
		}
		
		/**
		 * Opens HTTP source and start downloading data.
		 */
		public function open(request:HTTPStreamRequest):void
		{
			_endFragment = false;
			
			_request = request;
			if (_source != null && _request != null)
			{
				_source.open(request.urlRequest);
			}
			
			updateState();
		}
		
		/**
		 * Closes the stream handler.
		 */
		public function close():void
		{
			if (_source != null)
			{
				removeEventListener(Event.COMPLETE, onSourceComplete);
				_source.close();
			}
			
			updateState();
		}
		
		/**
		 * Sets the quality level based on stream name.
		 */
		public function setQualityLevelTo(streamName:String):void
		{
			var level:int = -1;
			
			if (_streamNames != null)
			{
				for (var i:int = 0; i < _streamNames.length; i++)
				{
					if (streamName == _streamNames[i])
					{
						level = i;
						break;
					}
				}
			}
			
			if (level == -1)
			{
				throw new Error("qualityLevel cannot be set to this value at this time");
			}
			else
			{
				if (level != _qualityLevel)
				{
					_qualityLevel = level;
					_url = _streamNames[level];
				}
			}
		}
		
		/**
		 * Begins the data processing sequence.
		 */
		public function beginProcessing(seek:Boolean, seekTime:Number):void
		{
			_fileHandler.beginProcessFile(seek, seekTime);
			
			updateState();
		}
		
		/**
		 * Ends the data processing sequence.
		 */
		public function endProcessing():ByteArray
		{
			var bytes:ByteArray = null;
			if (_source != null)
			{
				var input:IDataInput = _source.getBytes();
				if (input != null)
				{
					bytes = _fileHandler.endProcessFile(input);
				}
			}
			
			updateState();
			return bytes;
		}

		/**
		 * Processes the file segment.
		 */
		public function processContent():ByteArray
		{
			_endFragment = false;
			
			var bytes:ByteArray = null;
			if (_source != null)
			{
				var input:IDataInput =  _source.getBytes(_fileHandler.inputBytesNeeded);
				if (input != null)
				{
					bytes = _fileHandler.processFileSegment(input);
				}
			}
			
			updateState();
			return bytes;
		}
		
		/**
		 * Flushes the internal content to an byte array.
		 */
		public function flushContent():ByteArray
		{
			var bytes:ByteArray = null;
			
			if (_source != null)
			{
				bytes = _fileHandler.flushFileSegment(_source.getBytes()); 
			}
			
			_endFragment = true;
			
			updateState();
			return bytes;
		}

		/**
		 * Indicates if the media stream is live or not.
		 */
		public function get isLive():Boolean
		{
			return _isLive;
		}
		
		/**
		 * Indicates the offset of the current stream.
		 */
		public function get offset():Number
		{
			return _offset;
		}
		
		/**
		 * Indicates the remaining buffer in seconds.
		 */
		public function get bufferRemaining():Number
		{
			return _bufferRemaining;
		}
		
		/**
		 * Indicates that the source has data.
		 */
		public function get hasData():Boolean
		{
			return _source != null ? _source.hasData : false;
		}
		
		/**
		 * Indicates that the fragment has reached the end.
		 */
		public function get isFragmentEnd():Boolean
		{
			return _endFragment;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		///////////////////////////////////////////////////////////////////////
		/// Internals
		///////////////////////////////////////////////////////////////////////
		
		/**
		 * @private 
		 * 
		 * Updates the state of the source media handler class. Usually called after 
		 * any processing or updating of the current source. 
		 */
		private function updateState():void
		{
			_endFragment ||=  (_source != null && _source.isOpen && _source.isComplete && !_source.hasData);
		}
		
		/**
		 * @private
		 * 
		 * Event listener for <code>NOTIFY_INDEX_READY</code> event. Once the index 
		 * has been processed and is available we create an internal source for 
		 * handling the actual download of the stream bytes. 
		 * 
		 * We forward this to our listeners for further processing.
		 */
		private function onIndexReady(event:HTTPStreamingIndexHandlerEvent):void
		{
			_isLive = event.live;
			_offset = event.offset;
			
			if (_source == null)
			{
				_source = new HTTPStreamSource(this);
				addEventListener(Event.COMPLETE, onSourceComplete);
			}
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 
		 * Event listener for <code>NOTIFY_RATES</code> event. We just forward 
		 * this to our listeners for further processing.
		 */
		private function onRatesReady(event:HTTPStreamingIndexHandlerEvent):void
		{
			_qualityRates = event.rates;
			_streamNames = event.streamNames;
			_numQualityLevels = _qualityRates.length;

			dispatchEvent(event);	
		}
		
		/**
		 * @private
		 * 
		 * Event listener for <code>REQUEST_LOAD_INDEX</code> event. We start the download
		 * of the index file and on completion we forward that to indexHandler for 
		 * further processing.
		 */
		private function onRequestLoadIndex(event:HTTPStreamingIndexHandlerEvent):void
		{
			// ignore any additonal request if an loader operation is still in progress
			if (_indexLoader != null)
				return;
			
			_indexLoaderContext = event.requestContext;
			
			_indexLoader = new URLLoader();
			_indexLoader.dataFormat = event.binaryData ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;  
			_indexLoader.addEventListener(Event.COMPLETE, onIndexComplete);
			_indexLoader.addEventListener(IOErrorEvent.IO_ERROR, onIndexError);
			_indexLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexError);
			_indexLoader.load(event.request);
		}
		
		/**
		 * @private
		 * 
		 * Event listener for completion of index file download. We can close the
		 * loader object and send data for further processing.
		 */ 
		private function onIndexComplete(event:Event):void
		{
			_indexLoader.removeEventListener(Event.COMPLETE, onIndexComplete);
			_indexLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexError);
			_indexLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexError);
			
			_indexHandler.processIndexData(_indexLoader.data, _indexLoaderContext);
			_indexLoader = null;
			_indexLoaderContext = null;
		}
		
		/**
		 * @private 
		 * 
		 * Event listener for error triggered by download of index file. We'll just 
		 * close the index loader and forward this event further.
		 */ 
		private function onIndexError(event:Event):void
		{
			CONFIG::LOGGING
			{			
				logger.error("index url error: " + event );
				logger.error( "******* attempting to download the index file (bootstrap) caused error!" );
			}
			
			_indexLoader.removeEventListener(Event.COMPLETE, onIndexComplete);
			_indexLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexError);
			_indexLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexError);
			
			_indexLoader = null;
			_indexLoaderContext = null;
		}

		/**
		 * @private
		 * 
		 * Event listener for completion of stream data. Now we can calculate 
		 * the remaining duration.
		 */
		private function onSourceComplete(event:Event):void
		{
			if (_request != null && _request.urlRequest != null)
			{
				var url:String =  _request.urlRequest.url;
				if (url != null)
				{
					_bufferRemaining +=  _indexHandler.getFragmentDurationFromUrl(url);
				}
			}
		}

		/**
		 * @private
		 * 
		 * Event listener called when index handler of file handler obtain fragment duration.
		 */
		private function onFragmentDuration(event:HTTPStreamingEvent):void
		{
			_fragmentDuration = event.fragmentDuration;
		}

		/**
		 * @private
		 * 
		 * Event listener called when index handler of file handler need to handle script 
		 * data objects. We just forward them for further processing.
		 */
		private function onScriptData(event:HTTPStreamingEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 
		 * Event listener for errors dispatched by index or file handler. We just forward
		 * them for further processing, but in the future we may hide some errors.
		 */
		private function onError(event:HTTPStreamingEvent):void
		{
			CONFIG::LOGGING
			{			
				logger.error("error: " + event );
			}
			
			dispatchEvent(event);
		}
		
		/// Internals
		private var _indexHandler:HTTPStreamingIndexHandlerBase = null;
		private var _fileHandler:HTTPStreamingFileHandlerBase = null;	
		private var _indexInfo:HTTPStreamingIndexInfoBase = null;
		private var _source:HTTPStreamSource = null;
		private var _request:HTTPStreamRequest = null;
		
		private var _url:String = null;
		
		private var _streamNames:Array;
		private var _qualityRates:Array; 	
		private var _numQualityLevels:int = 0;
		private var _qualityLevel:int = 0;

		private var _isLive:Boolean = false;
		private var _offset:Number = -1;
		private var _endFragment:Boolean = false;
		
		private var _fragmentDuration:Number = 0;
		private var _bufferRemaining:Number = 0;
		
		private var _indexLoader:URLLoader = null;
		private var _indexLoaderContext:Object = null;
		
		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamSourceHandler");
		}
	}
}