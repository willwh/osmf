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
	
	import org.osmf.events.HTTPStreamingFileHandlerEvent;
	import org.osmf.net.httpstreaming.HTTPStreamingFileHandlerBase;
	import org.osmf.net.httpstreaming.HTTPStreamingIndexHandlerBase;

	[ExcludeClass]

	/**
	 * @private
	 * 
	 * This is the actual implementation of HTTPStreamingFileHandlerBase. It handles 
	 * individual fragments of an F4V file.
	 */	
	public class HTTPStreamingF4FFileHandler extends HTTPStreamingFileHandlerBase
	{
		/**
		 * Constructor.
		 */
		public function HTTPStreamingF4FFileHandler(indexHandler:HTTPStreamingIndexHandlerBase)
		{
			super();
			
			_indexHandler = indexHandler as HTTPStreamingF4FIndexHandler;
		}
		
		/** 
		 * @private
		 */
		override public function beginProcessFile(seek:Boolean, seekTime:Number):void
		{
			_seekToTime = seek ? seekTime : 0;
			_bytesNeeded = F4FConstants.FIELD_SIZE_LENGTH + F4FConstants.FIELD_TYPE_LENGTH + F4FConstants.FIELD_LARGE_SIZE_LENGTH + F4FConstants.FIELD_EXTENDED_TYPE_LENGTH;
			_bytesReadSinceAfraStart = 0;
			_countingReadBytes = false;
			_boxInfoPending = true;
			_nextBox = null;
		}
		
		/**
		 * @private
		 */	
		override public function get inputBytesNeeded():Number
		{
			return _bytesNeeded;
		}
		
		/**
		 * @private
		 */		
		override public function processFileSegment(input:IDataInput):ByteArray
		{
			if (input.bytesAvailable < _bytesNeeded)
			{
				return null;
			}

			var returnByteArray:ByteArray = null;

			var bytesRead:Number = F4FConstants.FIELD_SIZE_LENGTH + F4FConstants.FIELD_TYPE_LENGTH;
						
			if (_boxInfoPending)
			{
				_ba = new ByteArray();
				
				input.readBytes(_ba, 0, bytesRead);
				if (_countingReadBytes)
				{
					_bytesReadSinceAfraStart += bytesRead;
				}
				
				_parser.init(_ba);
				_nextBox = _parser.getNextBoxInfo();
				if (_nextBox.size == F4FConstants.FLAG_USE_LARGE_SIZE)
				{
					bytesRead += F4FConstants.FIELD_LARGE_SIZE_LENGTH;
					
					_ba.position = 0;
					input.readBytes(_ba, 0, F4FConstants.FIELD_LARGE_SIZE_LENGTH);
					if (_countingReadBytes)
					{
						_bytesReadSinceAfraStart += F4FConstants.FIELD_LARGE_SIZE_LENGTH;
					}
					_nextBox.size = _parser.readLongUIntToNumber();
				}
				
				// TODO: Check for extended type too.
				
				_boxInfoPending = false;
				if (_nextBox.type == F4FConstants.BOX_TYPE_MDAT)
				{
					_bytesNeeded = 0;
					_mdatBytesPending = _nextBox.size - bytesRead;
				}
				else
				{
					_bytesNeeded = _nextBox.size - bytesRead;
					_mdatBytesPending = 0;
					if (_nextBox.type == F4FConstants.BOX_TYPE_AFRA)
					{
						_bytesReadSinceAfraStart = bytesRead;
						_countingReadBytes = true;
					}
				}
			}
			// otherwise, we are not waiting for BoxInfo but the actual box contents
			else if (_bytesNeeded > 0)
			{
				var pos:uint = _ba.position;
				input.readBytes(_ba, _ba.length, _nextBox.size - bytesRead);
				if (_countingReadBytes)
				{
					_bytesReadSinceAfraStart += (_nextBox.size - bytesRead);
				}
				_ba.position = pos;
				
				if (_nextBox.type == F4FConstants.BOX_TYPE_ABST)
				{
					// TODO: update the _abst
				} 
				else if (_nextBox.type == F4FConstants.BOX_TYPE_AFRA)
				{
					_afra = _parser.readFragmentRandomAccessBox(_nextBox);
					processSeekToTime();
				}
				else if (_nextBox.type == F4FConstants.BOX_TYPE_MOOF)
				{
					// Don't need to do anything with a MOOF box, so skip and move on.
				}

				_bytesNeeded = F4FConstants.FIELD_SIZE_LENGTH + F4FConstants.FIELD_TYPE_LENGTH + F4FConstants.FIELD_LARGE_SIZE_LENGTH + F4FConstants.FIELD_EXTENDED_TYPE_LENGTH;
				_boxInfoPending = true;
				_nextBox = null;
			}
			else
			{
				returnByteArray = getMDATBytes(input, false);
			}
			
			return returnByteArray;
		}
		
		/**
		 * @private
		 */	
		override public function endProcessFile(input:IDataInput):ByteArray
		{
			return getMDATBytes(input, true);
		}	

		/**
		 * @private
		 */	
		override public function flushFileSegment(input:IDataInput):ByteArray
		{
			return null;
		}
		
		// Internal
		//
		
		private function getMDATBytes(input:IDataInput, endOfFile:Boolean):ByteArray
		{
			if (input == null)
			{
				return null;
			}
			
			skipSeekBytes(input);
			
			var ba:ByteArray;
			if (_mdatBytesPending > 0)
			{
				var bytesToRead:uint = _mdatBytesPending < input.bytesAvailable? _mdatBytesPending : input.bytesAvailable;
				if (!endOfFile && bytesToRead > MAX_BYTES_PER_MDAT_READ)
				{
					bytesToRead = MAX_BYTES_PER_MDAT_READ;
				}
				ba = new ByteArray();
				_mdatBytesPending -= bytesToRead;
				input.readBytes(ba, 0, bytesToRead);
			}
			
			return ba;
		}
		
		private function skipSeekBytes(input:IDataInput):void
		{
			if (_bytesReadSinceAfraStart < _mdatBytesOffset)
			{
				var skip:uint = _mdatBytesOffset - _bytesReadSinceAfraStart;
				if (input.bytesAvailable < skip)
				{
					skip = input.bytesAvailable;
				}
				
				var ba:ByteArray = new ByteArray();
				input.readBytes(ba, 0, skip);
				_bytesReadSinceAfraStart += skip;
				_mdatBytesPending -= skip;
			}
		}
		
		/**
		 * File handler notifies HTTPNetStream of segment duration (fragment duration in
		 * f4f terminology) and time bias if it is actually a seek.
		 * 
		 * The segment duration can be known by the file index handler if there is no
		 * seek. Otherwise, file handler needs to consult the afra box to figure that out.
		 * This means that NOTIFY_SEGMENT_DURATION can be done from two places, which is 
		 * desirable. Therefore, we have only file handler report the segment duration.
		 * 
		 * For the seek case, segment duration is the duration of the whole segment minus
		 * the portion to be skipped.
		 */
		private function processSeekToTime():void
		{
			var timeBias:Number = 0;
			var entry:LocalRandomAccessEntry = null;
			
			if (_seekToTime <= 0)
			{
				_mdatBytesOffset = 0;
			}
			else
			{
				entry = getMDATBytesOffset(_seekToTime);
				if (entry != null)
				{
					_mdatBytesOffset = entry.offset;
					timeBias = entry.time;
				} 
				else
				{
					_mdatBytesOffset = 0;
				}
			}
			
			// TODO: Can we move the calculateSegmentDuration out of here, and have
			// it called by the receiver of the event?  This would decouple us from
			// the index handler.  We'd probably need to change the event to be
			// "notify time bias and time scale", or something like that.
			var duration:Number = _indexHandler ? _indexHandler.calculateSegmentDuration(timeBias) : 0;
			var event:HTTPStreamingFileHandlerEvent = new HTTPStreamingFileHandlerEvent(
				HTTPStreamingFileHandlerEvent.NOTIFY_SEGMENT_DURATION, false, false, 0, duration / _afra.timeScale); 
			dispatchEvent(event);
			
			if (entry != null)
			{
				event = new HTTPStreamingFileHandlerEvent(
					HTTPStreamingFileHandlerEvent.NOTIFY_TIME_BIAS, false, false, timeBias / _afra.timeScale);
				dispatchEvent(event);
			}
		}
		
		private function getMDATBytesOffset(seekToTime:Number):LocalRandomAccessEntry
		{
			return (!isNaN(seekToTime))? _afra.findNearestKeyFrameOffset(seekToTime * _afra.timeScale) : null;
		}

		private var _afra:AdobeFragmentRandomAccessBox;
		private var _ba:ByteArray;
		private var _boxInfoPending:Boolean;
		private var _bytesNeeded:uint;
		private var _bytesReadSinceAfraStart:uint;
		private var _countingReadBytes:Boolean;
		private var _mdatBytesPending:uint;
		private var _nextBox:BoxInfo;
		private var _parser:BoxParser = new BoxParser();
		private var _seekToTime:Number;
		private var _mdatBytesOffset:Number;
		private var _indexHandler:HTTPStreamingF4FIndexHandler;
		
		private static const MAX_BYTES_PER_MDAT_READ:uint = 5*1024;
	}
}