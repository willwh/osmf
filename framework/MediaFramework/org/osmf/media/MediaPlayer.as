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
	 * @eventType org.osmf.events.DurationChangeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.osmf.events.DurationChangeEvent")]
	 
	/**
	 * Dispatched when the playhead reaches the duration for playable media.
	 * 
	 * @eventType org.osmf.events.TraitEvent.DURATION_REACHED
	 */	 
	[Event(name="durationReached", type="org.osmf.events.TraitEvent")]
	 	 
	 // IAudible

	/**
	 * Dispatched when the <code>volume</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.VolumeChangeEvent.VOLUME_CHANGE
	 */	 	 
	[Event(name="volumeChange", type="org.osmf.events.VolumeChangeEvent")]   
	 
	/**
	 * Dispatched when the <code>muted</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.MutedChangeEvent.MUTED_CHANGE
	 */	 
	[Event(name="mutedChange", type="org.osmf.events.MutedChangeEvent")] 
	 
	/**
	 * Dispatched when the <code>pan</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PanChangeEvent.PAN_CHANGE
	 */	 	 
	[Event(name="panChange", type="org.osmf.events.PanChangeEvent")]

	 // ILoadable
 
 	/**
	 * Dispatched when the load state has changed.
	 * @see LoadState
	 *
	 * @eventType org.osmf.events.LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
	 **/
	[Event(name="loadableStateChange", type="org.osmf.events.LoadableStateChangeEvent")]

	 // IPlayable
	 
	/**
	 * Dispatched when the <code>playing</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PlayingChangeEvent.PLAYING_CHANGE
	 */	 	 	 		
	[Event(name="playingChange", type="org.osmf.events.PlayingChangeEvent")]
	
	// IPausable
	
	/**
	 * Dispatched when the <code>paused</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangeEvent.PAUSED_CHANGE
	 */	 		
	[Event(name="pausedChange", type="org.osmf.events.PausedChangeEvent")]
	
	// IViewable
	
	/**
	 * Dispatched when the <code>view</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.ViewChangeEvent.VIEW_CHANGE
	 */	 	 	 		
	[Event(name="viewChange", type="org.osmf.events.ViewChangeEvent")]
	
	 // ISpatial
	 
	/**
	 * Dispatched when the <code>width</code> and/or <code>height</code> property of the 
	 * media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */		
	[Event(name="dimensionChange", type="org.osmf.events.DimensionChangeEvent")]
	 
	 // ISeekable
	 
	/**
	 * Dispatched when the <code>seeking</code> property of the media has changed.
	 * 
	 * @eventType org.osmf.events.SeekingChangeEvent.SEEKING_CHANGE
	 */	 	
	[Event(name="seekingChange", type="org.osmf.events.SeekingChangeEvent")]
	 
	/**
	 * Dispatched when the MediaPlayer's state has changed.
	 * 
	 * @eventType org.osmf.events.PlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE
	 */	
	[Event(name="mediaPlayerStateChange", type="org.osmf.events.MediaPlayerStateChangeEvent")]

    /**
	 * Dispatched when the <code>playhead</code> property of the MediaPlayer has changed.
	 * This value is updated at the interval set by 
	 * the MediaPlayer's <code>playheadUpdateInterval</code> property.
	 *
	 * @eventType org.osmf.events.PlayheadChangeEvent.PLAYHEAD_CHANGE
	 **/
    [Event(name="playheadChange",type="org.osmf.events.PlayheadChangeEvent")]  
    
    // ISwitchable
    
	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.SwitchingChangeEvent.SWITCHING_CHANGE
	 */
	[Event(name="switchingChange",type="org.osmf.events.SwitchingChangeEvent")]
	
	/**
	 * Dispatched when the number of indicies or associated bitrates have changed.
	 * 
	 * @eventType org.osmf.events.TraitEvent.INDICES_CHANGE
	 */
	[Event(name="indicesChange",type="org.osmf.events.TraitEvent")]

    // IBufferable
        
	/**
	 * Dispatched when the <code>buffering</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferingChangeEvent.BUFFERING_CHANGE
	 */
	[Event(name="bufferingChange", type="org.osmf.events.BufferingChangeEvent")]
	
	/**
	 * Dispatched when the <code>bufferTime</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferTimeChangeEvent.BUFFER_TIME_CHANGE
	 */
	[Event(name="bufferTimeChange", type="org.osmf.events.BufferTimeChangeEvent")]
	
	// IDownloadable
	
	/**
	 * Dispatched when the data is received as a download operation progresses.
	 *
	 * @eventType flash.events.ProgressEvent
	 */
	[Event(name="bytesDownloadedChange",type="org.osmf.events.BytesDownloadedChangeEvent")]

	/**
	 * Dispatched when the value of bytesTotal property has changed.
	 *
	 * @eventType org.osmf.events.BytesTotalChangedEvent
	 */
	[Event(name="bytesTotalChange",type="org.osmf.events.BytesTotalChangeEvent")]

	// MediaPlayerCapabilityChangeEvents
    
    /**
	 * Dispatched when the <code>playable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE
	 */    
	[Event(name="playableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>bufferable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE
	 */    
	[Event(name="bufferableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
	/**
	 * Dispatched when the <code>Pausable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.Pausable_CHANGE
	 */
	[Event(name="pausableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>seekable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE
	 */
	[Event(name="seekableChange",type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>switchable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE
	 */
	[Event(name="switchableChange",type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>temporal</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE
	 */	 
	[Event(name="temporalChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>audible</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE
	 */
	[Event(name="audibleChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>viewable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE
	 */
	[Event(name="viewableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>spatial</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE
	 */
	[Event(name="spatialChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
	
	/**
	 * Dispatched when the <code>loadable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE
	 */	
	[Event(name="loadableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
	/**
	 * Dispatched when the <code>downloadable</code> property has changed.
	 * 
	 * @eventType org.osmf.events.MediaPlayerCapabilityChangeEvent.DOWNLOADABLE_CHANGE
	 */	
	[Event(name="downaloadableChange", type="org.osmf.events.MediaPlayerCapabilityChangeEvent")]
		
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
	 */
	public class MediaPlayer extends EventDispatcher
	{
		/**
		 * Constructor.
         * @param element Source MediaElement to be controlled by this MediaPlayer.
		 */
		public function MediaPlayer(element:MediaElement=null)
		{
			super();
			
			_state = MediaPlayerState.UNINITIALIZED;
			this.element = element;			
			_playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer);				
			_downloadTimer.addEventListener(TimerEvent.TIMER, onDownloadTimer);			
		}

		/**
		 * Source MediaElement controlled by this MediaPlayer.  Setting the element will attempt to load 
		 * media that is loadable, that isn't loading or loaded.  It will automatically unload media when
		 * the element changes to a new MediaElement or null.
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
						if (loadableTrait.loadState == LoadState.LOADED) // Do a courtesy unload
						{							
							loadableTrait.unload();
						}
					}	
					setState(MediaPlayerState.UNINITIALIZED);
					
					if (_element) //sometimes _element is null here due to unload nulling the element.
					{
						_element.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
						_element.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
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
					_element.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);					
					_element.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
					_element.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);					

					// If the media is not LOADABLE, then the MediaPlayer's state
					// should represent the media as already loaded (i.e. so that
					// it's ready to go).
					if (_element.hasTrait(MediaTraitType.LOADABLE) == false)
					{
						processLoadedState();
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
		 * Interval between the dispatches of change events for the playhead time
		 * in milliseconds. 
         * <p>The default progress is 250 milliseconds.
         * A non-positive value disables the dispatch of the change events.</p>
         * <p>The MediaElement must be temporal to support this property.</p>
		 * 
		 * @see org.osmf.events.#event:PlayheadChangeEvent
         * @see org.osmf.traits.ITemporal
		 */
		public function set playheadUpdateInterval(milliseconds:Number):void
		{
			if (_playheadUpdateInterval != milliseconds)
			{
				_playheadUpdateInterval = milliseconds;
				if (isNaN(_playheadUpdateInterval) || _playheadUpdateInterval <= 0)
				{
					_playheadTimer.stop();	
				}
				else
				{				
					_playheadTimer.delay = _playheadUpdateInterval;		
					if (temporal)
					{
						_playheadTimer.start();
					}			
				}					
			}			
		}
		
        public function get playheadUpdateInterval():Number
        {
        	return _playheadUpdateInterval;
        }
        
        /**
		 * Interval between the dispatches of change events for the bytesDownloaded of IDownloadable 
         * <p>The default progress is 250 milliseconds.
         * A non-positive value disables the dispatch of the change events.</p>
         * <p>The MediaElement must be downloadable to support this property.</p>
		 * 
		 * @see org.osmf.events.#event:BytesDownloadedChangeEvent
         * @see org.osmf.traits.IDownloadable
		 */
        public function set downloadUpdateInterval(milliseconds:Number):void
        {
        	if (_downloadUpdateInterval != milliseconds)
        	{
        		_downloadUpdateInterval = milliseconds;
        		
				if (isNaN(_downloadUpdateInterval) || _downloadUpdateInterval <= 0)
				{
					_downloadTimer.stop();	
				}
				else
				{				
					_downloadTimer.delay = _downloadUpdateInterval;		
					if (downloadable)
					{
						_downloadTimer.start();
					}			
				}					
        	}
        }
        
        public function get downloadUpdateInterval():Number
        {
        	return _downloadUpdateInterval;
        }

		/**
         *  Provides a high level indication of the current state of the media.
         */      
        public function get state():MediaPlayerState
        {
        	return _state;
        }               
 		
		// Trait availability
		
		/**
		 *  Indicates whether the media is playable.
		 */
		public function get playable():Boolean
		{
			return _playable;
		}
		
		/**
		 *  Indicates whether the media is Pausable.
		 */
		public function get pausable():Boolean
		{
			return _pausable;
		}
		
		/**
		 * Indicates whether the media is seekable.
		 * Seekable media can jump to a specified time.
		 */
		public function get seekable():Boolean
		{
			return _seekable;
		}
		
		/**
		 * Indicates whether the media is temporal.
		 * Temporal media supports a duration and a currentT tme within that duration.
		 */	
		public function get temporal():Boolean
		{
			return _temporal;
		}
		/**
		 *  Indicates whether the media is audible.
		 */		
		public function get audible():Boolean
		{
			return _audible;
		}
		
		/**
		 * Indicates whether the media is viewable.
		 * Viewable media is exposed by a DisplayObject.
		 * @see flash.display.DisplayObject
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
		 */	
		public function get spatial():Boolean
		{
			return _spatial;
		}
		
		/**
		 * Indicates whether the media is switchable.
		 * Wwitchable exposes the ability to autoswitch or manually switch
		 * between multiple bitrate streams.
		 */	
		public function get switchable():Boolean
		{
			return _switchable;
		}
				
		/**
		 *  Indicates whether the media is loadable.
		 */
		public function get loadable():Boolean
		{
			return _loadable;
		}
		
		/**
		 * Indicates whether the media is capable of buffering.
		 */
		public function get bufferable():Boolean
		{
			return _bufferable;
		}
				
		/**
		 * Indicates whether the media is downloadable.
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
		 * <p>The MediaElement must be audible to support this property.</p>
		 * 
         * @see org.osmf.traits.IAudible
		 */
	    public function get volume():Number
	    {	
	    	return audible ? IAudible(getTrait(MediaTraitType.AUDIBLE)).volume : 0;	    		    
	    }		   
	    
	    public function set volume(value:Number):void
	    {
	    	if (audible)
	    	{
	    		(getTrait(MediaTraitType.AUDIBLE) as IAudible).volume = value;
	    	}	    		
	    }
		
		/**
		 * Indicates whether the media is currently muted.
		 * <p>The MediaElement must be audible to support this property.</p>
		 * 
         * @see org.osmf.traits.IAudible
		 */				
	    public function get muted():Boolean
	    {
	    	return audible ? IAudible(getTrait(MediaTraitType.AUDIBLE)).muted : false;	    	   
	    }
	    
	    public function set muted(value:Boolean):void
	    {
	    	if (audible)
	    	{
	    		(getTrait(MediaTraitType.AUDIBLE) as IAudible).muted = value;
	    	}	    				 
	    }
	 	 
		/**
		 * Pan property of the media.
		 * Ranges from -1 (full pan left) to 1 (full pan right).
		 * <p>The MediaElement must be audible to support this property.</p>
		 * 
         * @see org.osmf.traits.IAudible
		 */					
		
	    public function get pan():Number
	    {
	    	return audible ? IAudible(getTrait(MediaTraitType.AUDIBLE)).pan : 0;	    		
	    }
	    
	    public function set pan(value:Number):void
	    {
	    	if (audible)
	    	{
	    		(getTrait(MediaTraitType.AUDIBLE) as IAudible).pan = value;
	    	}	    	
		}
	
	    // IPausable
		
		/**
		 * Indicates whether the media is currently paused.
		 * <p>The MediaElement must be pausable to support this property.</p>
		 * 
         * @see org.osmf.traits.IPausable
		 */	
		public function get paused():Boolean
	    {
	    	return pausable ? (getTrait(MediaTraitType.PAUSABLE) as IPausable).paused : false;	    		    
	    }
	    
		/**
	    * Pauses the media, if it is not already paused.
	    * @throws IllegalOperationError if capability isn't supported
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
		 */					
	    public function get playing():Boolean
	    {
	    	return playable ? (getTrait(MediaTraitType.PLAYABLE) as IPlayable).playing : false;	    		
	    }
	    
	    /**
	    * Plays the media, if it is not already playing.
	    * @throws IllegalOperationError if capability isn't supported
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
		 */	
		public function get height():int
	    {
	    	return spatial ? (getTrait(MediaTraitType.SPATIAL) as ISpatial).height : 0;
	    }
	    
	    // ISwitchable
	    
	    /**
		 * Defines whether or not the ISwitchable trait should be in manual 
		 * or autoswitch mode. If in manual mode the <code>switchTo</code>
		 * method can be used to manually switch to a specific stream.
		 */
		public function get autoSwitch():Boolean
		{
			return switchable ? (getTrait(MediaTraitType.SWITCHABLE) as ISwitchable).autoSwitch : false;
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
		 */		    
	    public function get currentTime():Number
	    {
	    	return temporal ? (getTrait(MediaTraitType.TEMPORAL) as ITemporal).currentTime : 0;
	    }
	    	    
	    /**
		 * Indicates whether the media is currently buffering.
		 * 
		 * <p>The default is <code>false</code>.</p>
		 */		
		public function get buffering():Boolean
		{
			return bufferable ? (getTrait(MediaTraitType.BUFFERABLE) as IBufferable).buffering : false;	    	
		}
		
		/**
		 * Length of the content currently in the media's
		 * buffer, in seconds. 
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
		 * The number of bytes of the media that has been downloaded. When the underlying trait is absent, NaN is returned
		 * 
		 */		
		public function get bytesDownloaded():Number
		{
			return downloadable? (getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable).bytesDownloaded : 0;
		}
		
		/**
		 * The total number of bytes of the media that will be downloaded. When the underlying trait is absent, NaN is returned
		 * 
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
	        
		private function onTraitAdd(event:TraitsChangeEvent):void
		{				
			updateTraitListeners(event.traitType, true);				
		}
		
		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			updateTraitListeners(event.traitType, false);						
		}
		
		private function updateTraitListeners(trait:MediaTraitType, add:Boolean):void
		{		
			var traitChangeName:String;	
			switch (trait)
			{
				case MediaTraitType.TEMPORAL:									
					changeListeners(add, _element, trait, DurationChangeEvent.DURATION_CHANGE, [redispatchEvent]);							
					changeListeners(add, _element, trait, TraitEvent.DURATION_REACHED, [redispatchEvent, onDurationReached] );								
					if (add && _playheadUpdateInterval > 0 && !isNaN(_playheadUpdateInterval) )
					{
						_playheadTimer.start();
					}
					else
					{
						_playheadTimer.stop();					
					}
					_temporal = add;
					traitChangeName = MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE;		
					break;
				case MediaTraitType.PLAYABLE:						
					changeListeners(add, _element, trait, PlayingChangeEvent.PLAYING_CHANGE, [redispatchEvent,onPlaying] );			
					_playable = add;							
					if (autoPlay && playable && !playing)
					{
						play();
					}
					traitChangeName = MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE;												
					break;	
				case MediaTraitType.AUDIBLE:					
					changeListeners(add, _element, trait, VolumeChangeEvent.VOLUME_CHANGE, [redispatchEvent]);			
					changeListeners(add, _element, trait, MutedChangeEvent.MUTED_CHANGE, [redispatchEvent]);			
					changeListeners(add, _element, trait, PanChangeEvent.PAN_CHANGE, [redispatchEvent]);	
					_audible = add;
					traitChangeName = MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE;					
					break;
				case MediaTraitType.PAUSABLE:											
					changeListeners(add, _element, trait, PausedChangeEvent.PAUSED_CHANGE, [redispatchEvent, onPaused]);						
					_pausable = add;		
					traitChangeName = MediaPlayerCapabilityChangeEvent.PAUSABLE_CHANGE;	
					break;
				case MediaTraitType.SEEKABLE:														
					changeListeners(add, _element, trait, SeekingChangeEvent.SEEKING_CHANGE, [redispatchEvent, onSeeking]);
					_seekable = add;					
					traitChangeName = MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE;							
					break;
				case MediaTraitType.SPATIAL:	
					changeListeners(add, _element, trait, DimensionChangeEvent.DIMENSION_CHANGE, [redispatchEvent]);								
					_spatial = add;						
					traitChangeName = MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE;					
					break;
				case MediaTraitType.SWITCHABLE:	
					changeListeners(add, _element, trait, SwitchingChangeEvent.SWITCHING_CHANGE, [redispatchEvent]);								
					_switchable = add;						
					traitChangeName = MediaPlayerCapabilityChangeEvent.SWITCHABLE_CHANGE;					
					break;						
				case MediaTraitType.VIEWABLE:					
					changeListeners(add, _element, trait, ViewChangeEvent.VIEW_CHANGE, [redispatchEvent]);											
					_viewable = add;						
					traitChangeName = MediaPlayerCapabilityChangeEvent.VIEWABLE_CHANGE;					
					break;	
				case MediaTraitType.LOADABLE:					
					changeListeners(add, _element, trait, LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, [redispatchEvent, onLoadState]);					
					_loadable = add;		
					if (add)
					{
						var loadState:LoadState = (_element.getTrait(trait) as ILoadable).loadState;
						if (loadState != LoadState.LOADED && 
							loadState != LoadState.LOADING)
						{
							load();
						}
						else if (autoPlay && playable && !playing)
						{
							play();	
						}						
					}						
					traitChangeName = MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE;				
					break;		
				case MediaTraitType.BUFFERABLE:
					changeListeners(add, _element, trait, BufferingChangeEvent.BUFFERING_CHANGE, [redispatchEvent, onBuffering]);	
					changeListeners(add, _element, trait, BufferTimeChangeEvent.BUFFER_TIME_CHANGE, [redispatchEvent]);						
					_bufferable = add;
					traitChangeName = MediaPlayerCapabilityChangeEvent.BUFFERABLE_CHANGE;									
					break;						
				case MediaTraitType.DOWNLOADABLE:
					changeListeners(add, _element, trait, BytesTotalChangeEvent.BYTES_TOTAL_CHANGE, [redispatchEvent]);
					if (add && _downloadUpdateInterval > 0 && !isNaN(_downloadUpdateInterval) )
					{
						_downloadTimer.start();
					}
					else
					{
						_downloadTimer.stop();					
					}
					_downloadable = add;
					traitChangeName = MediaPlayerCapabilityChangeEvent.DOWNLOADABLE_CHANGE;
					break;
			}					 
			if (traitChangeName)  // Don't dispatch for traits we don't know about yet.
			{
				dispatchEvent(new MediaPlayerCapabilityChangeEvent(traitChangeName, add));	
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
		
		// TraitEvent Listeners will redispatch all of the ChangeEvents that correspond to trait 
		// properties.
		private function redispatchEvent(event:Event):void
		{
			dispatchEvent(event.clone());			
		}	
				
		private function onSeeking(event:SeekingChangeEvent):void
		{				
			if (event.seeking)
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
		
		private function onLoadState(event:LoadableStateChangeEvent):void
		{		
			if (event.newState == LoadState.LOADED)
			{
				processLoadedState();
			}
			else if (event.newState == LoadState.CONSTRUCTED)
			{				
				setState(MediaPlayerState.UNINITIALIZED);
			}	
			else if (event.newState == LoadState.LOAD_FAILED)
			{
				setState(MediaPlayerState.PLAYBACK_ERROR);
			}	
			else if (event.newState == LoadState.LOADING)
			{				
				setState(MediaPlayerState.INITIALIZING);
			}			
		}
		
		private function processLoadedState():void
		{
			setState(MediaPlayerState.READY);
			if (autoPlay && playable && !playing)
			{
				play();
			}
		}
		
		private function onDurationReached(event:TraitEvent):void
		{
			if (loop && seekable && playable)
			{			
				seek(0);
				play();
			}
			else if (autoRewind && seekable && pausable)
			{				
				seek(0);
				pause();		
			}
			else
			{
				setState(MediaPlayerState.READY);
			}
		}			
								
		private function onPlayheadTimer(event:TimerEvent):void
		{
			if (temporal && currentTime != lastCurrentTime)
			{				
				lastCurrentTime = currentTime;
				dispatchEvent(new PlayheadChangeEvent(currentTime));
			}
		}	
		
		private function onDownloadTimer(event:TimerEvent):void
		{
			if (downloadable && (bytesDownloaded != lastBytesDownloaded))
			{
				var bytesDownloadedEvent:BytesDownloadedChangeEvent 
					= new BytesDownloadedChangeEvent
						( lastBytesDownloaded
						, bytesDownloaded
						);
						 	
				lastBytesDownloaded = bytesDownloaded;
				
				dispatchEvent(bytesDownloadedEvent);
			}
		}
		
		private function onBuffering(event:BufferingChangeEvent):void
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
		
		private function setState(newState:MediaPlayerState):void
		{
			var oldState:MediaPlayerState = _state;
			if (oldState != newState)
			{
				_state = newState;
				dispatchEvent(new MediaPlayerStateChangeEvent(newState, oldState));
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
	    private var lastBytesDownloaded:Number = NaN;	
		private var _autoPlay:Boolean = true;
		private var _autoRewind:Boolean = true;
		private var _loop:Boolean = false;		
		private var _playheadUpdateInterval:Number = DEFAULT_UPDATE_INTERVAL;
		private var _playheadTimer:Timer  = new Timer(DEFAULT_UPDATE_INTERVAL);
		private var _element:MediaElement;
		private var _state:MediaPlayerState;
		private var _downloadUpdateInterval:Number = DEFAULT_UPDATE_INTERVAL;
		private var _downloadTimer:Timer = new Timer(DEFAULT_UPDATE_INTERVAL);
		
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
