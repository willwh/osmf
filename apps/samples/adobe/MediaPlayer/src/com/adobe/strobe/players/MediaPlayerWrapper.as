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
package com.adobe.strobe.players
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.openvideoplayer.display.MediaPlayerSprite;
	import org.openvideoplayer.display.ScaleMode;
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaPlayer;
	import org.openvideoplayer.media.MediaPlayerState;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.video.*;
	
	public class MediaPlayerWrapper extends UIComponent
	{		
		
		public function set element(value:MediaElement):void
		{
			mediaPlayer.source = value;
		}
		
		public function get element():MediaElement
		{
			return mediaPlayer.source;
		}	
		
		override protected function createChildren():void
		{
			super.createChildren();
			_player = new MediaPlayerSprite();	
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.AUDIBLE_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.LOADABLE_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PAUSIBLE_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.PLAYABLE_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SEEKABLE_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.SPATIAL_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE, redispatchEvent);		
			mediaPlayer.addEventListener(PlayheadChangeEvent.PLAYHEAD_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(VolumeChangeEvent.VOLUME_CHANGE, redispatchEvent);			
			mediaPlayer.addEventListener(MutedChangeEvent.MUTED_CHANGE, redispatchEvent);			
			mediaPlayer.addEventListener(PanChangeEvent.PAN_CHANGE, redispatchEvent);		
			mediaPlayer.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, redispatchEvent );			
			mediaPlayer.addEventListener(PausedChangeEvent.PAUSED_CHANGE, redispatchEvent);						
			mediaPlayer.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, redispatchEvent);
			mediaPlayer.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, redispatchEvent);	
			mediaPlayer.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, redispatchEvent);					
			mediaPlayer.addEventListener(TraitEvent.DURATION_REACHED, redispatchEvent );	
			mediaPlayer.addEventListener(DurationChangeEvent.DURATION_CHANGE, redispatchEvent );	
			mediaPlayer.addEventListener(BufferingChangeEvent.BUFFERING_CHANGE, redispatchEvent);	
			mediaPlayer.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, redispatchEvent);	
			addChild(_player);
			
		}
				
		override protected function updateDisplayList(w:Number, h:Number):void
		{		
			_player.setAvailableSize(w,h);
		}
		
		/**
		 * The scaleMode property describes different ways of laying out the media content within a this sprite.
		 * There are four modes available, NONE, STRETCH, LETTERBOX and CROP, which are used by the MediaElementSprite. 
		 * See ScaleMode.as for usage examples.
		 */ 	
		 public function set scaleMode(value:ScaleMode):void
		 {
		 	_player.scaleMode = value;
		 }
		 
		  public function get scaleMode():ScaleMode
		 {
		 	return _player.scaleMode;
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
			mediaPlayer.autoRewind = value;							
		}
		
        public function get autoRewind():Boolean
        {
        	return mediaPlayer.autoRewind;
        }


        /**
		 * Indicates whether the MediaPlayer starts playing the media as soon as its
		 * load operation has successfully completed.
		 * <p>The default is <code>true</code>.</p>
		 * <p>The source media element must have be playable in 
		 * order to support this property.</p>  Applies to media
		 * 
         * @see org.openvideoplayer.traits.IPlayable
		 */
		public function set autoPlay(value:Boolean):void
		{			
			mediaPlayer.autoPlay = value;						
		}
		
        public function get autoPlay():Boolean
        {
        	return mediaPlayer.autoPlay;
        }

         /**
         * Indicates whether the media should play again after playback has completed.
         * The <code>loop</code> property takes precedence over the the <code>autoRewind</code> property,
         * so if <code>loop</code> is set to <code>true</code>, the <code>autoRewind</code> property
         * is ignored.
         * <p>The default is <code>false</code>.</p>
		 */
		public function set loop(value:Boolean):void
		{
			mediaPlayer.loop = value;
		}
		
        public function get loop():Boolean
        {
        	return mediaPlayer.loop;
        }

        /**
		 * Interval between the dispatches of update progress events for the playhead position
		 * in milliseconds.  The playhead event is org.openvideoplayer.events.PlayheadChangeEvent.
         * <p>The default progress is 250 milliseconds.
         * A non-positive value disables the dispatch of the update progress events.</p>
         * <p>The source media element must be temporal in order to support this property.</p>
		 * 
         * @see org.openvideoplayer.traits.ITemporal
		 */
		public function set playheadUpdateInterval(milliseconds:Number):void
		{
			mediaPlayer.playheadUpdateInterval = milliseconds;
		}
		
        public function get playheadUpdateInterval():Number
        {
        	return mediaPlayer.playheadUpdateInterval;
        }
        
		/**
         *  MediaPlayer state provides a high level indication of the current operations of the media.
         *  All states here are not completely disjoint (i.e. initialized + playing have some overlap).
         */   
        [ChangeEvent(event="mediaPlayerStateChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]	   
        public function get mediaState():MediaPlayerState
        {
        	return mediaPlayer.state;
        }     
				
		/**
		 *  True when the source mediaElement has the IPlayable trait.
		 */ 	
		[ChangeEvent(event="playableChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]			
		public function get playable():Boolean
		{
			return mediaPlayer.playable;
		}
		
		/**
		 *  True when the source mediaElement has the IPausible trait.
		 */	
		[Event(event="pausibleChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get  pausible():Boolean
		{
			return mediaPlayer.pausible;
		}
		
		/**
		 *  True when the source mediaElement has the ISeekable trait.
		 */
		[ChangeEvent(event="seekableChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get  seekable():Boolean
		{
			return mediaPlayer.seekable;
		}
		
		/**
		 *  True when the source mediaElement has the ITemporal trait.
		 */	
		[ChangeEvent(event="temporalChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get  temporal():Boolean
		{
			return mediaPlayer.temporal;
		}
		
		/**
		 *  True when the source mediaElement has the IAudible trait.
		 */	
		[ChangeEvent(event="audibleChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get  audible():Boolean
		{
			return mediaPlayer.audible;
		}
		
		/**
		 *  True when the source mediaElement has the ISpatial trait.
		 */
		[ChangeEvent(event="viewableChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get  viewable():Boolean
		{
			return mediaPlayer.viewable;
		}
		
		/**
		 *  True when the source mediaElement has the IViewable trait.
		 */	
		[ChangeEvent(event="spatialChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get  spatial():Boolean
		{
			return mediaPlayer.spatial;
		}

		/**
		 *  True when the source mediaElement has the ILoadable trait.
		 */	
		[ChangeEvent(event="loadableChange",type="org.openvideoplayer.events.MediaStateChangeEvent")]
		public function get loadable():Boolean
		{
			return mediaPlayer.loadable;
		}
				
							
		/**
		 * The position of the associated media element's cursor 
		 * in seconds.  Must never exceed the <code>duration</code>.
		 */		
				
		[ChangeEvent(event="playheadChange",type="org.openvideoplayer.events.PlayheadChangeEvent")]
		public function get playhead():Number
		{
			if(playable)
			{
				return mediaPlayer.playhead;
			}
			return 0;
		}

		/**
		 * The duration of the associated media element in
		 * seconds.
		 */	
		[ChangeEvent(event="durationChange",type="org.openvideoplayer.events.DurationChangeEvent")]
		public function get duration():Number
		{
			if(mediaPlayer.temporal)
			{
				return mediaPlayer.duration;
			}
			else
			{
				return 0;
			}
		}
		
		[ChangeEvent(event="volumeChange",type="org.openvideoplayer.events.VolumeChangeEvent")]
		/**
		 * The volume, ranging from 0 (silent) to 1 (full volume).
		 * 
		 * <p>Passing a value greater than 1 sets the value to 1.
		 * Passing a value less than zero sets the value to zero.
		 * </p>
		 * 
		 * <p>Changing the value of the <code>volume</code> property does not affect the value of the
		 * <code>muted</code> property.</p>
		 * 
		 * <p>The default is 1.</p>
		 * 
		 * @see IAudible#muted 
		 */		
		[ChangeEvent(event="volumeChange",type="org.openvideoplayer.events.VolumeChangeEvent")]
		public function get volume():Number
		{			
			return mediaPlayer.audible ?  mediaPlayer.volume : 0;
			return mediaPlayer.volume;
			return mediaPlayer.audible ?  mediaPlayer.volume : 0;
		}
		
		public function set volume(value:Number):void
		{
			mediaPlayer.volume = value;
		}		
		
		
		
		[ChangeEvent(event="panChange",type="org.openvideoplayer.events.PanChangeEvent")]
		public function get pan():Number
		{			
			return mediaPlayer.audible ?  mediaPlayer.pan : 0;
		}				
		public function set pan(value:Number):void
		{
			mediaPlayer.pan = value;
		}

				
		/**
		 * Indicates whether the media is currently muted.
		 * <p>The source media element must be audible in order to
		 *  support this property.</p>
		 * 
		 * @throws IllegalOperationError if capability isn't supported
         * @see org.openvideoplayer.traits.IAudible
		 */	
		[ChangeEvent(event="muteChange",type="org.openvideoplayer.events.MuteChangeEvent")]
		public function get muted():Boolean
		{
			return mediaPlayer.audible ?  mediaPlayer.muted : false;
		}
		public function set muted(value:Boolean):void
		{
			mediaPlayer.muted = value;
		}
				
		
		
		/**
		 *  True when the source MediaElement is bufferable.
		 */	
		public function get bufferable():Boolean
		{
			return mediaPlayer.bufferable;
		}
				
		// Trait Based properties
			
		 	
		
		
	    // IPausible
		
		/**
		 * Indicates whether the media is currently paused.
		 * <p>The source media element must be
		 * pausible in order to support this property.</p>
		 * 
		 * @throws IllegalOperationError if capability isn't supported
         * @see org.openvideomediaPlayer.traits.IPausible
		 */	
		public function get paused():Boolean
	    {
	    	return mediaPlayer.paused;	    		    
	    }
	    
		/**
	    * Pauses the media, if it is not already paused.
	    * @throws IllegalOperationError if capability isn't supported
	    */
	    public function pause():void
	    {
	    	mediaPlayer.pause();	    		
	    }
	
	    // IPlayable
			
		/**
		 * Indicates whether the media is currently playing.
		 * <p>The source media element must be
		 * playable in order to support this property.</p>
		 * 
		 * @throws IllegalOperationError if capability isn't supported
         * @see org.openvideoplayer.traits.IPlayable
		 */					
	    public function get playing():Boolean
	    {
	    	return mediaPlayer.playing;	    		
	    }
	    
	    /**
	    * Plays the media, if it is not already playing.
	    * @throws IllegalOperationError if capability isn't supported
	    */
	    public function play():void
	    {
	    	mediaPlayer.play();	    	
	    	mediaPlayer.play();	    	
	    	if(mediaPlayer.playable)
	    	{
	    		mediaPlayer.play();	
	    	}    	
	    }
	
	    // ISeekable
		
		/**
		 * Indicates whether the media is currently seeking.
		 * <p>The source media element must be
		 * seekable in order to support this property.</p>
		 * 
		 * @throws IllegalOperationError if capability isn't supported
         * @see org.openvideoplayer.traits.ISeekable
		 */			

	    public function get seeking():Boolean
	    {
	    	return mediaPlayer.seeking;
	    	return mediaPlayer.seeking;
	    	return mediaPlayer.seekable ? mediaPlayer.seeking : false;
	    	
	    }
	    
	    /**
	    * Instructs the playhead to jump to the specified time.
	    * <p>If <code>time</code> is NaN or negative, does not attempt to seek.</p>
	    * @param time Time to seek to in seconds.
	    * @throws IllegalOperationError if capability isn't supported
	    */	    
	    public function seek(time:Number):void
	    {
	    	mediaPlayer.seek(time);	    				
	    	mediaPlayer.seek(time);	    				
	    	if(mediaPlayer.seekable)
	    	{
	    		mediaPlayer.seek(time);	 
	    	}   				
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
	    	return mediaPlayer.canSeekTo(time);		
	    	return mediaPlayer.canSeekTo(time);		
	    	return mediaPlayer.seekable ? mediaPlayer.canSeekTo(time) : false;		
	    }
			    	    
	    /**
		 * Indicates whether the media is currently buffering.
		 * 
		 * <p>The default is <code>false</code>.</p>
		 * @throws IllegalOperationError if capability isn't supported
		 */		
		
		public function get buffering():Boolean
		{
			return mediaPlayer.buffering;	    	
			return mediaPlayer.buffering;	    	
			return mediaPlayer.bufferable ? mediaPlayer.buffering : false;	    	
		}
		
		/**
		 * The length of the content currently in the media's
		 * buffer in seconds. 
		 * @throws IllegalOperationError if capability isn't supported
		 */		
		public function get bufferLength():Number
		{
			return mediaPlayer.bufferLength;	    	
			return mediaPlayer.bufferLength;	    	
			return mediaPlayer.bufferable ?  mediaPlayer.bufferLength : 0;	    	
		}
		
		/**
		 * The desired length of the media's buffer in seconds.
		 * 
		 * <p>If the passed value is NaN or negative, it
		 * is coerced to zero.</p>
		 * 
		 * <p>The default is zero.</p> 
		 * @throws IllegalOperationError if capability isn't supported
		 */		
		
		public function get bufferTime():Number
		{
			return mediaPlayer.bufferTime;		    	
			return mediaPlayer.bufferTime;		    	
			return  mediaPlayer.bufferable ? mediaPlayer.bufferTime : 0;		    	
		}
		
		public function set bufferTime(value:Number):void
		{
			mediaPlayer.bufferTime = value;	    	
		}
							 
		private function redispatchEvent(event:Event):void
		{	
		 	dispatchEvent(event.clone());
		}
		
		private function audibleChanged(event:MediaPlayerCapabilityChangeEvent):void
		{
			dispatchEvent(new VolumeChangeEvent(0, mediaPlayer.volume));
			dispatchEvent(new PanChangeEvent(0, mediaPlayer.pan));
			dispatchEvent(new MutedChangeEvent(mediaPlayer.muted));			
		}
					
		private function get mediaPlayer():MediaPlayer
		{
			return _player.mediaPlayer;
		}
											
		protected function onView(event:ViewChangeEvent):void
		{
			if(event.oldView)
			{
				removeChild(event.oldView);
			}
			if(event.newView)
			{				
				addChild(mediaPlayer.view);
			}						
			invalidateDisplayList();			
		}
				
		private function redispatch(event:Event):void
		{
			dispatchEvent(event.clone());
		}
					
		protected var _player:MediaPlayerSprite;
	}
}
