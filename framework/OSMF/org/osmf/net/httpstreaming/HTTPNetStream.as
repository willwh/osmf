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
package org.osmf.net.httpstreaming
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.Timer;
	
	import org.osmf.elements.f4mClasses.BootstrapInfo;
	import org.osmf.events.DVRStreamInfoEvent;
	import org.osmf.events.HTTPStreamingEvent;
	import org.osmf.events.HTTPStreamingFileHandlerEvent;
	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.net.httpstreaming.dvr.DVRInfo;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FFileHandler;
	import org.osmf.net.httpstreaming.f4f.HTTPStreamingF4FIndexInfo;
	import org.osmf.net.httpstreaming.flv.FLVHeader;
	import org.osmf.net.httpstreaming.flv.FLVParser;
	import org.osmf.net.httpstreaming.flv.FLVTag;
	import org.osmf.net.httpstreaming.flv.FLVTagAudio;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataMode;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;
	import org.osmf.net.httpstreaming.flv.FLVTagVideo;
	
	[Event(name="DVRStreamInfo", type="org.osmf.events.DVRStreamInfoEvent")]
	
	CONFIG::LOGGING 
	{	
		import org.osmf.logging.Logger;
	}
	
	CONFIG::FLASH_10_1	
	{
		import flash.net.NetStreamAppendBytesAction;
	}
	
	[ExcludeClass]
	
	/**
	 * 
	 * @private
	 * 
	 * HTTPNetStream is a NetStream subclass which can accept input via the
	 * appendBytes method.  In general, the assumption is that a large media
	 * file is broken up into a number of smaller fragments.
	 * 
	 * There are two important aspects of working with an HTTPNetStream:
	 * 1) How to map a specific playback time to the media file fragment
	 * which holds the media for that time.
	 * 2) How to unmarshal the data from a media file fragment so that it can
	 * be fed to the NetStream as TCMessages. 
	 * 
	 * The former is the responsibility of HTTPStreamingIndexHandlerBase,
	 * the latter the responsibility of HTTPStreamingFileHandlerBase.
	 */	
	public class HTTPNetStream extends NetStream 
	{
		/**
		 * Constructor.
		 * 
		 * @param connection The NetConnection to use.
		 * @param indexHandler Object which exposes the index, which maps
		 * playback times to media file fragments.
		 * @param fileHandler Object which canunmarshal the data from a
		 * media file fragment so that it can be fed to the NetStream as
		 * TCMessages.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPNetStream( connection:NetConnection, factory:HTTPStreamingFactory, resource:URLResource = null)
		{
			super(connection);
			this.resource = resource;
			this.factory = factory;
			
			_mediaHandler = new HTTPStreamSourceHandler(factory, resource);
			_mediaHandler.addEventListener(HTTPStreamingIndexHandlerEvent.INDEX_READY, onIndexReady);
			_mediaHandler.addEventListener(DVRStreamInfoEvent.DVRSTREAMINFO, onDVRStreamInfo);
			_mediaHandler.addEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
			_mediaHandler.addEventListener(HTTPStreamingEvent.INDEX_ERROR, onIndexError);
			_mediaHandler.addEventListener(HTTPStreamingEvent.FILE_ERROR, onFileError);
			
			mainTimer = new Timer(MAIN_TIMER_INTERVAL); 
			mainTimer.addEventListener(TimerEvent.TIMER, onMainTimer);	
			mainTimer.start();
			
			this.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		/**
		 * Getters/(setters if applicable) of a bunch of properties related to the quality of service.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get downloadRatio():Number
		{
			return _lastDownloadRatio;
		}
		
		public function DVRGetStreamInfo(streamName:Object):void
		{
			if (indexIsReady)
			{
				// TODO: should there be _indexHandler.DVRGetStreamInfo() to re-trigger the event?
			}
			else
			{
				// TODO: should there be a guard to protect the case where indexIsReady is not yet true BUT play has already been called, so we are in an
				// "initializing but not yet ready" state? This is only needed if the caller is liable to call DVRGetStreamInfo and then, before getting the
				// event back, go ahead and call play()
				_mediaHandler.dvrGetStreamInfo(streamName);
			}
		}
		
		// Overrides
		//
		
		/**
		 * The arguments to this method can mirror the arguments to the
		 * superclass's method:
		 * 1) media file
		 * 2) URL
		 * 3) name/start/len/reset
		 *		a) Subclips
		 *		b) Live
		 *		c) Resetting playlist
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function play(...args):void 
		{
			if (args.length < 1)
			{
				throw new Error("HTTPStream.play() requires at least one argument");
			}
			
			// Signal to the base class that we're entering Data Generation Mode.
			super.play(null);
			
			_notifyPlayStartPending = true;
			
			// Before we feed any TCMessages to the Flash Player, we must feed
			// an FLV header first.
			var header:FLVHeader = new FLVHeader();
			var headerBytes:ByteArray = new ByteArray();
			header.write(headerBytes);
			attemptAppendBytes(headerBytes);
			
			// Initialize ourselves and the index handler.
			setState(HTTPStreamingState.INIT);
			_initialTime = -1;
			_seekTime = -1;
			
			indexIsReady = false;
			_mediaHandler.initialize(args[0]);
						
			if (args.length >= 2)
			{
				_seekTarget = Number(args[1]);
				if (_seekTarget < 0)
				{
					if (_dvrInfo != null)
					{
						_seekTarget = _dvrInfo.startTime;
					}
					else
					{
						_seekTarget = 0;	// FMS behavior, mimic -1 or -2 being passed in
					}
				}
			}
			else
			{
				// This is the start of playback, so no seek.
				_seekTarget = 0;
			}
			
			if (args.length >= 3)
			{
				_playForDuration = Number(args[2]);
			}
			else
			{
				_playForDuration = -1;
			}
			
			_notifyPlayUnpublishPending = false;
		}
		
		/**
		 * @private
		 */
		override public function play2(param:NetStreamPlayOptions):void
		{
			if (param.transition == NetStreamPlayTransitions.RESET)
			{
				// XXX Need to reset playback if we're already playing.
				// Is this done via seek?
				
				// The only difference between play and play2 for the RESET
				// case is that play2 might start at a specific quality level.
				// commented out due the fact that _streamNames array is initialized
				// after the play has been called - until play this array is null
				// from now on, the setQualityLevelForStreamName is called inside play method
				// setQualityLevelForStreamName(param.streamName);
				
				play(param.streamName, param.start, param.len);
			}
			else if (param.transition == NetStreamPlayTransitions.SWITCH)
			{
				changeQualityLevelTo(param.streamName);
			}
			else if (param.transition == NetStreamPlayTransitions.SWAP)
			{
				changeAudioStreamTo(param.streamName);
			}
			else
			{
				// Not sure which other modes we should add support for.
				super.play2(param);
			}
		} 
		

		/**
		 * @private
		 */
		override public function seek(offset:Number):void
		{
			// (change to override seek rather than do this based on seek notify event)
			//  can't do this unless you're already playing (for instance, you can't leave INIT to go to SEEK)! 
			// XXX need to double-check to see if there's more guards needed here
			
			if(offset < 0)
			{
				offset = 0;		// FMS rule. Seek to <0 is same as seeking to zero.
			}
			
			if (_state != HTTPStreamingState.INIT)    // can't seek before playback starts
			{
				if(_initialTime < 0)
				{
					_seekTarget = offset + 0;	// this covers the "don't know initial time" case, rare
				}
				else
				{
					_seekTarget = offset + _initialTime;
				}
				_seekTargetAlt = _seekTarget;
				
				_seekTime = -1;		// but _initialTime stays known
				setState(HTTPStreamingState.SEEK);		
				super.seek(offset);
			}
			
			_notifyPlayUnpublishPending = false;
		}
		
		/**
		 * @private
		 */
		override public function close():void
		{
			indexIsReady = false;
			
			if (_mediaHandler != null)
			{
				_mediaHandler.close();
			}
			if (_audioHandler != null)
			{
				_audioHandler.close();
			}
			
			setState(HTTPStreamingState.HALT);
			
			mainTimer.stop();
			
			notifyPlayStop();
			
			// XXX might need to do other things here
			super.close();
		}
		
		/**
		 * @private
		 */
		override public function get time():Number
		{
			if(_seekTime >= 0 && _initialTime >= 0)
			{
				_lastValidTimeTime = (super.time + _seekTime) - _initialTime; 
				//  we remember what we say when time is valid, and just spit that back out any time we don't have valid data. This is probably the right answer.
				//  the only thing we could do better is also run a timer to ask ourselves what it is whenever it might be valid and save that, just in case the
				//  user doesn't ask... but it turns out most consumers poll this all the time in order to update playback position displays
			}
			return _lastValidTimeTime;
		}
		
		/// Internal
		
		/**
		 * @private
		 * Saves the current state of the object and sets it to the value specified.
		 **/ 
		private function setState(value:String):void
		{
			_previousState = _state;
			_state = value;
		}
		
		private function insertScriptDataTag(tag:FLVTagScriptDataObject, first:Boolean = false):void
		{
			if (!_insertScriptDataTags)
			{
				_insertScriptDataTags = new Vector.<FLVTagScriptDataObject>();
			}
			
			if (first)
			{
				_insertScriptDataTags.unshift(tag);	// push front
			}
			else
			{
				_insertScriptDataTags.push(tag);
			}
		}
		
		private function flvTagHandler(tag:FLVTag):Boolean
		{
			// this is the new common FLVTag Parser's tag handler
			var i:int;
			
			if (_insertScriptDataTags)
			{
				for (i = 0; i < _insertScriptDataTags.length; i++)
				{
					var t:FLVTagScriptDataObject;
					var bytes:ByteArray;
					
					t = _insertScriptDataTags[i];
					t.timestamp = tag.timestamp;
					
					bytes = new ByteArray();
					t.write(bytes);
					_flvParserProcessed += bytes.length;
					attemptAppendBytes(bytes);
				}
				_insertScriptDataTags = null;			
			}
			
			if (_playForDuration >= 0)
			{
				if (_initialTime >= 0)	// until we know this, we don't know where to stop, and if we're enhanced-seeking then we need that logic to be what sets this up
				{
					var currentTime:Number = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
					if (currentTime > (_initialTime + _playForDuration))
					{
						setState(HTTPStreamingState.STOP);
						_flvParserDone = true;
						if (_seekTime < 0)
						{
							_seekTime = _playForDuration + _initialTime;	// FMS behavior... the time is always the final time, even if we seek to past it
							// XXX actually, FMS  actually lets exactly one frame though at that point and that's why the time gets to be what it is
							// XXX that we don't exactly mimic that is also why setting a duration of zero doesn't do what FMS does (plays exactly that one still frame)
						}
						return false;
					}
				}
			}
			
			if (_initialTime < 0)
			{
				if (_dvrInfo != null)
				{
					_initialTime = _dvrInfo.startTime;
				}
				else
				{
					_initialTime = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
				}
			}
			
			if (_seekTime < 0)
			{
				_seekTime = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
			}
			
			// finally, pass this one on to appendBytes...
			bytes = new ByteArray();
			tag.write(bytes);
			_flvParserProcessed += bytes.length;
			attemptAppendBytes(bytes);
			
			// probably done seeing the tags, unless we are in playForDuration mode...
			if (_playForDuration >= 0)
			{
				if (_fragmentDuration >= 0 && _flvParserIsSegmentStart)
				{
					// if the segmentDuration has been reported, it is possible that we might be able to shortcut
					// but we need to be careful that this is the first tag of the segment, otherwise we don't know what duration means in relation to the tag timestamp
					
					_flvParserIsSegmentStart = false; // also used by enhanced seek, but not generally set/cleared for everyone. be careful.
					currentTime = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
					if (currentTime + _fragmentDuration >= (_initialTime + _playForDuration))
					{
						// it stops somewhere in this segment, so we need to keep seeing the tags
						return true;
					}
					else
					{
						// stop is past the end of this segment, can shortcut and stop seeing tags
						_flvParserDone = true;
						return false;
					}
				}
				else
				{
					return true;	// need to continue seeing the tags because either we don't have duration, or started mid-segment so don't know what duration means
				}
			}
			// else not in playForDuration mode...
			_flvParserDone = true;
			return false;
		}
		
		private function processAndAppend(inBytes:ByteArray):uint
		{
			var bytes:ByteArray;
			var processed:uint = 0;
			
			if (!inBytes || inBytes.length == 0)
			{
				return 0;
			}
			
			if (_flvParser)
			{
				inBytes.position = 0;	// rewind
				_flvParserProcessed = 0;
				_flvParser.parse(inBytes, true, flvTagHandler);	// common handler for FLVTags, parser consumes everything each time just as appendBytes does when in pass-through
				processed += _flvParserProcessed;
				if(!_flvParserDone)
				{
					// the common parser has more work to do in-path
					return processed;
				}
				else
				{
					// the common parser is done, so flush whatever is left and then pass through the rest of the segment
					bytes = new ByteArray();
					_flvParser.flush(bytes);
					_flvParser = null;	// and now we're done with it
				}
			}
			else
			{
				bytes = inBytes;
			}
			
			// now, 'bytes' is either what came in or what we massaged above 
			
			// (ES is now part of unified parser)
			
			processed += bytes.length;
			
			if (_state != HTTPStreamingState.STOP)	// we might exit this state
			{
				attemptAppendBytes(bytes);
			}
			
			return processed;
		}
		
		private function onMainTimer(timerEvent:TimerEvent):void
		{	
			var flushExistingContent:Boolean = false;
			
			var bytes:ByteArray;
			var d:Date = new Date();
			var info:Object = null;
			var sdoTag:FLVTagScriptDataObject = null;
			
			CONFIG::LOGGING
			{
				if (_state != previouslyLoggedState)
				{
					logger.debug("State = " + _state);
					previouslyLoggedState = _state;
				}
			}
			
			switch (_state)
			{
				// INIT case
				case HTTPStreamingState.INIT:
					_seekAfterInit = true;
					break;
				
				// SEEK case
				case HTTPStreamingState.SEEK:
					_mediaHandler.close();
					if (_audioHandler != null)
					{
						_audioHandler.close();
					}
					setState(HTTPStreamingState.LOAD_SEEK);
					break;
				
				
				// LOAD cases
				case HTTPStreamingState.LOAD_WAIT:
					// XXX this delay needs to shrink proportionate to the last download ratio... when we're close to or under 1, it needs to be no delay at all
					// XXX unless the bufferLength is longer (this ties into how fast switching can happen vs. timeliness of dispatch to cover jitter in loading)
					
					// XXX for now, we have a simplistic dynamic handler, in that if downloads are going poorly, we are a bit more aggressive about prefetching
					if ( this.bufferLength < Math.max(4, this.bufferTime))
					{
						if (_audioHandler != null && ((_bufferRemaining > 500) || _mediaRequest == null) && ((_bufferRemainingAudio > 500) || _audioRequest == null ))
						{
							setState(HTTPStreamingState.PLAY);
						}
						else
						{
							setState(HTTPStreamingState.LOAD_NEXT);
						}
					}
					else
					{
						setState(HTTPStreamingState.PLAY);
					}
					break;
				
				case HTTPStreamingState.LOAD_NEXT:
					if (_mediaNeedsChanging)
					{
						changeQualityLevelTo(_mediaUrl);
					}
					if (_audioNeedsChanging)
					{
						changeAudioStreamTo(_audioUrl);
					}
					
//					if (_audioHasChanged)
//					{
//						flushExistingContent = true;
//						
//						if (_sourceAudio != null)
//						{
//							_fileHandlerAudio.flushFileSegment(_sourceAudio.getBytes());
//						}
//						
////						_fileHandler.flushVideoInput();
////						_fileHandler.flushAudioInput();
//						
//						notifyTransitionComplete(_sourceAudioUrl);
//						_audioHasChanged = false;
//					}
//					
//					if (flushExistingContent)
//					{
//						_mediaHandler.flushContent();
//					}
					
					setState(HTTPStreamingState.LOAD);
					break;
				
				case HTTPStreamingState.LOAD_SEEK:
					if (_mediaNeedsChanging)
					{
						changeQualityLevelTo(_mediaUrl);
					}
					if (_audioNeedsChanging)
					{
						changeAudioStreamTo(_audioUrl);
					}
					
					// seek always must flush per contract
					if (!_seekAfterInit)
					{
						flushExistingContent = true;
						
//						_fileHandler.flushAudioInput();
//						_fileHandler.flushVideoInput();
						prevAudioTime = 0;
						prevVideoTime = 0;
						
						_bufferRemaining = 0;
						_bufferRemainingAudio = 0;
					}
					
					CONFIG::FLASH_10_1
					{
						appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
					}
					
					_seekAfterInit = false;
					
					
//					if (_audioHasChanged)
//					{
//						flushExistingContent = true;
//						if (_sourceAudio != null)
//						{
//							_fileHandlerAudio.flushFileSegment(_sourceAudio.getBytes());
//						}
//						
////						_fileHandler.flushVideoInput();
////						_fileHandler.flushAudioInput();
//
//						notifyTransitionComplete(_sourceAudioUrl);
//						_audioHasChanged = false;
//					}

					if (flushExistingContent)
					{
						_mediaHandler.flushContent();
						if (_audioHandler != null)
						{
							_audioHandler.flushContent();
						}
					}
					
					setState(HTTPStreamingState.LOAD);
					break;
				
				case HTTPStreamingState.LOAD:
					
					if (_notifyPlayStartPending)
					{
						notifyPlayStart();
						_notifyPlayStartPending = false;
					}

					if (_mediaHasChanged)
					{
						// process remaining bytes
						//bytes = _mediaHandler.flushContent();
						//processAndAppend(bytes);
						
						_mediaHasChanged = false;
						notifyTransitionComplete(_mediaHandler.url);
					}
					
					if (_audioHasChanged)
					{
						_audioHasChanged = false;
						notifyTransitionComplete(_audioHandler.url);
					}
					
					var nextState:String = null;
					var retryState:String = null;
					
					_fragmentDuration = -1;	// we now track whether or not this has been reported yet for this segment by the Index or File handler
					switch (_previousState)
					{
						case HTTPStreamingState.LOAD_SEEK:
						case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
							nextState = HTTPStreamingState.PLAY_START_SEEK;
							retryState = HTTPStreamingState.LOAD_SEEK_RETRY_WAIT;
							
							if (_mediaHandler.isFragmentEnd)
							{
								_mediaRequest = _mediaHandler.getFileForTime(_seekTarget);
							}
							if (_audioHandler != null && _audioHandler.isFragmentEnd)
							{
								_audioRequest = _audioHandler.getFileForTime(_seekTarget);
							}
							break;
						
						case HTTPStreamingState.LOAD_NEXT:
						case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
							nextState = HTTPStreamingState.PLAY_START_NEXT;
							retryState = HTTPStreamingState.LOAD_NEXT_RETRY_WAIT;

							if (_mediaHandler.isFragmentEnd)
							{
								_mediaRequest = _mediaHandler.getNextFile();
							}
							if (_audioHandler != null && _audioHandler.isFragmentEnd)
							{
								_audioRequest = _audioHandler.getNextFile();
							}
							break;
						default:
							throw new Error("in HTTPStreamState.LOAD with unknown previous state " + _previousState);
							break;
					}
					
					if (
							(_mediaHandler.isFragmentEnd && _mediaRequest == null)
						&& 	(_audioHandler != null && _audioHandler.isFragmentEnd && _audioRequest == null)
					)
					{
						// if we finished processing current fragments and we know for sure 
						// that we don't have any additional data, we halt
						setState(HTTPStreamingState.HALT);
					}
					else if (
							(_mediaRequest != null && _mediaRequest.urlRequest != null)
						||  (_audioRequest != null && _audioRequest.urlRequest != null)
					)
					{
						// if we finished processing current fragments and we have additional data
						// we start loading the additional data
						if (_mediaHandler.isFragmentEnd && (_mediaRequest != null) && (_mediaRequest.urlRequest != null))
						{
							_mediaHandler.open(_mediaRequest);
						}
						if (_audioHandler != null && _audioHandler.isFragmentEnd && (_audioRequest != null) && (_audioRequest.urlRequest != null))
						{
							_audioHandler.open(_audioRequest);
						}
						
						setState(nextState);
					}
					else if (
							(_mediaRequest != null && _mediaRequest.retryAfter >= 0)
						||  (_audioRequest != null && _audioRequest.retryAfter >= 0)
						)
					{
						// if we finished processing current fragments and we don't know if we have any additional
						// data, we are waiting a little for things to update
						var waitInterval:Number = 0; 
						if (_mediaRequest != null)
							waitInterval = _mediaRequest.retryAfter;
						if (_audioRequest != null && waitInterval < _audioRequest.retryAfter)
							waitInterval = _audioRequest.retryAfter;
						
						date = new Date();
						_retryAfterWaitUntil = date.getTime() + (1000.0 * waitInterval);
						setState(retryState);
					}
					else
					{
						// WHY ONLY VIDEO? IT SHOULD ALSO SUPPORT AUDIO
						//bytes = _mediaHandler.flushContent();
						//processAndAppend(bytes);
						
						setState(HTTPStreamingState.STOP);
						if (_mediaRequest != null && _mediaRequest.unpublishNotify)
						{
							_notifyPlayUnpublishPending = true;								
						}
					}
					break;
				
				case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:								
				case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
					var date:Date = new Date();
					if (date.getTime() > _retryAfterWaitUntil)
					{
						setState(HTTPStreamingState.LOAD);			
					}
					break;					
				
				case HTTPStreamingState.PLAY_START_NEXT:
					_mediaHandler.beginProcessing(false, 0);
					if (_audioHandler != null /*&& _audioHandler.isFragmentEnd*/)
					{
						_audioHandler.beginProcessing(false, 0); 
					}
					
					setState(HTTPStreamingState.PLAY_START_COMMON);
					break;
				
				case HTTPStreamingState.PLAY_START_SEEK:		
					_mediaHandler.beginProcessing(true, _seekTarget);
					if (_audioHandler != null /*&& _audioHandler.isFragmentEnd*/)
					{
						_audioHandler.beginProcessing(true, _seekTargetAlt);
					}
					
					setState(HTTPStreamingState.PLAY_START_COMMON);
					break;		
				
				case HTTPStreamingState.PLAY_START_COMMON:
					// need to run the common FLVParser?
					if (_initialTime < 0 || _seekTime < 0 || _insertScriptDataTags ||  _playForDuration >= 0)
					{
						if (_playForDuration >= 0)
						{
							_flvParserIsSegmentStart = true;	// warning, this isn't generally set/cleared, just used by these two cooperating things
						}
						_flvParser = new FLVParser(false);
						_flvParserDone = false;
					}
					
					setState(HTTPStreamingState.PLAY);
					break;
				
				case HTTPStreamingState.PLAY:
					
					if (
							_mediaHandler.hasData || 
							(_audioHandler != null && _audioHandler.hasData)
					)
					{
						var processLimit:int = 65000*4;	// XXX needs to be settable
						var processed:int = 0;
					
						do 
						{
							if (_audioHandler == null)
							{
								bytes = _mediaHandler.processContent();
							}
							else
							{
								var mediaBytes:ByteArray = _mediaHandler.processContent();
								var audioBytes:ByteArray = _audioHandler.processContent();
								bytes = _mixer.mixMDATBytes(mediaBytes, audioBytes);
								if (bytes != null && bytes.bytesAvailable == 0)
									bytes = null;
							}
							
							if (bytes != null)									
								processed += processAndAppend(bytes);
								
							if (processLimit > 0 && processed >= processLimit)
							{
								break;
							}
						}
						while (_state == HTTPStreamingState.PLAY && bytes != null);
					}
					if (_state != HTTPStreamingState.PLAY)
						break;
					
					var isFragmentEnd:Boolean = _mediaHandler.isFragmentEnd;
					if (_audioHandler != null)
						isFragmentEnd ||= _audioHandler.isFragmentEnd;
					
					if (_mediaHandler.isFragmentEnd)
					{
						_mediaHandler.saveContent();
					}
					if (_audioHandler != null && _audioHandler.isFragmentEnd)
					{
						_audioHandler.saveContent();
					}
					
					if (isFragmentEnd)
					{
						setState(HTTPStreamingState.END_FRAGMENT);
					}
					
//					_endFragment = false;
//					_endFragmentAudio = false;
//					var needMoreVideo:Boolean = false;
//					var needMoreAudio:Boolean = false;
//					
//					if (
//						 _mediaHandler.hasData
//						||  (_sourceAudio != null && _sourceAudio.hasData) 
//						|| ((_bufferRemaining > 500) && (_bufferRemainingAudio > 500)) 
//						|| (_mediaRequest == null) || (_nextRequestAudio == null))
//					{
//						var processLimit:int = 65000*4;	// XXX needs to be settable
//						var processed:int = 0;
//						
//						var input:IDataInput = null;
//						var inputAlt:IDataInput = null;
//						
//						if (indexInfoAlt == null || !_indexIsReadyAlt)
//						{
//							do 
//							{
//								bytes = _mediaHandler.processContent();
//								if (bytes != null)									
//									processed += processAndAppend(bytes);
//									
//								if (processLimit > 0 && processed >= processLimit)
//								{
//									break;
//								}
//							}
//							while (_state == HTTPStreamingState.PLAY && bytes != null);
//						}
//						else
//						{
////							while (
////								_state == HTTPStreamingState.PLAY 
////								&& (
////									(_source != null && (input = _source.getBytes(_fileHandler.inputBytesNeeded))) 
////									|| (_bufferRemaining > 500) 
////									|| (_mediaRequest == null)
////								) 
////								&& (
////									(_sourceAudio != null && (inputAlt = _sourceAudio.getBytes(_fileHandlerAudio.inputBytesNeeded))) 
////									|| (_bufferRemainingAudio > 500) 
////									/*|| (nextRequestAlt == null)*/
////								)
////							)
////							{
////								// saayan start
////								prevAudioTime = _fileHandler.mixedAudioTime;
////								prevVideoTime = _fileHandler.mixedVideoTime;
////								
////								var vbytes:ByteArray = new ByteArray();
////								var abytes:ByteArray = new ByteArray();
////								if (input && (input.bytesAvailable > 0))
////								{
////									vbytes = _fileHandler.processFileSegment(input);
////								}
////								if (inputAlt && (inputAlt.bytesAvailable > 0))
////								{
////									abytes = _fileHandlerAudio.processFileSegment(inputAlt);
////								}
////								
////								bytes = _fileHandler.mixMDATBytes(vbytes,abytes);
////								
////								if (_fileHandler.videoInput.bytesAvailable == 0)
////									_bufferRemaining = 0;
////								if (_fileHandler.audioInput.bytesAvailable == 0)
////									_bufferRemainingAudio = 0;
////								
////								
////								_bufferRemaining -= _fileHandler.mixedVideoTime - prevVideoTime;
////								_bufferRemainingAudio -= _fileHandler.mixedAudioTime - prevAudioTime;
////								//	trace("video:", videoBufferRemaining, "(",_fileHandler.videoInput.bytesAvailable, "bytes), audio:", audioBufferRemaining, "(",_fileHandler.audioInput.bytesAvailable, "bytes)");
////								
////								// one of the buffers is empty
////								if ((_fileHandler.mixedAudioTime == prevAudioTime) && !(input && (input.bytesAvailable > 0)) 
////									&& ((_bufferRemainingAudio > 1000) && (_bufferRemaining < 1000) )) 
////								{
////									needMoreVideo =  true;
////								}
////								
////								if (!(inputAlt && (inputAlt.bytesAvailable > 0)) && (_fileHandler.mixedVideoTime == prevVideoTime) 
////									&& ((_bufferRemaining > 1000) && (_bufferRemainingAudio < 1000)))
////								{
////									needMoreAudio = true;
////								}
////								
////								if ((needMoreVideo && (_mediaRequest != null)) || (needMoreAudio && (_nextRequestAudio != null))) 
////								{
////									break;	
////								}
////								//_socket.writeBytes(bytes);
////								//_socket.flush();
////								
////								processed += processAndAppend(bytes);
////								// saayan end
////								
////								if (processLimit > 0 && processed >= processLimit)
////								{
////									break;
////								}
////							}
//						}
//						
//						if(_state != HTTPStreamingState.PLAY)
//							break;
//						
//						// XXX if the reason we bailed is that we didn't have enough bytes, then if loadComplete we need to consume the rest into our save buffer
//						// OR, if we don't do cross-segment saving then we simply need to ensure that we don't return but simply fall through to a later case
//						// for now, we do the latter (also see below)
//						if (_mediaRequest == null) needMoreAudio = true;
//						if (_nextRequestAudio == null) needMoreVideo = true;
//						
//						if (_source.isComplete && !_source.hasData && needMoreVideo)
//						{
//							_endFragment = true;
//						}
//						if ( _indexInfoAlt != null && _sourceAudio.isComplete && !_source.hasData && needMoreAudio)
//						{
//							_endFragmentAudio = true;
//						}
//						if (_endFragment && _endFragmentAudio)
//						{
//							//setState(HTTPStreamingState.LOAD_NEXT);
//							setState(HTTPStreamingState.LOAD_WAIT); // LOAD_NEXT?
//						}
//					}
//					else
//					{
//						if (_source.isComplete && !_source.hasData)
//						{
//							_endFragment = true;
//						}
//						if (_indexInfoAlt != null && _sourceAudio.isComplete && !_sourceAudio.hasData)
//						{
//							_endFragmentAudio = true;
//						}
//					}
//					
//					
//					
//					if (_endFragment)
//					{
//						// then save any leftovers for the next segment round. if this is a kind of filehandler that needs that, they won't suck dry in onEndSegment.
//						_source.saveBytes();
//						
//						
//						if (_indexInfoAlt) // dont go to end segment for late bound stream
//						{
//							setState(HTTPStreamingState.LOAD_WAIT); 
//						}
//						else 
//						{
//							setState(HTTPStreamingState.END_FRAGMENT);
//						}
//						
//					}
//					
//					if (_indexInfoAlt != null && _endFragmentAudio)
//					{
//						_sourceAudio.saveBytes();
//						setState(HTTPStreamingState.LOAD_WAIT);
//					}
//					if (_endFragment && _endFragmentAudio)
//					{
//						setState(HTTPStreamingState.LOAD_WAIT); // LOAD_NEXT?
//					}
					
					break;
				
				case HTTPStreamingState.END_FRAGMENT:
					// give _fileHandler a crack at any remaining data 
					
					//bytes = _mediaHandler.endProcessing();
					//processAndAppend(bytes);
					
					_lastDownloadRatio = _fragmentDuration / _lastDownloadDuration;	// urlcomplete would have fired by now, otherwise we couldn't be done, and onEndSegment is the last possible chance to report duration
					notifyFragmentEnd();					
					if (_state != HTTPStreamingState.STOP && _state != HTTPStreamingState.HALT)
					{ 
						setState(HTTPStreamingState.LOAD_WAIT);
					}
					break;
				
				case HTTPStreamingState.STOP:
					var playCompleteInfo:Object = new Object();
					playCompleteInfo.code = NetStreamCodes.NETSTREAM_PLAY_COMPLETE;
					playCompleteInfo.level = "status";
					
					var playCompleteInfoSDOTag:FLVTagScriptDataObject = new FLVTagScriptDataObject();
					playCompleteInfoSDOTag.objects = ["onPlayStatus", playCompleteInfo];
					
					var tagBytes:ByteArray = new ByteArray();
					playCompleteInfoSDOTag.write(tagBytes);
					
					CONFIG::FLASH_10_1
				{
					appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
					appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
				}
					
					attemptAppendBytes(tagBytes);
					setState(HTTPStreamingState.HALT);
					
					break;
				
				case HTTPStreamingState.HALT:
					// do nothing. timer could run slower in this state.
					break;
				
				default:
					throw new Error("HTTPStream cannot run undefined _state "+_state);
					break;
			}
		}
		
		private function onIndexReady(event:HTTPStreamingIndexHandlerEvent):void
		{
			if (!indexIsReady)
			{
				if (event.live && _dvrInfo == null && !isNaN(event.offset))
				{
					_seekTarget = _seekTargetAlt = event.offset;
				}
				
				setState(HTTPStreamingState.SEEK);	// was LOAD_SEEK, now want to pick up enhanced seek setup, if applicable. in the future, might want to change back?
				indexIsReady = true;
			}
		}
		
		private function onIndexReadyAlt(event:HTTPStreamingIndexHandlerEvent):void
		{
			if (!_indexIsReadyAlt)
			{
				if (event.live && _dvrInfo == null && !isNaN(event.offset))
				{
					_seekTarget = _seekTargetAlt = event.offset;
				}
				
				setState(HTTPStreamingState.SEEK);	// was LOAD_SEEK, now want to pick up enhanced seek setup, if applicable. in the future, might want to change back?
				_indexIsReadyAlt = true;
			}
		}
		
		
		private function attemptAppendBytes(bytes:ByteArray):void
		{
			// Do nothing if this is not an Argo player.
			CONFIG::FLASH_10_1
			{
				appendBytes(bytes);
			}
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			if (event.info.code == NetStreamCodes.NETSTREAM_BUFFER_EMPTY && _state == HTTPStreamingState.HALT) 
			{
				if (_notifyPlayUnpublishPending)
				{
					notifyPlayUnpublish();
					_notifyPlayUnpublishPending = false; 
				}
			}
		}
		
		///////////////////////////////////////////////////////////////////////
		/// Public
		///////////////////////////////////////////////////////////////////////
		
		///////////////////////////////////////////////////////////////////////
		/// Internals
		///////////////////////////////////////////////////////////////////////
		/**
		 * @private
		 * 
		 * Changes audio track to load from an alternate track.
		 */
		private function changeAudioStreamTo(streamName:String):void
		{
			_audioNeedsChanging = true;
			_audioUrl = streamName;
			if (_state != HTTPStreamingState.INIT) 
			{
				_audioNeedsChanging = false;
				if (_audioHandler == null || _audioHandler.url != _audioUrl)
				{
					_audioHasChanged = true;

					if (_audioHandler != null)
					{
						_audioHandler.close();
						_audioHandler.removeEventListener(HTTPStreamingIndexHandlerEvent.INDEX_READY, onIndexReady);
						_audioHandler.removeEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
						_audioHandler.removeEventListener(HTTPStreamingEvent.INDEX_ERROR, onIndexError);
						_audioHandler.removeEventListener(HTTPStreamingEvent.FILE_ERROR, onFileError);
						_audioHandler = null;
					}
					
					var audioResource:MediaResourceBase = HTTPStreamingUtils.createHTTPStreamingResource(resource, streamName);
					if (audioResource != null)
					{
						_audioHandler = new HTTPStreamSourceHandler(factory, audioResource);
						_audioHandler.addEventListener(HTTPStreamingIndexHandlerEvent.INDEX_READY, onIndexReady);
						_audioHandler.addEventListener(HTTPStreamingEvent.SCRIPT_DATA, onScriptData);
						_audioHandler.addEventListener(HTTPStreamingEvent.INDEX_ERROR, onIndexError);
						_audioHandler.addEventListener(HTTPStreamingEvent.FILE_ERROR, onFileError);
						_audioHandler.initialize(streamName);
						
						if (_mixer == null)
						{
							_mixer = factory.createMixer(resource);
						}
					}
										
					notifyTransition(_audioHandler != null ? _audioHandler.url : _audioUrl);
				}
			}
			
			_notifyPlayUnpublishPending = false;
		}

		
		/**
		 * @private
		 * 
		 * Changes the quality of the main stream.
		 */
		private function changeQualityLevelTo(streamName:String):void
		{
			_mediaNeedsChanging = true;
			_mediaUrl = streamName;
			if (_state != HTTPStreamingState.INIT)
			{
				_mediaNeedsChanging = false;
				if (_mediaHandler != null || _mediaHandler.url != _mediaUrl)
				{
					_mediaHasChanged = true;
					if (_mediaHandler != null)
						_mediaHandler.setQualityLevelTo(_mediaUrl);
					
					notifyTransition( _mediaHandler != null ? _mediaHandler.url : _mediaUrl);						
				}
			}
			
			_notifyPlayUnpublishPending = false;
		}
		
		/**
		 * Event handler for all DVR related information events.
		 */
		private function onDVRStreamInfo(event:DVRStreamInfoEvent):void
		{
			_dvrInfo = event.info as DVRInfo;
			dispatchEvent(event.clone());
		}

		/**
		 * @private
		 * 
		 * Event handler for all index handler errors.
		 */		
		private function onIndexError(event:HTTPStreamingEvent):void
		{
			notifyURLError(null);
		}
		
		/**
		 * @private
		 * 
		 * Event handler for all file handler errors.
		 */  
		private function onFileError(event:HTTPStreamingEvent):void
		{
			notifyFileError(null);
		}

		/**
		 * @private
		 * 
		 * Event handler invoked when we need to handle script data objects.
		 */
		private function onScriptData(event:HTTPStreamingEvent):void
		{
			CONFIG::LOGGING
			{
				logger.debug("onScriptData called with mode ", event.scriptDataMode);
			}
			if (event.scriptDataMode == null || event.scriptDataObject == null)
			{
				return;
			}
			
			switch (event.scriptDataMode)
			{
				case FLVTagScriptDataMode.NORMAL:
					insertScriptDataTag(event.scriptDataObject, false);
					break;
				
				case FLVTagScriptDataMode.FIRST:
					insertScriptDataTag(event.scriptDataObject, true);
					break;
				
				case FLVTagScriptDataMode.IMMEDIATE:
					if (client)
					{
						var methodName:* = event.scriptDataObject.objects[0];
						var methodParameters:* = event.scriptDataObject.objects[1];
						
						if (client.hasOwnProperty(methodName))
						{
							// XXX note that we can only support a single argument for immediate dispatch
							client[methodName](methodParameters);	
						}
					}
					break;
			}
		}

		/**
		 * @private
		 * 
		 * We notify the end of current fragment so that switching manager or any 
		 * other monitor object to have a chance to change the current quality level 
		 * or to change the state of the HTTPNetStream object. 
		 */
		private function notifyFragmentEnd():void
		{
			this.dispatchEvent(
				new HTTPStreamingEvent(
					HTTPStreamingEvent.FRAGMENT_END
				)
			);
		}

		/**
		 * @private
		 * 
		 * We notify that some error occured when processing the specified file.
		 * We actually map all URL errors to NETSTREAM_PLAY_STREAMNOTFOUND NetStatusEvent.
		 * You can check the details property to see the url which triggered 
		 * this error.
		 */
		private function notifyFileError(url:String):void
		{
			dispatchEvent( 
				new NetStatusEvent( 
					NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID, level:"error", details:url}
				)
			);
		}

		/**
		 * @private
		 * 
		 * We notify that the playback started only when we start loading the 
		 * actual bytes and not when the play command was issued. We do that by
		 * dispatching a NETSTREAM_PLAY_START NetStatusEvent.
		 */
		private function notifyPlayStart():void
		{
			dispatchEvent( 
				new NetStatusEvent( 
					NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_START, level:"status"}
				)
			); 
		}
		
		/**
		 * @private
		 * 
		 * We notify that the playback stopped only when close method is invoked.
		 * We do that by dispatching a NETSTREAM_PLAY_STOP NetStatusEvent.
		 */
		private function notifyPlayStop():void
		{
			dispatchEvent(
				new NetStatusEvent( 
					NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_STOP, level:"status"}
				)
			); 
		}
		
		/**
		 * @private
		 * 
		 * We dispatch NETSTREAM_PLAY_UNPUBLISH event when we are preparing
		 * to stop the HTTP processing.
		 */		
		private function notifyPlayUnpublish():void
		{
			dispatchEvent(
				new NetStatusEvent( 
					NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_UNPUBLISH_NOTIFY, level:"status"}
				)
			);
		}

		/**
		 * @private
		 * 
		 * We notify the starting of the switch so that the associated switch manager
		 * correctly update its state. We do that by dispatching a NETSTREAM_PLAY_TRANSITION
		 * event.
		 */
		private function notifyTransition(url:String):void
		{
			dispatchEvent( 
				new NetStatusEvent( 
					NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_TRANSITION, level:"status", details:url}
				)
			); 
		}
		
		/**
		 * @private
		 * 
		 * We notify the switch completition so that switch manager to correctly update 
		 * its state and dispatch any related event. We do that by inserting an 
		 * onPlayStatus data packet into the stream.
		 */
		private function notifyTransitionComplete(url:String):void
		{
			var info:Object = new Object();
			info.code = NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE;
			info.level = "status";
			info.details = url;
			
			var sdoTag:FLVTagScriptDataObject = new FLVTagScriptDataObject();
			sdoTag.objects = ["onPlayStatus", info];
			
			insertScriptDataTag(sdoTag);
		}
		
		/**
		 * @private
		 * 
		 * We notify that it was some error when downloading the desired url.
		 * We actually map all URL errors to NETSTREAM_PLAY_STREAMNOTFOUND NetStatusEvent.
		 * You can check the details property to see the url which triggered 
		 * this error.
		 */
		private function notifyURLError(url:String):void
		{
			dispatchEvent(
				new NetStatusEvent( 
					NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND, level:"error", details:url}
				)
			);
		}
		
		private static const MAIN_TIMER_INTERVAL:int = 25;
		
		private var _indexInfo:HTTPStreamingIndexInfoBase = null;
		private var mainTimer:Timer;
		private var _seekTarget:Number = -1;
		private var _lastDownloadDuration:Number;
		private var _lastDownloadRatio:Number = 0;
		private var _totalDuration:Number = -1;
		
		private var _flvParserIsSegmentStart:Boolean = false;
		private var _seekAfterInit:Boolean;
		private var indexIsReady:Boolean = false;
		private var _insertScriptDataTags:Vector.<FLVTagScriptDataObject> = null;
		private var _flvParser:FLVParser = null;	// this is the new common FLVTag Parser
		private var _flvParserDone:Boolean = true;	// signals that common parser has done everything and can be removed from path
		private var _flvParserProcessed:uint;
		
		private var _initialTime:Number = -1;	// this is the timestamp derived at start-of-play (offset or not)... what FMS would call "0"
		private var _seekTime:Number = -1;		// this is the timestamp derived at end-of-seek (enhanced or not)... what we need to add to super.time (assuming play started at zero)
		private var _fileTimeAdjustment:Number = 0;	// this is what must be added (IN SECONDS) to the timestamps that come in FLVTags from the file handler to get to the index handler timescale
		// XXX an event to set the _fileTimestampAdjustment is needed
		
		private var _playForDuration:Number = -1;
		private var _lastValidTimeTime:Number = 0;
		private var _retryAfterWaitUntil:Number = 0;	// millisecond timestamp (as per date.getTime) of when we retry next
		
		private	var prevVideoTime:uint = 0;
		private	var prevAudioTime:uint = 0;
		
		private	var _bufferRemaining:Number = 0;
		private var _fragmentDuration:Number = -1;
		
		private	var _bufferRemainingAudio:Number = 0;
		private var _fragmentDurationAudio:Number = -1;
		
		private var _seekTargetAlt:Number = -1;
		private var _indexIsReadyAlt:Boolean = false;
		
		
		// Internals
		private var resource:URLResource = null;
		private var factory:HTTPStreamingFactory = null;
		
		private var _notifyPlayStartPending:Boolean = false;
		private var _notifyPlayUnpublishPending:Boolean = false;
		
		private var _state:String = HTTPStreamingState.INIT;
		private var _previousState:String = null;
		
		private var _mediaHasChanged:Boolean = false;
		private var _mediaNeedsChanging:Boolean = false;
		private var _mediaUrl:String = null;
		private var _mediaHandler:HTTPStreamSourceHandler = null;
		private var _mediaRequest:HTTPStreamRequest = null;
		
		private var _audioHasChanged:Boolean = false;
		private var _audioNeedsChanging:Boolean = false;
		private var _audioUrl:String = null;
		private var _audioHandler:HTTPStreamSourceHandler = null;
		private var _audioRequest:HTTPStreamRequest = null;
		
		private var _mixer:HTTPStreamingMixerBase = null;
		
		private var _dvrInfo:DVRInfo = null;
		
		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPNetStream");
			private var previouslyLoggedState:String = null;
		}
	}
}
