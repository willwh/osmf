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
	import org.osmf.utils.MediaFrameworkStrings;
	   
	// ITemporal
	
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
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	 
	[Event(name="durationReached", type="org.osmf.events.TimeEvent")]
	 	 
	// IAudible

	/**
	 * Dispatched when the <code>volume</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.AudioEvent.VOLUME_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	 	 
	[Event(name="panChange", type="org.osmf.events.AudioEvent")]

	// ILoadable
 
 	/**
	 * Dispatched when the load state has changed.
	 * @see LoadState
	 *
	 * @eventType org.osmf.events.LoadEvent.LOAD_STATE_CHANGE
	 **/
	[Event(name="loadStateChange", type="org.osmf.events.LoadEvent")]

	// IPlayable
	 
	/**
	 * Dispatched when the <code>playing</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PlayingChangeEvent.PLAYING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	 	 	 		
	[Event(name="playingChange", type="org.osmf.events.PlayingChangeEvent")]
	
	// IPausable
	
	/**
	 * Dispatched when the <code>paused</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangeEvent.PAUSED_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	 		
	[Event(name="pausedChange", type="org.osmf.events.PausedChangeEvent")]
	
	// IViewable
	
	/**
	 * Dispatched when the <code>view</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	 	 	 		
	[Event(name="viewChange", type="org.osmf.events.ViewEvent")]
	
	// ISpatial
	 
	/**
	 * Dispatched when the <code>width</code> and/or <code>height</code> property of the 
	 * media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */		
	[Event(name="dimensionChange", type="org.osmf.events.DimensionEvent")]
	 
	// ISeekable
	 
	/**
	 * Dispatched when the <code>seeking</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.SeekingChangeEvent.SEEKING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
    
    // ISwitchable
    
	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchEvent.SWITCHING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="indicesChange",type="org.osmf.events.SwitchEvent")]

    // IBufferable
        
	/**
	 * Dispatched when the <code>buffering</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferEvent.BUFFERING_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bufferTimeChange", type="org.osmf.events.BufferEvent")]
	
	// IDownloadable
	
	/**
	 * Dispatched when the data is received as a download operation progresses.
	 *
	 * @eventType org.osmf.events.LoadEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bytesTotalChange",type="org.osmf.events.LoadEvent")]

	// MediaPlayerCapabilityChangeEvents
    
    /**
	 * Dispatched when the <code>playable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
	 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function set element(value:MediaElement):void
		{
			if (value != _element)
			{
				var traitType:MediaTraitType;
				if (_element)
				{											
					if (loadable)
					{	 
						var loadableTrait:ILoadable = _element.getTrait(MediaTraitType.LOADABLE) as ILoadable;
						if (loadableTrait.loadState == LoadState.READY) // Do a courtesy unload
						{							
							loadableTrait.unload();
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

					// If the media is not LOADABLE, then the MediaPlayer's state
					// should represent the media as already ready.
					if (_element.hasTrait(MediaTraitType.LOADABLE) == false)
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 * Interval between the dispatch of change events for the bytesLoaded of IDownloadable 
         * <p>The default is 250 milliseconds.
         * A non-positive value disables the dispatch of the change events.</p>
         * <p>The MediaElement must be downloadable to support this property.</p>
		 * 
		 * @see org.osmf.events.#event:LoadEvent
         * @see org.osmf.traits.IDownloadable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
					if (downloadable)
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
         *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get playable():Boolean
		{
			return _playable;
		}
		
		/**
		 *  Indicates whether the media is Pausable.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get pausable():Boolean
		{
			return _pausable;
		}
		
		/**
		 * Indicates whether the media is seekable.
		 * Seekable media can jump to a specified time.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get viewable():Boolean
		{
			return _viewable;
		}
		
		/**
		 * Indicates whether the media is spatial.
		 * Spatial exposes the intrinsic dimensions of the media.
		 * <p>For example, the intrinsic dimensions of an image are the height and width
		 * of the image as it is stored.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function get spatial():Boolean
		{
			return _spatial;
		}
		
		/**
		 * Indicates whether the media is switchable.
		 * Wwitchable exposes the ability to autoswitch or manually switch
		 * between multiple bitrate streams.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bufferable():Boolean
		{
			return _bufferable;
		}
				
		/**
		 * Indicates whether the media is downloadable.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */

		public function get downloadable():Boolean
		{
			return _downloadable;
		}
		
		// Trait Based properties
		
		// IAudible
		
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
	    public function get volume():Number
	    {	
	    	return audible ? IAudible(getTrait(MediaTraitType.AUDIBLE)).volume : mediaPlayerVolume;	    		    
	    }		   
	    
	    public function set volume(value:Number):void
	    {
	    	if (audible)
	    	{
	    		(getTrait(MediaTraitType.AUDIBLE) as IAudible).volume = value;
	    	}

    		mediaPlayerVolume = value;
    		mediaPlayerVolumeSet = true;
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */				
	    public function get muted():Boolean
	    {
	    	return audible ? IAudible(getTrait(MediaTraitType.AUDIBLE)).muted : mediaPlayerMuted;	    	   
	    }
	    
	    public function set muted(value:Boolean):void
	    {
	    	if (audible)
	    	{
	    		(getTrait(MediaTraitType.AUDIBLE) as IAudible).muted = value;
	    	}

    		mediaPlayerMuted = value;
    		mediaPlayerMutedSet = true;
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */					
		
	    public function get pan():Number
	    {
	    	return audible ? IAudible(getTrait(MediaTraitType.AUDIBLE)).pan : mediaPlayerPan;	    		
	    }
	    
	    public function set pan(value:Number):void
	    {
	    	if (audible)
	    	{
	    		(getTrait(MediaTraitType.AUDIBLE) as IAudible).pan = value;
	    	}

    		mediaPlayerPan = value;
    		mediaPlayerPanSet = true;
		}
	
	    // IPausable
		
		/**
		 * Indicates whether the media is currently paused.
		 * <p>The MediaElement must be pausable to support this property.</p>
		 * 
         * @see org.osmf.traits.IPausable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function get paused():Boolean
	    {
	    	return pausable ? (getTrait(MediaTraitType.PAUSABLE) as IPausable).paused : false;	    		    
	    }
	    
		/**
	    * Pauses the media, if it is not already paused.
	    * @throws IllegalOperationError if capability isn't supported
	    *  
	    *  @langversion 3.0
	    *  @playerversion Flash 10
	    *  @playerversion AIR 1.0
	    *  @productversion OSMF 1.0
	    */
	    public function pause():void
	    {
	    	(getTrait(MediaTraitType.PAUSABLE) as IPausable).pause();	    		
	    }
	
	    // IPlayable
			
		/**
		 * Indicates whether the media is currently playing.
		 * <p>The MediaElement must be playable to support this property.</p>
		 * 
         * @see org.osmf.traits.IPlayable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */					
	    public function get playing():Boolean
	    {
	    	return playable ? (getTrait(MediaTraitType.PLAYABLE) as IPlayable).playing : false;	    		
	    }
	    
	    /**
	    * Plays the media, if it is not already playing.
	    * @throws IllegalOperationError if capability isn't supported
	    *  
	    *  @langversion 3.0
	    *  @playerversion Flash 10
	    *  @playerversion AIR 1.0
	    *  @productversion OSMF 1.0
	    */
	    public function play():void
	    {
	    	(getTrait(MediaTraitType.PLAYABLE) as IPlayable).play();	    	
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */			
	    public function get seeking():Boolean
	    {
	    	return seekable ? (getTrait(MediaTraitType.SEEKABLE) as ISeekable).seeking : false;
	    }
	    
	    /**
	     * Instructs the playhead to jump to the specified time.
	     * <p>If <code>time</code> is NaN or negative, does not attempt to seek.</p>
	     * @param time Time to seek to in seconds.
	     * @throws IllegalOperationError if capability isn't supported
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10
	     *  @playerversion AIR 1.0
	     *  @productversion OSMF 1.0
	     */	    
	    public function seek(time:Number):void
	    {
	    	(getTrait(MediaTraitType.SEEKABLE) as ISeekable).seek(time);	    				
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
	    public function canSeekTo(time:Number):Boolean
	    {
	    	return (getTrait(MediaTraitType.SEEKABLE) as ISeekable).canSeekTo(time);
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
	    public function get width():int
	    {
	    	return spatial ? (getTrait(MediaTraitType.SPATIAL) as ISpatial).width : 0;
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function get height():int
	    {
	    	return spatial ? (getTrait(MediaTraitType.SPATIAL) as ISpatial).height : 0;
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 *		 
		 */
		public function get autoSwitch():Boolean
		{
			return switchable ? (getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch : true;
		}
		
		public function set autoSwitch(value:Boolean):void
		{
			if (switchable)
			{
				(getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch = value;
			}
		}
		
		/**
		 * The index of the stream currently rendering. Uses a zero-based index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get currentStreamIndex():int
		{
			return switchable ? (getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).currentIndex : 0; 
		}
		
		/**
		 * Gets the associated bitrate, in kilobytes for the specified index.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than the highest index available.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function getBitrateForIndex(index:int):Number
		{
			return (getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).getBitrateForIndex(index);
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get maxStreamIndex():int
		{
			return switchable ? (getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).maxIndex : 0;
		}
		
		public function set maxStreamIndex(value:int):void
		{
			(getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).maxIndex = value; 
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get switchUnderway():Boolean
		{
			return switchable ? (getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).switchUnderway : false;
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function switchTo(streamIndex:int):void
		{
			(getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).switchTo(streamIndex);
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
         *  @playerversion AIR 1.0
         *  @productversion OSMF 1.0
         */
	    public function get view():DisplayObject
	    {
	    	return viewable ? (getTrait(MediaTraitType.VIEWABLE) as IViewable).view : null;	
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
	    public function get duration():Number
	    {
	    	return temporal ? (getTrait(MediaTraitType.TEMPORAL) as ITemporal).duration : 0;	    	
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		    
	    public function get currentTime():Number
	    {
	    	return temporal ? (getTrait(MediaTraitType.TEMPORAL) as ITemporal).currentTime : 0;
	    }
	    	    
	    /**
		 * Indicates whether the media is currently buffering.
		 * 
		 * <p>The default is <code>false</code>.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get buffering():Boolean
		{
			return bufferable ? (getTrait(MediaTraitType.BUFFERABLE) as IBufferable).buffering : false;	    	
		}
		
		/**
		 * Length of the content currently in the media's
		 * buffer, in seconds. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get bufferLength():Number
		{
			return bufferable ? (getTrait(MediaTraitType.BUFFERABLE) as IBufferable).bufferLength : 0;	    	
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get bufferTime():Number
		{
			return bufferable ? (getTrait(MediaTraitType.BUFFERABLE) as IBufferable).bufferTime : 0;		    	
		}
		
		public function set bufferTime(value:Number):void
		{
			if (bufferable)
			{
				(getTrait(MediaTraitType.BUFFERABLE) as IBufferable).bufferTime = value;
			}	    	
		}
		
		// IDownloadable
				
		/**
		 * The number of bytes of the media that has been downloaded. When the underlying trait is absent, 0 is returned.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get bytesLoaded():Number
		{
			return downloadable? (getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable).bytesLoaded : 0;
		}
		
		/**
		 * The total number of bytes of the media that will be downloaded. When the underlying trait is absent, 0 is returned.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get bytesTotal():Number
		{
			return downloadable? (getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable).bytesTotal : 0;
		}

		// Internals
		//
	    
	    private function getTrait(trait:MediaTraitType):IMediaTrait
	    {
	    	if (!_element || !_element.hasTrait(trait))
	    	{
	    		throw new IllegalOperationError(MediaFrameworkStrings.TRAIT_NOT_SUPPORTED);		    		
	    	}
	    	return _element.getTrait(trait);
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
		
		private function updateTraitListeners(trait:MediaTraitType, add:Boolean):void
		{		
			var eventType:String;	
			switch (trait)
			{
				case MediaTraitType.TEMPORAL:									
					changeListeners(add, _element, trait, TimeEvent.DURATION_CHANGE, [redispatchEvent]);							
					changeListeners(add, _element, trait, TimeEvent.DURATION_REACHED, [redispatchEvent, onDurationReached] );								
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
				case MediaTraitType.PLAYABLE:						
					changeListeners(add, _element, trait, PlayingChangeEvent.PLAYING_CHANGE, [redispatchEvent,onPlaying] );			
					_playable = add;							
					if (autoPlay && playable && !playing)
					{
						play();
					}
					eventType = MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE;												
					break;	
				case MediaTraitType.AUDIBLE:					
					changeListeners(add, _element, trait, AudioEvent.VOLUME_CHANGE, [redispatchEvent]);		
					changeListeners(add, _element, trait, AudioEvent.MUTED_CHANGE, [redispatchEvent]);
					changeListeners(add, _element, trait, AudioEvent.PAN_CHANGE, [redispatchEvent]);
					_audible = add;
					if (audible)
					{
						// When IAudible is added, we should tell it to reflect any
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
				case MediaTraitType.PAUSABLE:											
					changeListeners(add, _element, trait, PausedChangeEvent.PAUSED_CHANGE, [redispatchEvent, onPaused]);						
					_pausable = add;		
					eventType = MediaPlayerCapabilityChangeEvent.PAUSABLE_CHANGE;	
					break;
				case MediaTraitType.SEEKABLE:														
					changeListeners(add, _element, trait, SeekEvent.SEEK_BEGIN, [redispatchEvent, onSeeking]);
					changeListeners(add, _element, trait, SeekEvent.SEEK_END, [redispatchEvent, onSeeking]);
					_seekable = add;					
					eventType = MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE;							
					break;
				case MediaTraitType.SPATIAL:	
					changeListeners(add, _element, trait, DimensionEvent.DIMENSION_CHANGE, [redispatchEvent]);								
					_spatial = add;						
					eventType = MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE;					
					break;
				case MediaTraitType.SWITCHABLE:	
					changeListeners(add, _element, trait, SwitchEvent.SWITCHING_CHANGE, [redispatchEvent]);								
					_switchable = add;						
					eventType = MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE;					
					break;						
				case MediaTraitType.VIEWABLE:					
					changeListeners(add, _element, trait, ViewEvent.VIEW_CHANGE, [redispatchEvent]);											
					_viewable = add;						
					eventType = MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE;					
					break;	
				case MediaTraitType.LOADABLE:					
					changeListeners(add, _element, trait, LoadEvent.LOAD_STATE_CHANGE, [redispatchEvent, onLoadState]);					
					_loadable = add;		
					if (add)
					{
						var loadState:String = (_element.getTrait(trait) as ILoadable).loadState;
						if (loadState != LoadState.READY && 
							loadState != LoadState.LOADING)
						{
							load();
						}
						else if (autoPlay && playable && !playing)
						{
							play();	
						}						
					}						
					eventType = MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE;				
					break;		
				case MediaTraitType.BUFFERABLE:
					changeListeners(add, _element, trait, BufferEvent.BUFFERING_CHANGE, [redispatchEvent, onBuffering]);	
					changeListeners(add, _element, trait, BufferEvent.BUFFER_TIME_CHANGE, [redispatchEvent]);						
					_bufferable = add;
					eventType = MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE;									
					break;						
				case MediaTraitType.DOWNLOADABLE:
					changeListeners(add, _element, trait, LoadEvent.BYTES_TOTAL_CHANGE, [redispatchEvent]);
					if (add && _bytesLoadedUpdateInterval > 0 && !isNaN(_bytesLoadedUpdateInterval))
					{
						_bytesLoadedTimer.start();
					}
					else
					{
						_bytesLoadedTimer.stop();					
					}
					_downloadable = add;
					eventType = MediaPlayerCapabilityChangeEvent.DOWNLOADABLE_CHANGE;
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
		private function changeListeners(add:Boolean, media:MediaElement, kind:MediaTraitType, event:String, listeners:Array):void
		{
			for each (var item:Function in listeners)
			{
				if (add)
				{
					// Make sure that the MediaPlayer gets to process the event
					// before it gets redispatched to the client.  This will
					// ensure that we present a consistent state to the client.
					var priority:int = item == redispatchEvent ? 0 : 1;
					
					media.getTrait(kind).addEventListener(event, item, false, priority);
				}
				else
				{			
					media.getTrait(kind).removeEventListener(event, item);
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
			else if (pausable && paused)
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
				
		private function onPlaying(event:PlayingChangeEvent):void
		{			
			if (event.playing)
			{				
				setState(MediaPlayerState.PLAYING);				
			}					
		}
		
		private function onPaused(event:PausedChangeEvent):void
		{			
			if (event.paused)
			{				
				setState(MediaPlayerState.PAUSED);				
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
				seek(0);
				play();
			}
			else if (autoRewind && seekable && pausable)
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
			if (temporal && currentTime != lastCurrentTime)
			{				
				lastCurrentTime = currentTime;
				dispatchEvent(new TimeEvent(TimeEvent.CURRENT_TIME_CHANGE, false, false, currentTime));
			}
		}	
		
		private function onBytesLoadedTimer(event:TimerEvent):void
		{
			if (downloadable && (bytesLoaded != lastBytesLoaded))
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
				else if (pausable && paused)
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
				(_element.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();
			}
			catch(error:Error)
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
		private var _pausable:Boolean;
		private var _seekable:Boolean;
		private var _temporal:Boolean;
		private var _audible:Boolean;
		private var _viewable:Boolean;
		private var _spatial:Boolean;
		private var _loadable:Boolean;
		private var _bufferable:Boolean;
		private var _switchable:Boolean;
		private var _downloadable:Boolean;
	}
}
