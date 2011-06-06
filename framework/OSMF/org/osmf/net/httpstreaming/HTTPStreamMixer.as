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
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.osmf.events.DVRStreamInfoEvent;
	import org.osmf.events.HTTPStreamingEvent;
	import org.osmf.net.httpstreaming.flv.FLVTag;
	import org.osmf.net.httpstreaming.flv.FLVTagAudio;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;
	import org.osmf.net.httpstreaming.flv.FLVTagVideo;
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
	 * HTTPStreamMixer class supports mixing audio and video data
	 * provided by different sources.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
	public class HTTPStreamMixer extends EventDispatcher implements IHTTPStreamSource
	{
		/**
		 * Default constructor.
		 */
		public function HTTPStreamMixer(dispatcher:IEventDispatcher)
		{
			if (dispatcher == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			_dispatcher = dispatcher;
			
			// we setup additional high priority event listeners in order to block
			// DVRInfo, BEGIN_FRAGMENT and END_FRAGMENT events dispatched by the audio 
			// source - events which may confuse the listening clients
			addEventListener(DVRStreamInfoEvent.DVRSTREAMINFO, 			onDVRStreamInfo, 		false, HIGH_PRIORITY, true);
			addEventListener(HTTPStreamingEvent.BEGIN_FRAGMENT, 		onBeginFragment, 		false, HIGH_PRIORITY, true);
			addEventListener(HTTPStreamingEvent.END_FRAGMENT, 			onEndFragment, 			false, HIGH_PRIORITY, true);
			addEventListener(HTTPStreamingEvent.TRANSITION, 			onTransition,			false, HIGH_PRIORITY, true);
			addEventListener(HTTPStreamingEvent.TRANSITION_COMPLETE, 	onTransitionComplete,	false, HIGH_PRIORITY, true);

			setState(HTTPStreamMixerState.INIT);
		}
	
		/**
		 * Flag indicating that the stream is ready to perform
		 * any operation ( like seek, change quality, etc)
		 */
		public function get isReady():Boolean
		{
			// we are interested only by the video track which is the one which dictates the timeline
			return (_videoHandler != null && _videoHandler.source.isReady);
		}

		/**
		 * Flag indicating that the current provider has 
		 * reached the end of the stream and has no more 
		 * data to process.
		 */
		public function get endOfStream():Boolean
		{
			// we are interested only by the video track which is the one which dictates the timeline
			return (_videoHandler != null && _videoHandler.source.endOfStream);
		}

		/**
		 *  Closes all associated sources.
		 */
		public function close():void
		{
			clearInternalBuffers();
			if (_desiredAudioHandler != null)
			{
				_desiredAudioHandler.close();
			}
			if (_audioHandler != null)
			{
				_audioHandler.close();
			}
			if (_videoHandler != null)
			{
				_videoHandler.close();
			}
		}
		
		/**
		 * Seeks to the specified offset in stream.
		 */
		public function seek(offset:Number):void
		{
			// For now we just implement a plain seek without considering
			// any of the already downloaded data - a good place to 
			// think about some "fake" in buffer seeking.
			// XXX Here we need to implement enhanced seeking
			
			setState(HTTPStreamMixerState.SEEK);
			
			clearInternalBuffers();
			if (_videoHandler != null)
			{
				_videoHandler.source.seek(offset);
			}
			if (_audioHandler != null)
			{
				_audioHandler.source.seek(offset);
			}
		}
		
		/**
		 * Returns a chunk of bytes from the underlying stream or null
		 * if the stream provider needs to do some additional processing
		 * in order to obtain the bytes.
		 */
		public function getBytes():ByteArray
		{
			return doSomeProcessingAndGetBytes();
		}
		
		/**
		 * Handler for audio source.
		 */
		public function get audio():IHTTPStreamHandler
		{
			return _desiredAudioHandler;
		}
		public function set audio(value:IHTTPStreamHandler):void
		{
			if (_desiredAudioHandler != value)
			{
				CONFIG::LOGGING
				{
					logger.debug(value == null ? "No specific audio source. Use default." : "Specific audio source selected.");
				}
				_desiredAudioHandler = value;
				_audioNeedsInitialization = true;
				
				_dispatcher.dispatchEvent(
					new HTTPStreamingEvent(
						HTTPStreamingEvent.TRANSITION,
						false,
						false,
						NaN,
						null,
						null,
						(_desiredAudioHandler != null ? _desiredAudioHandler.streamName : null)
					)
				);
			}
		}
		
		/**
		 * Handler for video source.
		 */
		public function get video():IHTTPStreamHandler
		{
			return _videoHandler;
		}
		public function set video(value:IHTTPStreamHandler):void
		{
			if (_videoHandler != value)
			{
				CONFIG::LOGGING
				{
					logger.debug(value == null ? "No video source." : "Specific video source selected.");
				}
				_videoHandler = value;
				_videoNeedsInitialization = true;
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
			
			switch(_state)
			{
				case HTTPStreamMixerState.INIT:
					// do nothing.
					break;
				
				case HTTPStreamMixerState.SEEK:
					// we just wait a little bit more until we go to decide
					// what should we consume
					setState(HTTPStreamMixerState.CONSUME_UNDECIDED);
					break;
			
				case HTTPStreamMixerState.CONSUME_UNDECIDED:
					// we need to decide what we will consume ( only the 
					// default stream or both default and alternate streams )
					if (_audioNeedsInitialization)
					{
						_audioHandler = _desiredAudioHandler;
						_audioNeedsInitialization = false;
						
						_dispatcher.dispatchEvent(
							new HTTPStreamingEvent(
								HTTPStreamingEvent.TRANSITION_COMPLETE,
								false,
								false,
								NaN,
								null,
								null,
								(_audioHandler != null ? _audioHandler.streamName : null)
							)
						);
					}
						
					if (_audioHandler == null)
					{
						clearInternalBuffers();
						setState(HTTPStreamMixerState.CONSUME_DEFAULT);
					}
					else
					{
						setState(HTTPStreamMixerState.CONSUME_MIXED);
					}
					break;
				
				case HTTPStreamMixerState.CONSUME_DEFAULT:
					// if we are in video only mode then we shortcut
					// the entire mixing process and return directly
					// the bytes from the specified video source.
					if (_videoHandler != null)
					{
						bytes = _videoHandler.source.getBytes();
					}
					break;
				
				case HTTPStreamMixerState.CONSUME_MIXED:
					bytes = internalMixMDATBytes((_videoTime == -1));
					if (bytes.length == 0)
					{
						bytes = null;
					}
					else
					{
						bytes.position = 0;
					}
					
					if (!_audioSyncedWithVideoTime && _videoTime > -1)
					{
						_audioSyncedWithVideoTime = true;
						_audioHandler.source.seek( _videoTime/1000);
					}
					
					var needsMoreMedia:Boolean =  !_videoTagDataLoaded 
						||  (_videoInput.bytesAvailable == 0)
						||  (_videoInput.bytesAvailable != 0 && _videoTag == null);	
					
					var needsMoreAudio:Boolean = !_audioTagDataLoaded 
						||  (_audioInput.bytesAvailable == 0)
						||  (_audioInput.bytesAvailable != 0 && _audioTag == null);
					
					if (needsMoreAudio || needsMoreMedia)
					{
						var audioBytes:ByteArray = null;
						if (needsMoreAudio && _audioHandler != null && _audioHandler.source.isReady)
						{
							audioBytes = _audioHandler.source.getBytes();
						}	
						var mediaBytes:ByteArray = null;
						if (needsMoreMedia && _videoHandler.source.isReady)
						{
							mediaBytes = _videoHandler.source.getBytes();	
						}
						if (mediaBytes != null || audioBytes != null)
						{
							mixMDATBytes(mediaBytes, audioBytes);
						}
					}
					break;
			}
			
			return bytes;
		}
		
		
		/**
		 * @private
		 * 
		 * Mixes two media streams based on their time codes.
		 */
		private function internalMixMDATBytes(forceVideoProcessing:Boolean):ByteArray
		{
			var mixedBytes:ByteArray = new ByteArray();
			
			// we are parsing each tag from the input buffers and mixed them to output buffer
			// based on their timecode
			while (_videoInput.bytesAvailable && (_audioInput.bytesAvailable || forceVideoProcessing))
			{
				// process video input and get the next video tag
				do
				{
					// if we don't have enough data to read the tag header then return
					// any mixed tags and wait for addional data to be added to video buffer
					if ((_videoTag == null) && (_videoInput.bytesAvailable < FLVTag.TAG_HEADER_BYTE_COUNT) )
					{
						return mixedBytes;
					}
					
					// if we have enough data to read header, read the header and detect tag type
					if (_videoTag == null)
					{
						_videoTag = createTag( _videoInput.readByte());
						_videoTag.readRemainingHeader(_videoInput);
						_videoTagDataLoaded = false;
						
						_videoTime = _videoTag.timestamp;
					}
					
					if (!_videoTagDataLoaded)
					{
						// if we don't have enough data to read the tag data then return
						// any mixed tags and wait for addional data to be added to video buffer
						if (_videoInput.bytesAvailable < (_videoTag.dataSize + FLVTag.PREV_TAG_BYTE_COUNT))
						{
							return mixedBytes;
						}
						
						// skip any audio tags which may be present in the video buffer or any
						// tags whose timestamp are smaller than the latest video mixing time
						if (
							(_videoTag is FLVTagAudio)
							||  (_videoTag.timestamp < _videoTime)
						)
						{
							_videoInput.position += _videoTag.dataSize + FLVTag.PREV_TAG_BYTE_COUNT;
							_videoTag = null;
						}
						else					
						{
							_videoTag.readData(_videoInput);
							_videoTag.readPrevTag(_videoInput);
							_videoTagDataLoaded = true;
							
							if (forceVideoProcessing && _audioInput.bytesAvailable == 0)
							{
								// we entered here only to initialize the video time
								// now back off and wait for the audio to synchronize
								return mixedBytes;
							}
						}
					}
				} while ( _videoTag == null); 
				
				// process audio input and get the next audio tag
				do
				{
					// if we don't have enough data to read the tag header then return
					// any mixed tags and wait for addional data to be added to audio buffer
					if ((_audioTag == null) && (_audioInput.bytesAvailable < FLVTag.TAG_HEADER_BYTE_COUNT) )
					{
						return mixedBytes;
					}
					
					// if we have enough data to read header, read the header and detect tag type
					if (_audioTag == null)
					{
						_audioTag = createTag( _audioInput.readByte());
						_audioTag.readRemainingHeader(_audioInput);
						_audioTagDataLoaded = false;
						
						_audioTime = _audioTag.timestamp;
					}
					
					if (!_audioTagDataLoaded)
					{
						// if we don't have enough data to read the tag data then return
						// any mixed tags and wait for addional data to be added to audio buffer
						if (_audioInput.bytesAvailable < (_audioTag.dataSize + FLVTag.PREV_TAG_BYTE_COUNT))
						{
							return mixedBytes;
						}
						
						// skip any video tags which may be present in the audio buffer or any
						// tags whose timestamp are smaller than the latest audio mixing time
						if (
							(_audioTag is FLVTagVideo)
							|| (_audioTag.timestamp < _audioTime)
							|| (_audioTag.timestamp < _currentTime)
						)
						{
							_audioInput.position += _audioTag.dataSize + FLVTag.PREV_TAG_BYTE_COUNT;
							_audioTag = null;
						}
						else					
						{
							_audioTag.readData(_audioInput);
							_audioTag.readPrevTag(_audioInput);
							_audioTagDataLoaded = true;
						}
					}
				} while ( _audioTag == null); 

				if (_audioTime < 0)
				{
					_audioSyncedWithVideoTime = false;
					clearAudioBuffers();
					return mixedBytes;
				}
				
				if (
					(_audioTag != null) 
					&& (_audioTag.timestamp >= _currentTime) 
					&& (_audioTag.timestamp <= _videoTime))
				{
					_currentTime = _audioTag.timestamp;
					_audioTag.write(mixedBytes);
					_audioTag = null;
				}
				else if (
					(_videoTag != null) 
					&& (_videoTag.timestamp >= _currentTime) 
					&& (_videoTag.timestamp <= _audioTime ))
				{
					_currentTime = _videoTag.timestamp;
					_videoTag.write(mixedBytes);
					_videoTag = null;					
				}
			}
			
			return mixedBytes;
		}

		/**
		 * @private
		 * 
		 * Mixes two media streams based on their time codes.
		 */
		private function mixMDATBytes(videoInput:IDataInput, audioInput:IDataInput):void
		{
			// we remove the already processed data from internal buffers
			// only if we processed at least half of the internal buffers
			var unprocessedBytes:ByteArray = new ByteArray();
			if (
				_videoInput.position != 0 
				&&  _videoInput.bytesAvailable < (_videoInput.length / 2)
			)
			{
				_videoInput.readBytes(unprocessedBytes, 0, _videoInput.bytesAvailable);
				_videoInput.clear();
				unprocessedBytes.readBytes(_videoInput, 0, unprocessedBytes.bytesAvailable);
				unprocessedBytes.clear();
			}
			
			if (
				_audioInput.position != 0 
				&&  _audioInput.bytesAvailable < (_audioInput.length / 2)
			)
			{
				_audioInput.readBytes(unprocessedBytes, 0, _audioInput.bytesAvailable);
				_audioInput.clear();
				unprocessedBytes.readBytes(_audioInput, 0, unprocessedBytes.bytesAvailable);
				unprocessedBytes.clear();
			}
			
			// we are adding the new available data to internal buffers
			// to allow for further processing
			if (videoInput != null && videoInput.bytesAvailable)
			{
				videoInput.readBytes(_videoInput, _videoInput.length, videoInput.bytesAvailable);
			}
			if (audioInput != null && audioInput.bytesAvailable)
			{
				audioInput.readBytes(_audioInput, _audioInput.length, audioInput.bytesAvailable);
			}
		}	

		/**
		 * @private
		 * 
		 * Create a specific tag based on the provided type.
		 */
		private function createTag(type:int):FLVTag
		{
			var tag:FLVTag = null;
			
			switch (type)
			{
				case FLVTag.TAG_TYPE_AUDIO:
				case FLVTag.TAG_TYPE_ENCRYPTED_AUDIO:
					tag = new FLVTagAudio(type);
					break;
				
				case FLVTag.TAG_TYPE_VIDEO:
				case FLVTag.TAG_TYPE_ENCRYPTED_VIDEO:
					tag = new FLVTagVideo(type);
					break;
				
				case FLVTag.TAG_TYPE_SCRIPTDATAOBJECT:
				case FLVTag.TAG_TYPE_ENCRYPTED_SCRIPTDATAOBJECT:
					tag = new FLVTagScriptDataObject(type);
					break;
				
				default:
					tag = new FLVTag(type);	// the generic case
					break;
			}	
			
			return tag;
		}
		
		/**
		 * @private
		 * Saves the current state of the object and sets it to the value specified.
		 **/ 
		private function setState(value:String):void
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
		 * Clears the internal audio buffers when seeking or closing the mixer. It is important
		 * to do this due the fact that in order for the mix to work, the buffers should 
		 * be aligned at tag boundry.
		 */ 
		private function clearAudioBuffers():void
		{
			_audioTime = -1;
			_audioTag = null;
			_audioTagDataLoaded = false;
			_audioInput.clear();
		}
		
		/**
		 * @private
		 * 
		 * Clears the internal buffers when seeking or closing the mixer. It is important
		 * to do this due the fact that in order for the mix to work, the buffers should 
		 * be aligned at tag boundry.
		 */ 
		private function clearInternalBuffers():void
		{
			_currentTime = 0;
			
			_videoTime = -1;
			_videoTag = null;
			_videoTagDataLoaded = false;
			_videoInput.clear();
			
			clearAudioBuffers();
		}
		
		/**
		 * Event handler for DVRStreamInfo event. We just want to block the event dispatched
		 * by the audio handler as the video handler is the only owner of the timeline.
		 */ 
		private function onDVRStreamInfo(event:DVRStreamInfoEvent):void
		{
			_dispatcher.dispatchEvent(event);
		}
		
		private function onBeginFragment(event:HTTPStreamingEvent):void
		{
			if (_audioNeedsInitialization)
			{
				CONFIG::LOGGING
				{
					logger.debug("We are at a fragment boundry [state = " + _state + "]. We should switch alternative audio.");
				}
				
				if (_audioHandler != null)
				{
					_audioHandler.close();
					_audioHandler = null;
				}

				clearAudioBuffers();
				_audioSyncedWithVideoTime = false;

				setState(HTTPStreamMixerState.CONSUME_UNDECIDED);
			}
			
			if (_videoHandler != null && _videoHandler.streamName == event.url)
			{
				_dispatcher.dispatchEvent(event);
			}
		}

		private function onEndFragment(event:HTTPStreamingEvent):void
		{
			if (_videoHandler != null && _videoHandler.streamName == event.url)
			{
				_dispatcher.dispatchEvent(event);
			}
		}
		
		private function onTransition(event:HTTPStreamingEvent):void
		{
			_dispatcher.dispatchEvent(event);
		}
		
		private function onTransitionComplete(event:HTTPStreamingEvent):void
		{
			_dispatcher.dispatchEvent(event);
		}
		/// Internals
		private static const HIGH_PRIORITY:int = 10000;
		private var _dispatcher:IEventDispatcher = null;
		
		private var _videoTime:int = -1;
		private var _videoTag:FLVTag = null;
		private var _videoTagDataLoaded:Boolean = true;
		private	var _videoInput:ByteArray = new ByteArray();
		private var _videoNeedsInitialization:Boolean = false;
		
		private var _audioTime:int = -1;
		private var _audioTag:FLVTag = null;
		private var _audioTagDataLoaded:Boolean = true;
		private	var _audioInput:ByteArray = new ByteArray();
		private var _audioNeedsInitialization:Boolean = false;
		private var _audioSyncedWithVideoTime:Boolean = false;
		
		private	var _currentTime:uint = 0;
		
		private var _audioHandler:IHTTPStreamHandler = null;
		private var _desiredAudioHandler:IHTTPStreamHandler = null;
		private var _videoHandler:IHTTPStreamHandler = null;
		
		private var _state:String = null;
		
		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamMixer");
			private var previouslyLoggedState:String = null;
		}

	}
}