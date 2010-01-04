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
package org.osmf.media
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.*;
	import org.osmf.traits.*;
	import org.osmf.utils.OSMFStrings;
	   
	/**
	 * Dispatched when the <code>duration</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.TimeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.osmf.events.TimeEvent")]
	 
	/**
	 * Dispatched when the media has completed playback.
	 * 
	 * @eventType org.osmf.events.TimeEvent.COMPLETE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	[Event(name="complete", type="org.osmf.events.TimeEvent")]
	 	 
	/**
	 * Dispatched when the <code>volume</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.AudioEvent.VOLUME_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	 
	[Event(name="volumeChange", type="org.osmf.events.AudioEvent")]   
	 
	/**
	 * Dispatched when the <code>muted</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.AudioEvent.MUTED_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	[Event(name="mutedChange", type="org.osmf.events.AudioEvent")] 
	 
	/**
	 * Dispatched when the <code>pan</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.AudioEvent.PAN_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	 
	[Event(name="panChange", type="org.osmf.events.AudioEvent")]

	/**
	 * Dispatched when the <code>playing</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PlayEvent.PLAYING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	 	 		
	[Event(name="playingChange", type="org.osmf.events.PlayEvent")]
	
	/**
	 * Dispatched when the <code>paused</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PlayEvent.PAUSED_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 		
	[Event(name="pausedChange", type="org.osmf.events.PlayEvent")]
	
	/**
	 * Dispatched when the <code>displayObject</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	 	 		
	[Event(name="displayObjectChange", type="org.osmf.events.DisplayObjectEvent")]
	
	/**
	 * Dispatched when the <code>mediaWidth</code> and/or <code>mediaHeight</code> property of the 
	 * media has changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.MEDIA_SIZE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */		
	[Event(name="mediaSizeChange", type="org.osmf.events.DisplayObjectEvent")]
	 
	/**
	 * Dispatched when the <code>seeking</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.SeekEvent.SEEKING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	
	[Event(name="seekingChange", type="org.osmf.events.SeekEvent")]
	 
	/**
	 * Dispatched when the MediaPlayer's state has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="mediaPlayerStateChange", type="org.osmf.events.MediaPlayerStateChangeEvent")]

    /**
	 * Dispatched when the <code>currentTime</code> property of the media has changed.
	 * This value is updated at the interval set by 
	 * the MediaPlayer's <code>currentTimeUpdateInterval</code> property.
	 *
	 * @eventType org.osmf.events.TimeEvent.CURRENT_TIME_CHANGE
	 **/
    [Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]  
    
	/**
	 * Dispatched when a dynamic stream switch change occurs.
	 * 
	 * @eventType org.osmf.events.DynamicStreamEvent.SWITCHING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="switchingChange",type="org.osmf.events.DynamicStreamEvent")]
	
	/**
	 * Dispatched when the number of dynamic streams has changed.
	 * 
	 * @eventType org.osmf.events.DynamicStreamEvent.NUM_DYNAMIC_STREAMS_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="numDynamicStreamsChange",type="org.osmf.events.DynamicStreamEvent")]
	
	/**
	 * Dispatched when the autoDynamicStreamSwitch property has changed.
	 * 
	 * @eventType org.osmf.events.DynamicStreamEvent.AUTO_SWITCH_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="autoSwitchChange",type="org.osmf.events.DynamicStreamEvent")]

	/**
	 * Dispatched when the <code>buffering</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferEvent.BUFFERING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bufferingChange", type="org.osmf.events.BufferEvent")]
	
	/**
	 * Dispatched when the <code>bufferTime</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferEvent.BUFFER_TIME_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bufferTimeChange", type="org.osmf.events.BufferEvent")]
	
	/**
	 * Dispatched when the value of bytesLoaded has changed.
	 *
	 * @eventType org.osmf.events.LoadEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bytesLoadedChange",type="org.osmf.events.LoadEvent")]

	/**
	 * Dispatched when the value of bytesTotal property has changed.
	 *
	 * @eventType org.osmf.events.LoadEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bytesTotalChange",type="org.osmf.events.LoadEvent")]

    /**
	 * Dispatched when the <code>canPlay</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */    
	[Event(name="canPlayChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>canBuffer</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.CAN_BUFFER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */    
	[Event(name="canBufferChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
	/**
	 * Dispatched when the <code>canPause</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.CAN_PAUSE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="canPauseChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>canSeek</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="canSeekChange",type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>isDynamicStream</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.IS_DYNAMIC_STREAM_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="isDynamicStreamChange",type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>temporal</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	[Event(name="temporalChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>hasAudio</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.HAS_AUDIO_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="hasAudioChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
			
	/**
	 * Dispatched when the <code>canLoad</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.CAN_LOAD_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="canLoadChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
				
	/**
	 * Dispatched when an error which impacts the operation of the media
	 * player occurs.
	 *
	 * @eventType org.osmf.events.MediaErrorEvent.MEDIA_ERROR
	 **/
	[Event(name="mediaError",type="org.osmf.events.MediaErrorEvent")]

	/**
	 * The MediaPlayer is the controller class used for interaction with all media types.
	 * <p>It is a high level class that shields the developer from the low level details of the
	 * media framework. The MediaPlayer class also provides some convenient features such as loop, 
	 * auto play and auto rewind.</p>
	 *  
	 * <p>The MediaPlayer can play back all media types supported by the Open Source Media Framework, 
	 * including media compositions.</p>
	 * 
	 * <p>The generic MediaPlayer is designed to be subclassed to enable creation of
	 * type-specific  players. 
	 * Such a subclass can expose a simpler API targeted to support
	 * its particular media type.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MediaPlayer extends EventDispatcher
	{
		/**
		 * Constructor.
		 * 
         * @param media Source MediaElement to be controlled by this MediaPlayer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function MediaPlayer(media:MediaElement=null)
		{
			super();
			
			_state = MediaPlayerState.UNINITIALIZED;
			this.media = media;
			
			_currentTimeTimer.addEventListener(TimerEvent.TIMER, onCurrentTimeTimer);			
			_bytesLoadedTimer.addEventListener(TimerEvent.TIMER, onBytesLoadedTimer);				
		}

		/**
		 * Source MediaElement controlled by this MediaPlayer.  Setting the media will attempt to load 
		 * media that is loadable, that isn't loading or loaded.  It will automatically unload media when
		 * the property changes to a new MediaElement or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set media(value:MediaElement):void
		{
			if (value != _media)
			{
				var traitType:String;
				if (_media != null)
				{											
					if (canLoad)
					{	 
						var loadTrait:LoadTrait = _media.getTrait(MediaTraitType.LOAD) as LoadTrait;
						if (loadTrait.loadState == LoadState.READY) // Do a courtesy unload
						{							
							loadTrait.unload();
						}
					}	
					setState(MediaPlayerState.UNINITIALIZED);
					
					if (_media) //sometimes _media is null here due to unload nulling the element.
					{
						_media.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
						_media.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
						_media.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);	
						for each (traitType in _media.traitTypes)
						{
							updateTraitListeners(traitType, false);
						}
					}								
				}	
				_media = value;
				if (_media != null)
				{
					_media.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);					
					_media.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
					_media.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);					

					// If the media cannnot be loaded, then the MediaPlayer's state
					// should represent the media as already ready.
					if (_media.hasTrait(MediaTraitType.LOAD) == false)
					{
						processReadyState();
					}

					for each (traitType  in _media.traitTypes)
					{
						updateTraitListeners(traitType, true);
					}
				}
			}
		}
		
        public function get media():MediaElement
        {
        	return _media;
        }
            
        /**
		 * Indicates whether media is returned to the beginning of playback after
         * playback of the media completes.
		 * <p>If <code>true</code>, the media displays the first frame.
		 * If <code>false</code>, it displays the last frame.
		 * The default is <code>false</code>.</p>
		 * <p>The <code>autoRewind</code> property is ignored if the <code>loop</code> property 
		 * is set to <code>true</code>.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set autoRewind(value:Boolean):void
		{
			_autoRewind = value;				
		}
		
        public function get autoRewind():Boolean
        {
        	return _autoRewind;
        }

        /**
		 * Indicates whether the MediaPlayer starts playing the media as soon as its
		 * load operation has successfully completed.
		 * The default is <code>true</code>.
		 * 
 		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;				
		}
		
        public function get autoPlay():Boolean
        {
        	return _autoPlay;
        }

         /**
         * Indicates whether the media should play again after playback has completed.
         * The <code>loop</code> property takes precedence over the <code>autoRewind</code> property,
         * so if <code>loop</code> is set to <code>true</code>, the <code>autoRewind</code> property
         * is ignored.
         * <p>The default is <code>false</code>.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
        public function get loop():Boolean
        {
        	return _loop;
        }

        /**
		 * Interval between the dispatch of change events for the current time
		 * in milliseconds. 
         * <p>The default is 250 milliseconds.
         * A non-positive value disables the dispatch of the change events.</p>
 		 * 
		 * @see org.osmf.events.#event:TimeEvent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set currentTimeUpdateInterval(value:Number):void
		{
			if (_currentTimeUpdateInterval != value)
			{
				_currentTimeUpdateInterval = value;
				if (isNaN(_currentTimeUpdateInterval) || _currentTimeUpdateInterval <= 0)
				{
					_currentTimeTimer.stop();	
				}
				else
				{				
					_currentTimeTimer.delay = _currentTimeUpdateInterval;		
					if (temporal)
					{
						_currentTimeTimer.start();
					}			
				}					
			}			
		}
		
        public function get currentTimeUpdateInterval():Number
        {
        	return _currentTimeUpdateInterval;
        }
        
        /**
		 * Interval between the dispatch of change events for the bytesLoaded property. 
         * <p>The default is 250 milliseconds.
         * A non-positive value disables the dispatch of the change events.</p>
		 * 
		 * @see org.osmf.events.#event:LoadEvent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
        public function set bytesLoadedUpdateInterval(value:Number):void
        {
        	if (_bytesLoadedUpdateInterval != value)
        	{
        		_bytesLoadedUpdateInterval = value;
        		
				if (isNaN(_bytesLoadedUpdateInterval) || _bytesLoadedUpdateInterval <= 0)
				{
					_bytesLoadedTimer.stop();	
				}
				else
				{				
					_bytesLoadedTimer.delay = _bytesLoadedUpdateInterval;		
					if (canLoad)
					{
						_bytesLoadedTimer.start();
					}			
				}					
        	}
        }
        
        public function get bytesLoadedUpdateInterval():Number
        {
        	return _bytesLoadedUpdateInterval;
        }

		/**
         *  The current state of the media.  See MediaPlayerState for available values.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion OSMF 1.0
         */      
        public function get state():String
        {
        	return _state;
        }               
 		
		/**
		 *  Indicates whether the media can be played.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get canPlay():Boolean
		{
			return _canPlay;
		}

		/**
		 *  Indicates whether the media can be paused.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get canPause():Boolean
		{
			return canPlay ? (getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).canPause : false;
		}
				
		/**
		 * Indicates whether the media is seekable.
		 * Seekable media can jump to a specified time.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get canSeek():Boolean
		{
			return _canSeek;
		}
		
		/**
		 * Indicates whether the media is temporal.
		 * Temporal media supports a duration and a currentTime within that duration.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get temporal():Boolean
		{
			return _temporal;
		}
		/**
		 *  Indicates whether the media has audio.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get hasAudio():Boolean
		{
			return _hasAudio;
		}
						
		/**
		 * Indicates whether the media consists of a dynamic stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get isDynamicStream():Boolean
		{
			return _isDynamicStream;
		}
				
		/**
		 *  Indicates whether the media can be loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get canLoad():Boolean
		{
			return _canLoad;
		}
		
		/**
		 * Indicates whether the media can buffer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get canBuffer():Boolean
		{
			return _canBuffer;
		}
				
		/**
		 * Volume of the media.
		 * Ranges from 0 (silent) to 1 (full volume). 
		 * <p>If the MediaElement doesn't have audio, then the volume will be set to
		 * this value as soon as the MediaElement has audio.</p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	    public function get volume():Number
	    {	
	    	return hasAudio ? AudioTrait(getTraitOrThrow(MediaTraitType.AUDIO)).volume : mediaPlayerVolume;	    		    
	    }		   
	    
	    public function set volume(value:Number):void
	    {
	    	var doDispatchEvent:Boolean = false;
	    	
	    	if (hasAudio)
	    	{
	    		(getTraitOrThrow(MediaTraitType.AUDIO) as AudioTrait).volume = value;
	    	}
	    	else if (value != mediaPlayerVolume)
	    	{
	    		doDispatchEvent = true;
	    	}

    		mediaPlayerVolume = value;
    		mediaPlayerVolumeSet = true;

     		if (doDispatchEvent)
    		{
    			dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE, false, false, false, value));
    		}
	    }
		
		/**
		 * Indicates whether the media is currently muted.
		 * <p>If the MediaElement doesn't have audio, then the muted state will be set to
		 * this value as soon as the MediaElement has audio.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */				
	    public function get muted():Boolean
	    {
	    	return hasAudio ? AudioTrait(getTraitOrThrow(MediaTraitType.AUDIO)).muted : mediaPlayerMuted;	    	   
	    }
	    
	    public function set muted(value:Boolean):void
	    {
	    	var doDispatchEvent:Boolean = false;
	    	
	    	if (hasAudio)
	    	{
	    		(getTraitOrThrow(MediaTraitType.AUDIO) as AudioTrait).muted = value;
	    	}
	    	else if (value != mediaPlayerMuted)
	    	{
	    		doDispatchEvent = true;
	    	}

    		mediaPlayerMuted = value;
    		mediaPlayerMutedSet = true;
    		
    		if (doDispatchEvent)
    		{
    			dispatchEvent(new AudioEvent(AudioEvent.MUTED_CHANGE, false, false, value));
    		}
	    }
	 	 
		/**
		 * Pan property of the media.
		 * Ranges from -1 (full pan left) to 1 (full pan right).
		 * <p>If the MediaElement doesn't have audio, then the pan property will be set to
		 * this value as soon as the MediaElement has audio.</p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	    public function get audioPan():Number
	    {
	    	return hasAudio ? AudioTrait(getTraitOrThrow(MediaTraitType.AUDIO)).pan : mediaPlayerAudioPan;	    		
	    }
	    
	    public function set audioPan(value:Number):void
	    {
	    	var doDispatchEvent:Boolean = false;
	    	
	    	if (hasAudio)
	    	{
	    		(getTraitOrThrow(MediaTraitType.AUDIO) as AudioTrait).pan = value;
	    	}
	    	else if (value != mediaPlayerAudioPan)
	    	{
	    		doDispatchEvent = true;
	    	}

    		mediaPlayerAudioPan = value;
    		mediaPlayerAudioPanSet = true;
    		
    		if (doDispatchEvent)
    		{
    			dispatchEvent(new AudioEvent(AudioEvent.PAN_CHANGE, false, false, false, NaN, value));
    		}
		}
			
		/**
		 * Indicates whether the media is currently paused.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get paused():Boolean
	    {
	    	return canPlay ? (getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).playState == PlayState.PAUSED : false;	    		    
	    }
	    
		/**
	    * Pauses the media, if it is not already paused.
	    * @throws IllegalOperationError if the media cannot be paused.
	    *  
	    *  @langversion 3.0
	    *  @playerversion Flash 10
	    *  @playerversion AIR 1.5
	    *  @productversion OSMF 1.0
	    */
	    public function pause():void
	    {
	    	(getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).pause();	    		
	    }
	
		/**
		 * Indicates whether the media is currently playing.
		 * <p>The MediaElement must be playable to support this property.</p>
		 * 
 		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */					
	    public function get playing():Boolean
	    {
	    	return canPlay ? (getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).playState == PlayState.PLAYING : false;	    		
	    }
	    
	    /**
	    * Plays the media, if it is not already playing.
	    * @throws IllegalOperationError if the media cannot be played.
	    *  
	    *  @langversion 3.0
	    *  @playerversion Flash 10
	    *  @playerversion AIR 1.5
	    *  @productversion OSMF 1.0
	    */
	    public function play():void
	    {
	    	(getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).play();	    	
	    }
		
		/**
		 * Indicates whether the media is currently seeking.
		 * 
 		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */			
	    public function get seeking():Boolean
	    {
	    	return canSeek ? (getTraitOrThrow(MediaTraitType.SEEK) as SeekTrait).seeking : false;
	    }
	    
	    /**
	     * Instructs the playhead to jump to the specified time.
	     * <p>If <code>time</code> is NaN or negative, does not attempt to seek.</p>
	     * @param time Time to seek to in seconds.
	     * @throws IllegalOperationError if the media cannot be seeked.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10
	     *  @playerversion AIR 1.5
	     *  @productversion OSMF 1.0
	     */	    
	    public function seek(time:Number):void
	    {
	    	(getTraitOrThrow(MediaTraitType.SEEK) as SeekTrait).seek(time);	    				
	    }
	    
		/**
		 * Indicates whether the media is capable of seeking to the
		 * specified time.
		 *  
		 * @param time Time to seek to in seconds.
		 * @return Returns <code>true</code> if the media can seek to the specified time.
		 * @throws IllegalOperationError if the media cannot be seeked.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
	    public function canSeekTo(time:Number):Boolean
	    {
	    	return (getTraitOrThrow(MediaTraitType.SEEK) as SeekTrait).canSeekTo(time);
	    }
	    
	    /**
	     * Immediately halts playback and returns the playhead to the beginning
	     * of the media file.
	     * 
	     * @throws IllegalOperationError If the media cannot be played (and therefore
	     * cannot be stopped).
	     **/
	    public function stop():void
	    {
	    	(getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).stop();

			if (autoRewind && canSeek)
			{
				addEventListener(SeekEvent.SEEK_END, onSeekEnd);
				function onSeekEnd(event:SeekEvent):void
				{
					removeEventListener(SeekEvent.SEEK_END, onSeekEnd);
					setState(MediaPlayerState.READY);
				}
				seek(0);									
			}
	    }
	
		/**
		 * Intrinsic width of the media, in pixels.
		 * The intrinsic width is the width of the media before any processing has been applied.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	    public function get mediaWidth():Number
	    {
	    	return _hasDisplayObject ? (getTraitOrThrow(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait).mediaWidth : 0;
	    }
		   
		/**
		 * Intrinsic height of the media, in pixels.
		 * The intrinsic height is the height of the media before any processing has been applied.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get mediaHeight():Number
	    {
	    	return _hasDisplayObject ? (getTraitOrThrow(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait).mediaHeight : 0;
	    }
	    
	    /**
		 * Indicates whether or not the media will automatically switch between
		 * dynamic streams.  If in manual mode the <code>switchDynamicStreamIndex</code>
		 * method can be used to manually switch to a specific stream.
		 * 
		 * <p>The default is true.</p>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 *		 
		 */
		public function get autoDynamicStreamSwitch():Boolean
		{
			return isDynamicStream ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).autoSwitch : true;
		}
		
		public function set autoDynamicStreamSwitch(value:Boolean):void
		{
			if (isDynamicStream)
			{
				(getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).autoSwitch = value;
			}
		}
		
		/**
		 * The index of the dynamic stream currently rendering.  Uses a zero-based index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get currentDynamicStreamIndex():int
		{
			return isDynamicStream ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).currentIndex : 0; 
		}

		/**
		 * The total number of dynamic stream indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get numDynamicStreams():int
		{
			return isDynamicStream ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).numDynamicStreams : 0; 
		}
		
		/**
		 * Gets the associated bitrate, in kilobytes for the specified dynamic stream index.
		 * 
		 * @throws RangeError If the specified dynamic stream index is less than zero or
		 * greater than the highest dynamic stream index available.
		 * @throws IllegalOperationError If the media is not a dynamic stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function getBitrateForDynamicStreamIndex(index:int):Number
		{
			return (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).getBitrateForIndex(index);
		}
		
		/**
		 * The maximum allowed dynamic stream index. This can be set at run-time to 
		 * provide a ceiling for the switching profile, for example, to keep from
		 * switching up to a higher quality stream when the current video is too small
		 * handle a higher quality stream.
		 * 
		 * @throws RangeError If the specified dynamic stream index is less than zero or
		 * greater than the highest dynamic stream index available.
		 * @throws IllegalOperationError If the media is not a dynamic stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get maxAllowedDynamicStreamIndex():int
		{
			return isDynamicStream ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).maxAllowedIndex : 0;
		}
		
		public function set maxAllowedDynamicStreamIndex(value:int):void
		{
			(getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).maxAllowedIndex = value; 
		}
		
		/**
		 * Indicates whether or not a dynamic stream switch is currently in progress.
		 * This property will return <code>true</code> while a switch has been 
		 * requested and the switch has not yet been acknowledged and no switch failure 
		 * has occurred.  Once the switch request has been acknowledged or a 
		 * failure occurs, the property will return <code>false</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get dynamicStreamSwitching():Boolean
		{
			return isDynamicStream ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).switching : false;
		}
		
		/**
		 * Switch to a specific dynamic stream index. To switch up, use the <code>currentDynamicStreamIndex</code>
		 * property, such as:<p>
		 * <code>
		 * mediaPlayer.switchDynamicStreamIndex(mediaPlayer.currentDynamicStreamIndex + 1);
		 * </code>
		 * </p>
		 * @throws RangeError If the specified dynamic stream index is less than zero or
		 * greater than <code>maxAllowedDynamicStreamIndex</code>.
		 * @throws IllegalOperationError If the media is not a dynamic stream, or if the dynamic
		 * stream is not in manual switch mode.
		 * 
		 * @see maxAllowedDynamicStreamIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function switchDynamicStreamIndex(streamIndex:int):void
		{
			(getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).switchTo(streamIndex);
		}	    
	
		/**
		 * DisplayObject for the media.
		 * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion OSMF 1.0
         */
	    public function get displayObject():DisplayObject
	    {
	    	return _hasDisplayObject ? (getTraitOrThrow(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait).displayObject : null;	
	    }
	
		 /**
		 * Duration of the media's playback, in seconds.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	    public function get duration():Number
	    {
	    	return temporal ? (getTraitOrThrow(MediaTraitType.TIME) as TimeTrait).duration : 0;	    	
	    }
	  	  
    	/**
		 * Current time of the playhead in seconds.
		 *   
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		    
	    public function get currentTime():Number
	    {
	    	return temporal ? (getTraitOrThrow(MediaTraitType.TIME) as TimeTrait).currentTime : 0;
	    }
	    	    
	    /**
		 * Indicates whether the media is currently buffering.
		 * 
		 * <p>The default is <code>false</code>.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get buffering():Boolean
		{
			return canBuffer ? (getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).buffering : false;	    	
		}
		
		/**
		 * Length of the content currently in the media's
		 * buffer, in seconds. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get bufferLength():Number
		{
			return canBuffer ? (getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).bufferLength : 0;	    	
		}
		
		/**
		 * Desired length of the media's buffer, in seconds.
		 * 
		 * <p>If the passed value is non numerical or negative, it
		 * is forced to zero.</p>
		 * 
		 * <p>The default is zero.</p> 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get bufferTime():Number
		{
			return canBuffer ? (getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).bufferTime : 0;		    	
		}
		
		public function set bufferTime(value:Number):void
		{
			if (canBuffer)
			{
				(getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).bufferTime = value;
			}	    	
		}
		
		/**
		 * The number of bytes of the media that have been loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get bytesLoaded():Number
		{
			var bytes:Number = 0;
			
			if (canLoad)
			{
				bytes = (getTraitOrThrow(MediaTraitType.LOAD) as LoadTrait).bytesLoaded;
				if (isNaN(bytes))
				{
					bytes = 0;
				}
			}
			
			return bytes;
		}
		
		/**
		 * The total number of bytes of the media that will be loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get bytesTotal():Number
		{
			var bytes:Number = 0;
			
			if (canLoad)
			{
				bytes = (getTraitOrThrow(MediaTraitType.LOAD) as LoadTrait).bytesTotal;
				if (isNaN(bytes))
				{
					bytes = 0;
				}
			}
			
			return bytes;
		}

		// Internals
		//
	    
	    private function getTraitOrThrow(traitType:String):MediaTraitBase
	    {
	    	if (!_media || !_media.hasTrait(traitType))
	    	{
	    		var error:String = OSMFStrings.getString(OSMFStrings.TRAIT_NOT_SUPPORTED);
	    		var traitName:String = traitType.replace("[class ", "");
	    		traitName = traitName.replace("]", "").toLowerCase();	
	    				
	    		error = error.replace('*trait*', traitName);
	    			    		
	    		throw new IllegalOperationError(error);		    		
	    	}
	    	return _media.getTrait(traitType);
	    }

	    private function onMediaError(event:MediaErrorEvent):void
	    {
	    	// Note that all MediaErrors are treated as playback errors.  If
	    	// necessary, we could introduce a distinction between errors and
	    	// warnings (non-fatal errors).  But the current assumption is
	    	// that we don't need to do so (no compelling use cases exist).
	    	setState(MediaPlayerState.PLAYBACK_ERROR);
	    	
	    	dispatchEvent(event.clone());
	    }
	        
		private function onTraitAdd(event:MediaElementEvent):void
		{				
			updateTraitListeners(event.traitType, true);				
		}
		
		private function onTraitRemove(event:MediaElementEvent):void
		{
			updateTraitListeners(event.traitType, false);						
		}
		
		private function updateTraitListeners(traitType:String, add:Boolean):void
		{		
			var eventType:String;	
			switch (traitType)
			{
				case MediaTraitType.TIME:									
					changeListeners(add, _media, traitType, TimeEvent.DURATION_CHANGE, [redispatchEvent]);							
					changeListeners(add, _media, traitType, TimeEvent.COMPLETE, [redispatchEvent, onComplete] );								
					if (add && _currentTimeUpdateInterval > 0 && !isNaN(_currentTimeUpdateInterval) )
					{
						_currentTimeTimer.start();
					}
					else
					{
						_currentTimeTimer.stop();					
					}
					_temporal = add;
					eventType = MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE;		
					break;
				case MediaTraitType.PLAY:						
					changeListeners(add, _media, traitType, PlayEvent.PLAY_STATE_CHANGE, [redispatchEvent,onPlayStateChange] );			
					_canPlay = add;							
					if (autoPlay && canPlay && !playing)
					{
						play();
					}
					eventType = MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE;												
					break;	
				case MediaTraitType.AUDIO:					
					changeListeners(add, _media, traitType, AudioEvent.VOLUME_CHANGE, [redispatchEvent]);		
					changeListeners(add, _media, traitType, AudioEvent.MUTED_CHANGE, [redispatchEvent]);
					changeListeners(add, _media, traitType, AudioEvent.PAN_CHANGE, [redispatchEvent]);
					_hasAudio = add;
					if (hasAudio)
					{
						// When AudioTrait is added, we should tell it to reflect any
						// explicitly-specified MediaPlayer-level audio properties.
						// Note that we don't do so if the current MediaPlayer-level
						// audio properties are implicit (i.e. not set by the client).
						if (mediaPlayerVolumeSet)
						{
							volume = mediaPlayerVolume;
						}
						if (mediaPlayerMutedSet)
						{
							muted = mediaPlayerMuted;
						}
						if (mediaPlayerAudioPanSet)
						{
							audioPan = mediaPlayerAudioPan;
						}
					}
					eventType = MediaPlayerCapabilityChangeEvent.HAS_AUDIO_CHANGE;		
					break;
				case MediaTraitType.SEEK:
					changeListeners(add, _media, traitType, SeekEvent.SEEK_BEGIN, [redispatchEvent, onSeeking]);
					changeListeners(add, _media, traitType, SeekEvent.SEEK_END, [redispatchEvent, onSeeking]);
					_canSeek = add;					
					eventType = MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE;							
					break;
				case MediaTraitType.DYNAMIC_STREAM:	
					changeListeners(add, _media, traitType, DynamicStreamEvent.SWITCHING_CHANGE, [redispatchEvent]);
					changeListeners(add, _media, traitType, DynamicStreamEvent.AUTO_SWITCH_CHANGE, [redispatchEvent]);
					changeListeners(add, _media, traitType, DynamicStreamEvent.NUM_DYNAMIC_STREAMS_CHANGE, [redispatchEvent]);
					_isDynamicStream = add;						
					eventType = MediaPlayerCapabilityChangeEvent.IS_DYNAMIC_STREAM_CHANGE;					
					break;						
				case MediaTraitType.DISPLAY_OBJECT:					
					changeListeners(add, _media, traitType, DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, [redispatchEvent]);											
					changeListeners(add, _media, traitType, DisplayObjectEvent.MEDIA_SIZE_CHANGE, [redispatchEvent]);
					_hasDisplayObject = add;
					if (add)
					{
						var displayObject:DisplayObject = DisplayObjectTrait(_media.getTrait(MediaTraitType.DISPLAY_OBJECT)).displayObject;
						if (displayObject != null)
						{
							dispatchEvent(new DisplayObjectEvent(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, false, false, null, displayObject));
						}
					}				
					break;	
				case MediaTraitType.LOAD:					
					changeListeners(add, _media, traitType, LoadEvent.LOAD_STATE_CHANGE, [redispatchEvent, onLoadState]);
					changeListeners(add, _media, traitType, LoadEvent.BYTES_TOTAL_CHANGE, [redispatchEvent]);					
					_canLoad = add;		
					if (add)
					{
						var loadState:String = (_media.getTrait(traitType) as LoadTrait).loadState;
						if (loadState != LoadState.READY && 
							loadState != LoadState.LOADING)
						{
							load();
						}
						else if (autoPlay && canPlay && !playing)
						{
							play();	
						}
						
						if (_bytesLoadedUpdateInterval > 0 && !isNaN(_bytesLoadedUpdateInterval))
						{
							_bytesLoadedTimer.start();
						}
						else
						{
							_bytesLoadedTimer.stop();					
						}			
					}						
					eventType = MediaPlayerCapabilityChangeEvent.CAN_LOAD_CHANGE;				
					break;		
				case MediaTraitType.BUFFER:
					changeListeners(add, _media, traitType, BufferEvent.BUFFERING_CHANGE, [redispatchEvent, onBuffering]);	
					changeListeners(add, _media, traitType, BufferEvent.BUFFER_TIME_CHANGE, [redispatchEvent]);						
					_canBuffer = add;
					eventType = MediaPlayerCapabilityChangeEvent.CAN_BUFFER_CHANGE;									
					break;						
			}					 
			if (eventType != null)
			{
				dispatchEvent
					( new MediaPlayerCapabilityChangeEvent
						( eventType
						, false
						, false
						, add
						)
					);	
			}	
		}
				
		// Add any number of listeners to the trait, using the given event name.
		private function changeListeners(add:Boolean, media:MediaElement, traitType:String, event:String, listeners:Array):void
		{
			for each (var item:Function in listeners)
			{
				if (add)
				{
					// Make sure that the MediaPlayer gets to process the event
					// before it gets redispatched to the client.  This will
					// ensure that we present a consistent state to the client.
					var priority:int = item == redispatchEvent ? 0 : 1;
					
					media.getTrait(traitType).addEventListener(event, item, false, priority);
				}
				else
				{			
					media.getTrait(traitType).removeEventListener(event, item);
				}
			}
		}
		
		// Event Listeners will redispatch all of the ChangeEvents that correspond to trait 
		// properties.
		private function redispatchEvent(event:Event):void
		{
			dispatchEvent(event.clone());			
		}	
				
		private function onSeeking(event:SeekEvent):void
		{			
			if (event.type == SeekEvent.SEEK_BEGIN)
			{				
				setState(MediaPlayerState.BUFFERING);				
			}
			else if (canPlay && playing)
			{
				setState(MediaPlayerState.PLAYING);
			}
			else if (canPlay && paused)
			{
				setState(MediaPlayerState.PAUSED);
			}	
			else if (canBuffer && buffering)
			{
				setState(MediaPlayerState.BUFFERING);
			}					
			else
			{
				setState(MediaPlayerState.READY);
			}				
		}
				
		private function onPlayStateChange(event:PlayEvent):void
		{			
			if (event.playState == PlayState.PLAYING)
			{				
				setState(MediaPlayerState.PLAYING);				
			}
			else if (event.playState == PlayState.PAUSED)
			{
				setState(MediaPlayerState.PAUSED);				
			}
			else // STOPPED
			{
				setState(MediaPlayerState.READY);
			}
		}
		
		private function onLoadState(event:LoadEvent):void
		{		
			if (event.loadState == LoadState.READY)
			{
				processReadyState();
			}
			else if (event.loadState == LoadState.UNINITIALIZED)
			{				
				setState(MediaPlayerState.UNINITIALIZED);
			}	
			else if (event.loadState == LoadState.LOAD_ERROR)
			{
				setState(MediaPlayerState.PLAYBACK_ERROR);
			}	
			else if (event.loadState == LoadState.LOADING)
			{				
				setState(MediaPlayerState.LOADING);
			}			
		}
		
		private function processReadyState():void
		{
			setState(MediaPlayerState.READY);
			if (autoPlay && canPlay && !playing)
			{
				play();
			}
		}
		
		private function onComplete(event:TimeEvent):void
		{
			if (loop && canSeek && canPlay)
			{	
				addEventListener(SeekEvent.SEEK_END, onSeekEnd);
				function onSeekEnd(event:SeekEvent):void
				{
					removeEventListener(SeekEvent.SEEK_END, onSeekEnd);
					play();	
				}
				seek(0); // If we don't wait for the seek-end, everything breaks for looping.									
			}
			else if (!loop && canPlay)
			{
				stop();
			}
			else
			{
				setState(MediaPlayerState.READY);
			}
		}			
								
		private function onCurrentTimeTimer(event:TimerEvent):void
		{
			if (temporal && 
				currentTime != lastCurrentTime && 
			 	(!canSeek || !seeking) )
			{				
				lastCurrentTime = currentTime;
				dispatchEvent(new TimeEvent(TimeEvent.CURRENT_TIME_CHANGE, false, false, currentTime));
			}
		}	
		
		private function onBytesLoadedTimer(event:TimerEvent):void
		{
			if (canLoad && (bytesLoaded != lastBytesLoaded))
			{
				var bytesLoadedEvent:LoadEvent 
					= new LoadEvent
						( LoadEvent.BYTES_LOADED_CHANGE
						, false
						, false
						, null
						, bytesLoaded
						);
						 	
				lastBytesLoaded = bytesLoaded;
				
				dispatchEvent(bytesLoadedEvent);
			}
		}
		
		private function onBuffering(event:BufferEvent):void
		{
			if (event.buffering)
			{
				setState(MediaPlayerState.BUFFERING);
			}
			else
			{
				if (canPlay && playing)
				{
					setState(MediaPlayerState.PLAYING);					
				}
				else if (canPlay && paused)
				{
					setState(MediaPlayerState.PAUSED);
				}
				else
				{
					setState(MediaPlayerState.READY);	
				}				
			}
		}
		
		private function setState(newState:String):void
		{
			if (_state != newState)
			{
				_state = newState;
				dispatchEvent
					( new MediaPlayerStateChangeEvent
						( MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE
						, false
						, false
						, _state
						)
					);
			}
		}
		
		private function load():void
		{
			try
			{
				(_media.getTrait(MediaTraitType.LOAD) as LoadTrait).load();
			}
			catch (error:Error)
			{
				setState(MediaPlayerState.PLAYBACK_ERROR);
			}
		}
					
	    private static const DEFAULT_UPDATE_INTERVAL:Number = 250;
	      
	    private var lastCurrentTime:Number = 0;	
	    private var lastBytesLoaded:Number = NaN;	
		private var _autoPlay:Boolean = true;
		private var _autoRewind:Boolean = true;
		private var _loop:Boolean = false;		
		private var _currentTimeUpdateInterval:Number = DEFAULT_UPDATE_INTERVAL;
		private var _currentTimeTimer:Timer  = new Timer(DEFAULT_UPDATE_INTERVAL);
		private var _media:MediaElement;
		private var _state:String; // MediaPlayerState
		private var _bytesLoadedUpdateInterval:Number = DEFAULT_UPDATE_INTERVAL;
		private var _bytesLoadedTimer:Timer = new Timer(DEFAULT_UPDATE_INTERVAL);
		
		// Properties of the MediaPlayer, as opposed to properties that apply
		// to a specific MediaElement.  We use xxxSet Booleans to distinguish
		// between explicit properties and implicit properties.
		private var mediaPlayerVolume:Number = 1;
		private var mediaPlayerVolumeSet:Boolean = false;
		private var mediaPlayerMuted:Boolean = false;
		private var mediaPlayerMutedSet:Boolean = false;
		private var mediaPlayerAudioPan:Number = 0;
		private var mediaPlayerAudioPanSet:Boolean = false;
		
		private var _canPlay:Boolean;
		private var _canSeek:Boolean;
		private var _temporal:Boolean;
		private var _hasAudio:Boolean;
		private var _hasDisplayObject:Boolean;
		private var _canLoad:Boolean;
		private var _canBuffer:Boolean;
		private var _isDynamicStream:Boolean;
	}
}
