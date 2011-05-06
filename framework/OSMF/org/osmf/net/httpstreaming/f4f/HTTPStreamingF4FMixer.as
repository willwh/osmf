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
package org.osmf.net.httpstreaming.f4f
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.osmf.net.httpstreaming.HTTPStreamingMixerBase;
	import org.osmf.net.httpstreaming.flv.FLVTag;
	import org.osmf.net.httpstreaming.flv.FLVTagAudio;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;
	import org.osmf.net.httpstreaming.flv.FLVTagVideo;
	
	CONFIG::LOGGING
	{			
		import org.osmf.logging.Logger;
	}
	
	[ExcludeClass]

	/**
	 * @private
	 * 
	 * This is the actual implementation of HTTPStreamingMixerBase. It handles mixing
	 * of individual fragments of an F4V file.
	 */	
	public class HTTPStreamingF4FMixer extends HTTPStreamingMixerBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPStreamingF4FMixer()
		{
			super();
			
		}
		
		///////////////////////////////////////////////////////////////////////
		/// Public
		///////////////////////////////////////////////////////////////////////
		/**
		 * Flag indicating the mixer needs more audio.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		override public function get needsAudio():Boolean
		{
			return 		!_audioTagDataLoaded 
					||  (_audioInput.bytesAvailable == 0)
					||  (_audioInput.bytesAvailable != 0 && _audioTag == null);
		}
		
		/**
		 * Gets the last audio time in miliseconds.
		 */
		override public function get audioTime():uint
		{
			return _audioTime;
		}
		
		/**
		 * Flag indicating the mixer needs more video.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.0
		 */
		override public function get needsVideo():Boolean
		{
			return 		!_videoTagDataLoaded 
					||  (_videoInput.bytesAvailable == 0)
					||  (_videoInput.bytesAvailable != 0 && _videoTag == null);
		}

		/**
		 * Gets the last video time in miliseconds.
		 */
		override public function get videoTime():uint
		{
			return _videoTime;
		}

		/**
		 * Flushes the internal cache of video data.
		 */
		override public function flushVideoInput():void
		{
			_currentTime = 0;
			
			_videoTime = 0;
			_videoTag = null;
			_videoTagDataLoaded = false;
			_videoInput.clear();
		}
		
		/**
		 * Flushes the internal cache of audio data.
		 */
		override public function flushAudioInput():void
		{
			_currentTime = 0;
			
			_audioTime = 0;
			_audioTag = null;
			_audioTagDataLoaded = false;
			_audioInput.clear();
		}

		/**
		 * Returns the mixed stream.
		 */
		override public function getMixedMDATBytes():ByteArray
		{
			var bytes:ByteArray = internalMixMDATBytes();
			if (bytes.length == 0)
			{
				bytes = null;
			}
			else
			{
				bytes.position = 0;
			}
			
			return bytes;
		}

		/**
		 * Mixes two media streams based on their time codes.
		 */
		override public function mixMDATBytes(videoInput:IDataInput, audioInput:IDataInput):void
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
		
		
		///////////////////////////////////////////////////////////////////////
		/// Internals
		///////////////////////////////////////////////////////////////////////

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
		private var _videoTime:uint = 0;
		private var _videoTag:FLVTag = null;
		private var _videoTagDataLoaded:Boolean = true;
		private	var _videoInput:ByteArray = new ByteArray();
		
		private var _audioTime:uint = 0;
		private var _audioTag:FLVTag = null;
		private var _audioTagDataLoaded:Boolean = true;
		private	var _audioInput:ByteArray = new ByteArray();

		private	var _currentTime:uint = 0;

		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FMixer");
		}
	}
}