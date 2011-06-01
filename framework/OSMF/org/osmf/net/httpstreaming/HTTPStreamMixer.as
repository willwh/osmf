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
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.osmf.net.httpstreaming.flv.FLVTag;
	import org.osmf.net.httpstreaming.flv.FLVTagAudio;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;
	import org.osmf.net.httpstreaming.flv.FLVTagVideo;

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
	public class HTTPStreamMixer implements IHTTPStreamSource
	{
		/**
		 * Default constructor.
		 */
		public function HTTPStreamMixer(dispatcher:IEventDispatcher)
		{
			_dispatcher = dispatcher;
		}
	
		/**
		 * Flag indicating that the stream is ready to perform
		 * any operation ( like seek, change quality, etc)
		 */
		public function get isReady():Boolean
		{
			return (
					 	(_videoHandler != null && _videoHandler.source != null && _videoHandler.source.isReady)
					|| 	(_audioHandler != null && _audioHandler.source != null && _audioHandler.source.isReady)
				);	
		}

		/**
		 * Flag indicating that the current provider has 
		 * reached the end of the stream and has no more 
		 * data to process.
		 */
		public function get endOfStream():Boolean
		{
			// we are interested only by the video track which is the one which dictates the timeline
			return (_videoHandler != null && _videoHandler.source != null && _videoHandler.source.endOfStream);
		}

		/**
		 *  Closes all associated sources.
		 */
		public function close():void
		{
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
			_currentTime = 0;
			
			_videoTime = 0;
			_videoTag = null;
			_videoTagDataLoaded = false;
			_videoInput.clear();

			_audioTime = 0;
			_audioTag = null;
			_audioTagDataLoaded = false;
			_audioInput.clear();

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
			// if we don't have any audio source then
			// shortcut the entire process and return 
			// main video source bytes
			if (_audioHandler == null)
			{
				return _videoHandler.source.getBytes();
			}
			
			return doSomeProcessingAndGetBytes();
		}
		
		/**
		 * Source for audio packets.
		 */
		public function get audio():IHTTPStreamHandler
		{
			return _audioHandler;
		}
		public function set audio(value:IHTTPStreamHandler):void
		{
			if (_audioHandler != value)
			{
				_audioHandler = value;
				_audioNeedsInitialization = true;
			}
		}
		
		/**
		 * Source for video packets.
		 */
		public function get video():IHTTPStreamHandler
		{
			return _videoHandler;
		}
		public function set video(value:IHTTPStreamHandler):void
		{
			_videoHandler = value;
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
			var bytes:ByteArray  = null;
			
			// audio needs to keep up with the video time
			if (_audioNeedsInitialization && _videoTime > 0)
			{
				_audioNeedsInitialization = false;
				_audioHandler.source.seek(_videoTime);
				return bytes;
			}
			
			bytes = internalMixMDATBytes();
			if (bytes.length == 0)
			{
				bytes = null;
				var needsMoreMedia:Boolean =  !_videoTagDataLoaded 
											||  (_videoInput.bytesAvailable == 0)
											||  (_videoInput.bytesAvailable != 0 && _videoTag == null);	
					
				var needsMoreAudio:Boolean = !_audioTagDataLoaded 
											||  (_audioInput.bytesAvailable == 0)
											||  (_audioInput.bytesAvailable != 0 && _audioTag == null);
				
				if (needsMoreAudio || needsMoreMedia)
				{
					var audioBytes:ByteArray = null;
					if (needsMoreAudio && _audioHandler.source.isReady)
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
			}
			else
			{
				bytes.position = 0;
			}
			
			return bytes;
		}
		
		/**
		 * @private
		 * 
		 * Mixes two media streams based on their time codes.
		 */
		private function internalMixMDATBytes():ByteArray
		{
			var mixedBytes:ByteArray = new ByteArray();
			
			// we are parsing each tag from the input buffers and mixed them to output buffer
			// based on their timecode
			while (_videoInput.bytesAvailable && _audioInput.bytesAvailable)
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
							||  (_audioTag.timestamp < _audioTime)
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
					&& ( _videoTag.timestamp <= _audioTime))
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

		/// Internals
		private var _audioHandler:IHTTPStreamHandler = null;
		private var _videoHandler:IHTTPStreamHandler = null;
		private var _dispatcher:IEventDispatcher = null;
		
		private var _videoTime:uint = 0;
		private var _videoTag:FLVTag = null;
		private var _videoTagDataLoaded:Boolean = true;
		private	var _videoInput:ByteArray = new ByteArray();
		
		private var _audioTime:uint = 0;
		private var _audioTag:FLVTag = null;
		private var _audioTagDataLoaded:Boolean = true;
		private	var _audioInput:ByteArray = new ByteArray();
		
		private	var _currentTime:uint = 0;
		
		private var _audioNeedsInitialization:Boolean = false;
	}
}