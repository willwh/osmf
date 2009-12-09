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
	 * Dispatched when the playhead reaches the duration for playable media.
	 * 
	 * @eventType org.osmf.events.TimeEvent.DURATION_REACHED
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	[Event(name="durationReached", type="org.osmf.events.TimeEvent")]
	 	 
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
	 * Dispatched when the load state has changed.
	 * @see LoadState
	 *
	 * @eventType org.osmf.events.LoadEvent.LOAD_STATE_CHANGE
	 **/
	[Event(name="loadStateChange", type="org.osmf.events.LoadEvent")]

	/**
	 * Dispatched when the <code>playing</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PlayingChangeEvent.PLAYING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	 	 		
	[Event(name="playingChange", type="org.osmf.events.PlayingChangeEvent")]
	
	/**
	 * Dispatched when the <code>paused</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangeEvent.PAUSED_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 		
	[Event(name="pausedChange", type="org.osmf.events.PausedChangeEvent")]
	
	/**
	 * Dispatched when the <code>view</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 	 	 		
	[Event(name="viewChange", type="org.osmf.events.ViewEvent")]
	
	/**
	 * Dispatched when the <code>width</code> and/or <code>height</code> property of the 
	 * media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */		
	[Event(name="dimensionChange", type="org.osmf.events.DimensionEvent")]
	 
	/**
	 * Dispatched when the <code>seeking</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.SeekingChangeEvent.SEEKING_CHANGE
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
	 * Dispatched when the <code>currentTime</code> property of the MediaPlayer has changed.
	 * This value is updated at the interval set by 
	 * the MediaPlayer's <code>currentTimeUpdateInterval</code> property.
	 *
	 * @eventType org.osmf.events.TimeEvent.CURRENT_TIME_CHANGE
	 **/
    [Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]  
    
	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.SWITCHING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchEvent")]
	
	/**
	 * Dispatched when the number of indicies or associated bitrates have changed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.INDICES_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indicesChange",type="org.osmf.events.SwitchEvent")]

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
	 * Dispatched when the data is received as a download operation progresses.
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
	 * Dispatched when the <code>playable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */    
	[Event(name="playableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>bufferable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */    
	[Event(name="bufferableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
	/**
	 * Dispatched when the <code>Pausable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.Pausable_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="pausableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>seekable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="seekableChange",type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>switchable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="switchableChange",type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
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
	 * Dispatched when the <code>audible</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="audibleChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>viewable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="viewableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>spatial</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="spatialChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>loadable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="loadableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
	/**
	 * Dispatched when the <code>downloadable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.DOWNLOADABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="downloadableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
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
         * @param element Source MediaElement to be controlled by this MediaPlayer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function MediaPlayer(element:MediaElement=null)
		{
			super();
			
			_state = MediaPlayerState.UNINITIALIZED;
			this.element = element;			
			_currentTimeTimer.addEventListener(TimerEvent.TIMER, onCurrentTimeTimer);			
			_bytesLoadedTimer.addEventListener(TimerEvent.TIMER, onBytesLoadedTimer);				
		}

		/**
		 * Source MediaElement controlled by this MediaPlayer.  Setting the element will attempt to load 
		 * media that is loadable, that isn't loading or loaded.  It will automatically unload media when
		 * the element changes to a new MediaElement or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set element(value:MediaElement):void
		{
			if (value != _element)
			{
				var traitType:String;
				if (_element)
				{											
					if (loadable)
					{	 
						var loadTrait:LoadTrait = _element.getTrait(MediaTraitType.LOAD) as LoadTrait;
						if (loadTrait.loadState == LoadState.READY) // Do a courtesy unload
						{							
							loadTrait.unload();
						}
					}	
					setState(MediaPlayerState.UNINITIALIZED);
					
					if (_element) //sometimes _element is null here due to unload nulling the element.
					{
						_element.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
						_element.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
						_element.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);	
						for each (traitType in _element.traitTypes)
						{
							updateTraitListeners(traitType, false);
						}
					}								
				}	
				_element = value;
				if (_element)
				{
					_element.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);					
					_element.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
					_element.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);					

					// If the media is not loadable, then the MediaPlayer's state
					// should represent the media as already ready.
					if (_element.hasTrait(MediaTraitType.LOAD) == false)
					{
						processReadyState();
					}

					for each (traitType  in _element.traitTypes)
					{
						updateTraitListeners(traitType, true);
					}
				}
			}
		}
		
        public function get element():MediaElement
        {
        	return _element;
        }
            
        /**
		 * Indicates which frame of a video the MediaPlayer displays after playback completes.
		 * <p>If <code>true</code>, the media displays the first frame.
		 * If <code>false</code>, it displays the last frame.
		 * The default is <code>false</code>.</p>
		 * <p>The <code>autoRewind</code> property is ignored if the <code>loop</code> property 
		 * is set to <code>true</code>.</p>
		 * 
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
		 * <p>The MediaElement must be playable to support this property.</p>
		 * 
         * @see org.osmf.traits.IPlayable
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
         * <p>The MediaElement must be temporal to support this property.</p>
		 * 
		 * @see org.osmf.events.#event:TimeEvent
         * @see org.osmf.traits.ITemporal
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
         * <p>The MediaElement must be loadable to support this property.</p>
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
					if (loadable)
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
 		
		// Trait availability
		
		/**
		 *  Indicates whether the media is playable.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get playable():Boolean
		{
			return _playable;
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
			return playable ? (getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).canPause : false;
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
		public function get seekable():Boolean
		{
			return _seekable;
		}
		
		/**
		 * Indicates whether the media is temporal.
		 * Temporal media supports a duration and a currentT tme within that duration.
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
		 *  Indicates whether the media is audible.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get audible():Boolean
		{
			return _audible;
		}
		
		/**
		 * Indicates whether the media is viewable.
		 * Viewable media is exposed by a DisplayObject.
		 * @see flash.display.DisplayObject
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get viewable():Boolean
		{
			return _viewable;
		}
				
		/**
		 * Indicates whether the media is switchable.
		 * Wwitchable exposes the ability to autoswitch or manually switch
		 * between multiple bitrate streams.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get switchable():Boolean
		{
			return _switchable;
		}
				
		/**
		 *  Indicates whether the media is loadable.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get loadable():Boolean
		{
			return _loadable;
		}
		
		/**
		 * Indicates whether the media is capable of buffering.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get bufferable():Boolean
		{
			return _bufferable;
		}
				
		// Trait Based properties
		
		/**
		 * Volume of the media.
		 * Ranges from 0 (silent) to 1 (full volume). 
		 * <p>If the MediaElement is not audible, then the volume will be set to
		 * this value as soon as the MediaElement becomes audible.</p>
		 * 
         * @see org.osmf.traits.IAudible
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	    public function get volume():Number
	    {	
	    	return audible ? AudioTrait(getTraitOrThrow(MediaTraitType.AUDIO)).volume : mediaPlayerVolume;	    		    
	    }		   
	    
	    public function set volume(value:Number):void
	    {
	    	var doDispatchEvent:Boolean = false;
	    	
	    	if (audible)
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
		 * <p>If the MediaElement is not audible, then the muted state will be set to
		 * this value as soon as the MediaElement becomes audible.</p>
		 * 
         * @see org.osmf.traits.IAudible
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */				
	    public function get muted():Boolean
	    {
	    	return audible ? AudioTrait(getTraitOrThrow(MediaTraitType.AUDIO)).muted : mediaPlayerMuted;	    	   
	    }
	    
	    public function set muted(value:Boolean):void
	    {
	    	var doDispatchEvent:Boolean = false;
	    	
	    	if (audible)
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
		 * <p>If the MediaElement is not audible, then the pan property will be set to
		 * this value as soon as the MediaElement becomes audible.</p>
		 * 
         * @see org.osmf.traits.IAudible
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */					
		
	    public function get pan():Number
	    {
	    	return audible ? AudioTrait(getTraitOrThrow(MediaTraitType.AUDIO)).pan : mediaPlayerPan;	    		
	    }
	    
	    public function set pan(value:Number):void
	    {
	    	var doDispatchEvent:Boolean = false;
	    	
	    	if (audible)
	    	{
	    		(getTraitOrThrow(MediaTraitType.AUDIO) as AudioTrait).pan = value;
	    	}
	    	else if (value != mediaPlayerPan)
	    	{
	    		doDispatchEvent = true;
	    	}

    		mediaPlayerPan = value;
    		mediaPlayerPanSet = true;
    		
    		if (doDispatchEvent)
    		{
    			dispatchEvent(new AudioEvent(AudioEvent.PAN_CHANGE, false, false, false, NaN, value));
    		}
		}
			
		/**
		 * Indicates whether the media is currently paused.
		 * <p>The MediaElement must be pausable to support this property.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get paused():Boolean
	    {
	    	return playable ? (getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).playState == PlayState.PAUSED : false;	    		    
	    }
	    
		/**
	    * Pauses the media, if it is not already paused.
	    * @throws IllegalOperationError if capability isn't supported
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
         * @see org.osmf.traits.IPlayable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */					
	    public function get playing():Boolean
	    {
	    	return playable ? (getTraitOrThrow(MediaTraitType.PLAY) as PlayTrait).playState == PlayState.PLAYING : false;	    		
	    }
	    
	    /**
	    * Plays the media, if it is not already playing.
	    * @throws IllegalOperationError if capability isn't supported
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
		
	    // ISeekable
		
		/**
		 * Indicates whether the media is currently seeking.
		 * <p>The MediaElement must be seekable to support this property.</p>
		 * 
         * @see org.osmf.traits.ISeekable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */			
	    public function get seeking():Boolean
	    {
	    	return seekable ? (getTraitOrThrow(MediaTraitType.SEEK) as SeekTrait).seeking : false;
	    }
	    
	    /**
	     * Instructs the playhead to jump to the specified time.
	     * <p>If <code>time</code> is NaN or negative, does not attempt to seek.</p>
	     * @param time Time to seek to in seconds.
	     * @throws IllegalOperationError if capability isn't supported
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
		 * <p>This method is not bound to the trait's current <code>seeking</code> state. It can
         * return <code>true</code> while the media is seeking, even though a call to <code>seek()</code>
         * will fail if a previous seek is still in progress.</p>
		 * 
		 * @param time Time to seek to in seconds.
		 * @return Returns <code>true</code> if the media can seek to the specified time.
		 * @throws IllegalOperationError if capability isn't supported
		 * 
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
	     * @throws IllegalOperationError If either the pause or seek capability
	     * isn't supported.
	     **/
	    public function stop():void
	    {
	    	pause();
	    	seek(0);
	    }
	
	    // ISpatial
				
		/**
		 * Intrinsic width of the media, in pixels.
		 * The intrinsic width is the width of the media before any processing has been applied.
		 * <p>The MediaElement must be spatial to support this property.</p>
		 * 
         * @see org.osmf.traits.ISpatial
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	    public function get width():int
	    {
	    	return viewable ? (getTraitOrThrow(MediaTraitType.VIEW) as ViewTrait).mediaWidth : 0;
	    }
		   
		/**
		 * Intrinsic height of the media, in pixels.
		 * The intrinsic height is the height of the media before any processing has been applied.
		 * <p>The MediaElement must be spatial to support this property.</p>
		 * 
         * @see org.osmf.traits.ISpatial
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get height():int
	    {
	    	return viewable ? (getTraitOrThrow(MediaTraitType.VIEW) as ViewTrait).mediaHeight : 0;
	    }
	    
	    // ISwitchable
	    
	    /**
		 * Defines whether or not the ISwitchable trait should be in manual 
		 * or auto-switch mode. If in manual mode the <code>switchTo</code>
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
		public function get autoSwitch():Boolean
		{
			return switchable ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).autoSwitch : true;
		}
		
		public function set autoSwitch(value:Boolean):void
		{
			if (switchable)
			{
				(getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).autoSwitch = value;
			}
		}
		
		/**
		 * The index of the stream currently rendering. Uses a zero-based index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get currentStreamIndex():int
		{
			return switchable ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).currentIndex : 0; 
		}
		
		/**
		 * Gets the associated bitrate, in kilobytes for the specified index.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function getBitrateForIndex(index:int):Number
		{
			return (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).getBitrateForIndex(index);
		}
		
		/**
		 * The maximum available index. This can be set at run-time to 
		 * provide a ceiling for your switching profile. For example,
		 * to keep from switching up to a higher quality stream when 
		 * the current video is too small to realize the added value
		 * of a higher quality stream.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get maxStreamIndex():int
		{
			return switchable ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).maxIndex : 0;
		}
		
		public function set maxStreamIndex(value:int):void
		{
			(getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).maxIndex = value; 
		}
		
		/**
		 * Indicates whether or not a switch is currently in progress.
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
		public function get switchUnderway():Boolean
		{
			return switchable ? (getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).switchUnderway : false;
		}
		
		/**
		 * Switch to a specific index. To switch up, use the <code>currentIndex</code>
		 * property, such as:<p>
		 * <code>
		 * obj.switchTo(obj.currentStreamIndex + 1);
		 * </code>
		 * </p>
		 * @throws RangeError If the specified index is less than zero or
		 * greater than <code>maxIndex</code>.
		 * @throws IllegalOperationError If the stream is not in manual switch mode.
		 * 
		 * @see maxIndex
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function switchTo(streamIndex:int):void
		{
			(getTraitOrThrow(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait).switchTo(streamIndex);
		}	    
	
	    // IViewable
	    
		/**
		 * View property of the media.
		 * This is the DisplayObject that represents the media.
		 * <p>The MediaElement must be viewable to support this property.</p>
		 * 
         * @see org.osmf.traits.IViewable
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion OSMF 1.0
         */
	    public function get view():DisplayObject
	    {
	    	return viewable ? (getTraitOrThrow(MediaTraitType.VIEW) as ViewTrait).view : null;	
	    }
	
        // ITemporal

		 /**
		 * Duration of the media's playback, in seconds.
		 * <p>The MediaElement must be temporal to support this property.</p>
		 * 
         * @see org.osmf.traits.ITemporal
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
		 * Must not exceed the duration.
		 * <p>The MediaElement must be temporal to support this property.</p>
		 * 
         * @see org.osmf.traits.ITemporal
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
			return bufferable ? (getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).buffering : false;	    	
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
			return bufferable ? (getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).bufferLength : 0;	    	
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
			return bufferable ? (getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).bufferTime : 0;		    	
		}
		
		public function set bufferTime(value:Number):void
		{
			if (bufferable)
			{
				(getTraitOrThrow(MediaTraitType.BUFFER) as BufferTrait).bufferTime = value;
			}	    	
		}
		
		/**
		 * The number of bytes of the media that has been downloaded. When the underlying trait is absent, 0 is returned.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get bytesLoaded():Number
		{
			return loadable ? (getTraitOrThrow(MediaTraitType.LOAD) as LoadTrait).bytesLoaded : 0;
		}
		
		/**
		 * The total number of bytes of the media that will be downloaded. When the underlying trait is absent, 0 is returned.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get bytesTotal():Number
		{
			return loadable ? (getTraitOrThrow(MediaTraitType.LOAD) as LoadTrait).bytesTotal : 0;
		}

		// Internals
		//
	    
	    private function getTraitOrThrow(traitType:String):MediaTraitBase
	    {
	    	if (!_element || !_element.hasTrait(traitType))
	    	{
	    		var error:String = OSMFStrings.getString(OSMFStrings.TRAIT_NOT_SUPPORTED);
	    		var traitName:String = traitType.replace("[class ", "");
	    		traitName = traitName.replace("]", "").toLowerCase();	
	    				
	    		error = error.replace('*trait*', traitName);
	    			    		
	    		throw new IllegalOperationError(error);		    		
	    	}
	    	return _element.getTrait(traitType);
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
					changeListeners(add, _element, traitType, TimeEvent.DURATION_CHANGE, [redispatchEvent]);							
					changeListeners(add, _element, traitType, TimeEvent.DURATION_REACHED, [redispatchEvent, onDurationReached] );								
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
					changeListeners(add, _element, traitType, PlayEvent.PLAY_STATE_CHANGE, [redispatchEvent,onPlayStateChange] );			
					_playable = add;							
					if (autoPlay && playable && !playing)
					{
						play();
					}
					eventType = MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE;												
					break;	
				case MediaTraitType.AUDIO:					
					changeListeners(add, _element, traitType, AudioEvent.VOLUME_CHANGE, [redispatchEvent]);		
					changeListeners(add, _element, traitType, AudioEvent.MUTED_CHANGE, [redispatchEvent]);
					changeListeners(add, _element, traitType, AudioEvent.PAN_CHANGE, [redispatchEvent]);
					_audible = add;
					if (audible)
					{
						// When AudioTrait is added, we should tell it to reflect any
						// explicitly-specified MediaPlayer-level audible properties.
						// Note that we don't do so if the current MediaPlayer-level
						// audible properties are implicit (i.e. not set by the client).
						if (mediaPlayerVolumeSet)
						{
							volume = mediaPlayerVolume;
						}
						if (mediaPlayerMutedSet)
						{
							muted = mediaPlayerMuted;
						}
						if (mediaPlayerPanSet)
						{
							pan = mediaPlayerPan;
						}
					}
					eventType = MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE;		
					break;
				case MediaTraitType.SEEK:														
					changeListeners(add, _element, traitType, SeekEvent.SEEK_BEGIN, [redispatchEvent, onSeeking]);
					changeListeners(add, _element, traitType, SeekEvent.SEEK_END, [redispatchEvent, onSeeking]);
					_seekable = add;					
					eventType = MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE;							
					break;
				case MediaTraitType.DYNAMIC_STREAM:	
					changeListeners(add, _element, traitType, SwitchEvent.SWITCHING_CHANGE, [redispatchEvent]);								
					_switchable = add;						
					eventType = MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE;					
					break;						
				case MediaTraitType.VIEW:					
					changeListeners(add, _element, traitType, ViewEvent.VIEW_CHANGE, [redispatchEvent]);											
					changeListeners(add, _element, traitType, ViewEvent.DIMENSION_CHANGE, [redispatchEvent]);
					_viewable = add;						
					eventType = MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE;					
					break;	
				case MediaTraitType.LOAD:					
					changeListeners(add, _element, traitType, LoadEvent.LOAD_STATE_CHANGE, [redispatchEvent, onLoadState]);
					changeListeners(add, _element, traitType, LoadEvent.BYTES_TOTAL_CHANGE, [redispatchEvent]);					
					_loadable = add;		
					if (add)
					{
						var loadState:String = (_element.getTrait(traitType) as LoadTrait).loadState;
						if (loadState != LoadState.READY && 
							loadState != LoadState.LOADING)
						{
							load();
						}
						else if (autoPlay && playable && !playing)
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
					eventType = MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE;				
					break;		
				case MediaTraitType.BUFFER:
					changeListeners(add, _element, traitType, BufferEvent.BUFFERING_CHANGE, [redispatchEvent, onBuffering]);	
					changeListeners(add, _element, traitType, BufferEvent.BUFFER_TIME_CHANGE, [redispatchEvent]);						
					_bufferable = add;
					eventType = MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE;									
					break;						
			}					 
			if (eventType)
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
			else if (playable && playing)
			{
				setState(MediaPlayerState.PLAYING);
			}
			else if (playable && paused)
			{
				setState(MediaPlayerState.PAUSED);
			}	
			else if (bufferable && buffering)
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
			if (autoPlay && playable && !playing)
			{
				play();
			}
		}
		
		private function onDurationReached(event:TimeEvent):void
		{
			if (loop && seekable && playable)
			{	
				addEventListener(SeekEvent.SEEK_END, onSeekEnd);
				function onSeekEnd(event:SeekEvent):void
				{
					removeEventListener(SeekEvent.SEEK_END, onSeekEnd);
					play();	
				}
				seek(0); //If we don't wait for the seekend, everything breaks for looping.									
			}
			else if (autoRewind && seekable && !loop)
			{	
				addEventListener(SeekEvent.SEEK_END, onSeekEndRewind);
				seek(0);					
				function onSeekEndRewind(event:SeekEvent):void
				{
					removeEventListener(SeekEvent.SEEK_END, onSeekEndRewind);
					setState(MediaPlayerState.READY);	
				}					
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
			 	(!seekable || !seeking) )
			{				
				lastCurrentTime = currentTime;
				dispatchEvent(new TimeEvent(TimeEvent.CURRENT_TIME_CHANGE, false, false, currentTime));
			}
		}	
		
		private function onBytesLoadedTimer(event:TimerEvent):void
		{
			if (loadable && (bytesLoaded != lastBytesLoaded))
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
				if (playable && playing)
				{
					setState(MediaPlayerState.PLAYING);					
				}
				else if (playable && paused)
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
				(_element.getTrait(MediaTraitType.LOAD) as LoadTrait).load();
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
		private var _element:MediaElement;
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
		private var mediaPlayerPan:Number = 0;
		private var mediaPlayerPanSet:Boolean = false;
		
		private var _playable:Boolean;
		private var _seekable:Boolean;
		private var _temporal:Boolean;
		private var _audible:Boolean;
		private var _viewable:Boolean;
		private var _loadable:Boolean;
		private var _bufferable:Boolean;
		private var _switchable:Boolean;
	}
}
