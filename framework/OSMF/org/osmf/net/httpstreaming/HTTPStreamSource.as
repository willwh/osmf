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
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.osmf.events.DVRStreamInfoEvent;
	import org.osmf.events.HTTPStreamingEvent;
	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.net.httpstreaming.dvr.DVRInfo;
	import org.osmf.utils.OSMFStrings;
	
	CONFIG::LOGGING
	{
		import org.osmf.logging.Log;
		import org.osmf.logging.Logger;
	}
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * HTTPStreamProvider class is responsible for providing HDS properly 
	 * formatted bytes to the NetStream objects.
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */ 
	public class HTTPStreamSource implements IHTTPStreamSource, IHTTPStreamHandler
	{
		/**
		 * Default constructor.
		 */
		public function HTTPStreamSource(factory:HTTPStreamingFactory, resource:MediaResourceBase, dispatcher:IEventDispatcher)
		{
			if (dispatcher == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			if (factory == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			if (resource == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			_dispatcher = dispatcher;
			_resource = resource;	
			
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
					logger.warn("Null index info in HTTPStreamSourceHandler constructor. Probably invalid factory object or resource."); 
				}
			}
			
			_fileHandler.addEventListener(HTTPStreamingEvent.FRAGMENT_DURATION, onFragmentDuration);
			_fileHandler.addEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
			_fileHandler.addEventListener(HTTPStreamingEvent.FILE_ERROR, onError);
			
			_indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.INDEX_READY, onIndexReady);
			_indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.RATES_READY, onRatesReady);
			_indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.REQUEST_LOAD_INDEX, onRequestLoadIndex);
			_indexHandler.addEventListener(DVRStreamInfoEvent.DVRSTREAMINFO, onDVRStreamInfo);
			_indexHandler.addEventListener(HTTPStreamingEvent.FRAGMENT_DURATION, onFragmentDuration);
			_indexHandler.addEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
			_indexHandler.addEventListener(HTTPStreamingEvent.INDEX_ERROR, onError);
			
			setState(HTTPStreamSourceState.INIT);
			
			CONFIG::LOGGING
			{			
				logger.debug("Provider initialized.");
			}
		}
		
		public function get source():IHTTPStreamSource
		{
			return this;
		}
		
		/**
		 * Flag indicating that the stream is ready to perform
		 * any operation ( like seek, change quality, etc)
		 */
		public function get isReady():Boolean
		{
			return _isReady;
		}

		/**
		 * Flag indicating that the current provider has 
		 * reached the end of the stream and has no more 
		 * data to process.
		 */
		public function get endOfStream():Boolean
		{
			return _endOfStream;
		}
		
		/**
		 * The current stream name opened by this stream provider.
		 */ 
		public function get streamName():String
		{
			return _streamName;
		}
		
		public function get qosInfo():HTTPStreamQoSInfo
		{
			return _qosInfo;
		}
		
		/**
		 * Opens and initializes a stream provider to handle a specific stream.
		 */
		public function open(streamName:String):void
		{
			if (_streamName != null)
			{
				close();
			}
			
			_streamName = streamName;
			CONFIG::LOGGING
			{			
				logger.debug("Opening stream [ " + _streamName + " ]. ");
			}
			_indexHandler.initialize(_indexInfo != null? _indexInfo : streamName);
		}
		
		/**
		 * Closes an existing stream provider.
		 */
		public function close():void
		{
			CONFIG::LOGGING
			{			
				logger.debug("Closing stream [ " + _streamName + " ]. ");
			}
			
			if (_downloader != null)
			{
				_downloader.close();
			}
			_endFragment = true;
			_endOfStream = true;
			_streamName = null;
		}
		
		/**
		 * Seeks to the specified offset in stream.
		 */
		public function seek(offset:Number):void
		{
			_endOfStream = false;
			
			_seekTarget = offset;
			if (_seekTarget < 0 )
			{
				if (_dvrInfo != null)
				{
					_seekTarget = Math.floor(_dvrInfo.startTime + _dvrInfo.curLength - DVR_LIVE_OFFSET);
				}
				else
				{
					if (_isLive)
					{
						_seekTarget = Math.floor(_offset);
					}
					else
					{
						_seekTarget = 0;
					}
				}
			}

			CONFIG::LOGGING
			{			
				logger.debug("Seeking to " + _seekTarget + " in stream [ " + _streamName + " ]. ");
			}
			setState(HTTPStreamSourceState.SEEK);
		}
		
		/**
		 * Returns a chunk of bytes from the underlying stream or null
		 * if the stream provider needs to do some additional processing
		 * in order to obtain the bytes.
		 */
		public function getBytes():ByteArray
		{
			var bytes:ByteArray = null;
			
			if (_state != HTTPStreamSourceState.INIT)
			{
				bytes = doSomeProcessingAndGetBytes();
			}
			
			return bytes;
		}
		
		/**
		 * Gets stream information from the underlying objects.
		 */
		public function getDVRInfo(streamName:Object):void
		{
			CONFIG::LOGGING
			{			
				logger.debug("Loading dvr information.");
			}	
			
			_indexHandler.dvrGetStreamInfo(_indexInfo != null ? _indexInfo : streamName);
		}
		
		/**
		 * Changes the quality of the stream to the specified level.
		 */
		public function changeQualityLevel(streamName:String):void
		{
			CONFIG::LOGGING
			{
				logger.debug("Prepare to switch the quality level to " + streamName);
			}

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
				throw new Error("Quality level cannot be set at this time.");
			}
			else
			{
				if (level != _desiredQualityLevel)
				{
					beginQualityLevelChange(level);
				}
			}

		}
		
		///////////////////////////////////////////////////////////////////////
		/// Internals
		///////////////////////////////////////////////////////////////////////
		
		/**
		 * Process some small chunk of functionality and then 
		 * tries to return a byte array to the caller.
		 */
		protected function doSomeProcessingAndGetBytes():ByteArray
		{
			var bytes:ByteArray = null;
			var input:IDataInput = null;
			var date:Date;
			
			switch(_state)
			{
				case HTTPStreamSourceState.SEEK:
					if (_downloader != null)
					{
						_downloader.close();
						_fileHandler.flushFileSegment(_downloader.getBytes());
					}
					
					setState(HTTPStreamSourceState.LOAD);
					break;

				case HTTPStreamSourceState.WAIT:
					date = new Date();
					if (date.getTime() > _retryAfterTime)
					{
						setState(HTTPStreamSourceState.LOAD);
					}
					break;
				
				case HTTPStreamSourceState.LOAD:
					// we need to notify our clients about a completed change
					if (_qualityLevelChanged)
					{
						endQualityLevelChange();
					}
					
					_fragmentDuration = -1;
					_endOfStream = false;
					
					// Ask the index handler to provide the url for 
					// the next chunk of data we need to load.
					if (_seekTarget != -1) // we are in seeking mode
					{
						_request = _indexHandler.getFileForTime(_seekTarget, _qualityLevel);
					}
					else
					{
						_request = _indexHandler.getNextFile(_qualityLevel);
					}
					
					if (_request != null && _request.urlRequest != null)
					{
						// If we obtained some valid url we can use for loading data
						// then we use internal source to actually download the chunk
						if (_downloader == null)
						{
							_downloader = new HTTPStreamDownloader(_dispatcher);
						}
						_downloader.open(_request.urlRequest);
						setState(HTTPStreamSourceState.BEGIN_FRAGMENT);
					}
					else if (_request != null && _request.retryAfter >= 0)
					{
						// If we finished processing current fragments and we don't know 
						// if we have any additional data, we are waiting a little for 
						//things to update
						date = new Date();
						_retryAfterTime = date.getTime() + (1000.0 * _request.retryAfter);
						setState(HTTPStreamSourceState.WAIT);
					}
					else
					{
						// If we finished processing current fragments and we know for
						// sure that we don't have any additional data, we are stopping
						// the provider
						_endFragment = true;
						_endOfStream = true;
						
						if (_downloader != null)
						{
							bytes = _fileHandler.flushFileSegment(_downloader.getBytes()); 
						}
						setState(HTTPStreamSourceState.STOP);	
					}
					break;
				
				case HTTPStreamSourceState.BEGIN_FRAGMENT:
					_endFragment = false;
					if (_seekTarget != -1)
					{
						_fileHandler.beginProcessFile(true, _seekTarget);
						_seekTarget = -1;	
					}
					else
					{
						_fileHandler.beginProcessFile(false, 0);
					}
					_seekTarget = -1;
					
					_dispatcher.dispatchEvent( 
						new HTTPStreamingEvent(
							HTTPStreamingEvent.BEGIN_FRAGMENT, 
							false,
							true,
							NaN,
							null,
							null,
							_streamName
						)
					);

					setState(HTTPStreamSourceState.READ);
					break;
				
				case HTTPStreamSourceState.READ:
					if (_downloader != null)
					{
						input =  _downloader.getBytes(_fileHandler.inputBytesNeeded);
						if (input != null)
						{
							bytes = _fileHandler.processFileSegment(input);
						}
						else
						{
							_endFragment = (_downloader != null && _downloader.isOpen && _downloader.isComplete && !_downloader.hasData);
						}
					}
					
					if (_state == HTTPStreamSourceState.READ)
					{
						if (_endFragment)
						{
							if (_downloader != null)
							{
								_downloader.saveBytes();
							}
							setState(HTTPStreamSourceState.END_FRAGMENT);
						}
					}
					break;
				
				case HTTPStreamSourceState.END_FRAGMENT:
					if (_downloader != null)
					{
						input = _downloader.getBytes();
						if (input != null)
						{
							bytes = _fileHandler.endProcessFile(input);
						}
					}
					
					_qosInfo = new HTTPStreamQoSInfo(_fragmentDuration, _downloader.downloadBytesCount, _downloader.downloadDuration);
					
					_dispatcher.dispatchEvent( 
							new HTTPStreamingEvent(
									HTTPStreamingEvent.END_FRAGMENT,
									false,
									true,
									NaN,
									null,
									null,
									_streamName
								)
							);
					
					setState(HTTPStreamSourceState.LOAD);
					break;
			}
			
			return bytes;
		}
		
		/**
		 * @private
		 * 
		 * Sets the state of the stream provider to the specified value.
		 */
		protected function setState(value:String):void
		{
			_state = value;
			
			CONFIG::LOGGING
			{
				if (_state != previouslyLoggedState)
				{
					logger.debug("State = " + _state);
					previouslyLoggedState = _state;
				}
			}
		}
		
		/**
		 * @private
		 * 
		 * Event listener for <code>DVRSTREAMINFO</code>. This event indicates that 
		 * index handler has detected DVR information while processing index file.
		 * We just forward this further for processing as is needed by DVRCastTrait.
		 */
		private function onDVRStreamInfo(event:DVRStreamInfoEvent):void
		{
			_dvrInfo = event.info as DVRInfo;
			_dispatcher.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * 
		 * Event listener for <code>NOTIFY_INDEX_READY</code> event. Once the index 
		 * has been processed and is available we create an internal source for 
		 * handling the actual download of the stream bytes. 
		 */
		private function onIndexReady(event:HTTPStreamingIndexHandlerEvent):void
		{
			_isReady = true;
			_isLive = event.live;
			_offset = event.offset;

			CONFIG::LOGGING
			{			
				logger.debug("Stream [ " + _streamName + " ] initialized with parameters ( offset = " + _offset + ", live = " + _isLive + ").");
			}
		}
		
		/**
		 * @private
		 * 
		 * Event listener for <code>NOTIFY_RATES</code> event. We save the stream names,
		 * stream bitrates and quality levels internally for future reference when 
		 * a dynamic switch command will be issued.
		 */
		private function onRatesReady(event:HTTPStreamingIndexHandlerEvent):void
		{
			_ratesAreReady = true;
			_qualityRates = event.rates;
			_streamNames = event.streamNames;
			_numQualityLevels = _qualityRates.length;
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
			_pendingIndexLoadingRequests[_pendingIndexLoadingRequestsLenght] = event;
			_pendingIndexLoadingRequestsLenght++;
			
			if (_indexLoader == null)
			{
				_indexLoader = new URLLoader();
				_indexLoader.dataFormat = event.binaryData ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;  
				_indexLoader.addEventListener(Event.COMPLETE, onIndexComplete);
				_indexLoader.addEventListener(IOErrorEvent.IO_ERROR, onIndexError);
				_indexLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexError);
				
				_currentIndexLoadEvent = event;
				_indexLoader.load(_currentIndexLoadEvent.request);
			}
		}
		
		/**
		 * @private
		 * 
		 * Event listener for completion of index file download. We can close the
		 * loader object and send data for further processing.
		 */ 
		private function onIndexComplete(event:Event):void
		{
			_indexHandler.processIndexData(_indexLoader.data, _currentIndexLoadEvent.requestContext);
			processPendingIndexLoadingRequest();
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
			
			processPendingIndexLoadingRequest();
		}
		
		/**
		 * @private
		 * 
		 * Processes next request for loading an index file.
		 */
		private function processPendingIndexLoadingRequest():void
		{
			_pendingIndexLoadingRequests.shift();
			_pendingIndexLoadingRequestsLenght--;
			
			if (_pendingIndexLoadingRequestsLenght == 0)
			{
				_indexLoader.removeEventListener(Event.COMPLETE, onIndexComplete);
				_indexLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexError);
				_indexLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexError);
				
				_indexLoader = null;
			}
			else
			{
				_currentIndexLoadEvent = _pendingIndexLoadingRequests[0];
				_indexLoader.load(_currentIndexLoadEvent.request);
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
			_dispatcher.dispatchEvent(event);
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
			
			_dispatcher.dispatchEvent(event);
		}

		/**
		 * @private
		 * 
		 * Begins the change of the current quality level to the specified one.
		 */
		private function beginQualityLevelChange(level:int):void
		{
			_qualityLevelChanged = true;
			
			_desiredQualityLevel = level;
			_desiredQualityStreamName = _streamNames[_desiredQualityLevel];
			
			_dispatcher.dispatchEvent(
				new HTTPStreamingEvent(
					HTTPStreamingEvent.TRANSITION,
					false,
					false,
					NaN,
					null,
					null,
					_desiredQualityStreamName
				)
			);
			
			CONFIG::LOGGING
			{
				logger.debug("Quality level switch in progress. The next chunk will use the quality level [" + _desiredQualityLevel + "] with stream ["  + _desiredQualityStreamName + " ].");
			}

		}
		
		/**
		 * @private
		 * 
		 * Ends the change of the current quality level.
		 */
		private function endQualityLevelChange():void
		{
			_qualityLevel = _desiredQualityLevel;
			_streamName = _desiredQualityStreamName;
			
			_desiredQualityLevel = -1;
			_desiredQualityStreamName = null;
			_qualityLevelChanged = false;
			
			_dispatcher.dispatchEvent(
				new HTTPStreamingEvent(
					HTTPStreamingEvent.TRANSITION_COMPLETE,
					false,
					false,
					NaN,
					null,
					null,
					_streamName
				)
			);

			CONFIG::LOGGING
			{
				logger.debug("Quality level switch completed. The current quality level [" + _qualityLevel + "] with stream ["  + _streamName + " ].");
			}
		}
		
		/// Internals
		private static const DVR_LIVE_OFFSET:Number = 4;
		
		private var _dispatcher:IEventDispatcher = null;
		
		private var _resource:MediaResourceBase = null;
		
		private var _qosInfo:HTTPStreamQoSInfo = null;
		private var _downloader:HTTPStreamDownloader = null;
		private var _request:HTTPStreamRequest = null;
		
		private var _indexHandler:HTTPStreamingIndexHandlerBase = null;
		private var _fileHandler:HTTPStreamingFileHandlerBase = null;	
		private var _indexInfo:HTTPStreamingIndexInfoBase = null;
		
		private var _streamName:String = null;
		private var _seekTarget:Number = -1;
		
		private var _streamNames:Array = null;
		private var _qualityRates:Array = null; 	
		private var _numQualityLevels:int = 0;
		
		private var _qualityLevel:int = 0;
		private var _qualityLevelChanged:Boolean = false;
		private var _desiredQualityLevel:int = -1;
		private var _desiredQualityStreamName:String = null;
		
		private var _fragmentDuration:Number = 0;
		private var _endFragment:Boolean = false;
		
		private var _indexLoader:URLLoader = null;
		private var _currentIndexLoadEvent:HTTPStreamingIndexHandlerEvent = null;
		private var _pendingIndexLoadingRequests:Vector.<HTTPStreamingIndexHandlerEvent> = new Vector.<HTTPStreamingIndexHandlerEvent>();
		private var _pendingIndexLoadingRequestsLenght:int = 0;

		private var _isReady:Boolean = false;
		private var _ratesAreReady:Boolean = false;
		private var _endOfStream:Boolean = false;
		
		private var _isLive:Boolean = false;
		private var _offset:Number = -1;
		private var _dvrInfo:DVRInfo = null;
		
		private var _state:String = null;
		private var _retryAfterTime:Number = -1;
		
		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamSource");
			private var previouslyLoggedState:String = null;
		}

	}
}