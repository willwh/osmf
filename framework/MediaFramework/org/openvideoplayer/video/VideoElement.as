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
package org.openvideoplayer.video
{
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.openvideoplayer.events.PausedChangeEvent;
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.LoadableMediaElement;
	import org.openvideoplayer.net.*;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	
	/**
	* VideoElement is a media element specifically created for video playback.
	* It supports both streaming and progressive formats.
	* <p>The VideoElement has IAudible, IBufferable, IPlayable, ISeekable, 
	* ISpatial, and IViewable traits.
	* It uses a NetLoader class to load and unload its media.
	* Developers requiring custom loading logic for video
	* can pass their own loaders to the VideoElement constructor. 
	* These loaders should subclass NetLoader.</p>
	* <p>The basic steps for creating and using a VideoElement are:
	* <ol>
	* <li>Create a new IURLResource pointing to the URL of the video stream or file
	* containing the video to be loaded.</li>
	* <li>Create a new NetLoader.</li>
	* <li>Create the new VideoElement, 
	* passing the NetLoader and IURLResource
	* as parameters.</li>
	* <li>Get the VideoElement's ILoadable trait using the 
	* <code>MediaElement.getTrait(LOADABLE)</code> method.</li>
	* <li>Load the video using the ILoadable's <code>load()</code> method.</li>
	* <li>Control the media using the VideoElement's traits and handle its trait
	* change events.</li>
	* <li>When done with the VideoElement, unload the video using the  
	* using the ILoadable's <code>unload()</code> method.</li>
	* </ol>
	* </p>
	* 
	* @see org.openvideoplayer.net.NetLoader
	* @see org.openvideoplayer.media.IURLResource
	* @see org.openvideoplayer.media.MediaElement
	* @see org.openvideoplayer.traits
	**/

	public class VideoElement extends LoadableMediaElement
	{
		/**
		 * The constructor takes two optional parameters that can also be passed to the
		 * VideoElement's internal <code>initialize()</code> method.
		 * @param loader Loader used to load the video.
		 * @param resource The url that points to the video that the VideoElement will use.
		 */
		public function VideoElement(loader:NetLoader = null, resource:IURLResource = null )
		{	
			super(loader, resource);																	
		}
       	
       	/**
       	 * The NetClient used by this VideoElement's NetStream.  Available after the 
       	 * element has been loaded.
       	 */ 
       	public function get client():NetClient
       	{
       		return stream.client as NetClient;
       	}           
       	     
	    /**
	     * 
	     * @private
	     * 
	     * Processes the VideoElement after it has entered the LOADED state.
	     * <p>
	     * This processing includes:
	     * <ul>
	     * 
	     * <li> Creating a Video object.</li>
	     * 
	     * <li> Attaching the NetStream obtained from the VideoLoadedContext to the Video object.</li>
	     * 
	     * <li> Creating Audible, Bufferable, Pausible, Playable, Seekable, Spatial,
	     * Temporal, and Viewable traits for use by this VideoElement.</li>
	     * 
	     * <li> Assigning the Video object to the Viewable trait's <code>view</code> property. 
	     * This designates the video as the DisplayObject that represents this video element
	     * on the screen.</li>
	     * 
	     * <li> Assigning the Temporal trait to the Seekable trait's.
	     * <code>temporal</code> property. The Seekable trait's <code>temporal</code> property
	     * must be assigned to enable seeking.</li>
	     * 
	     * <li> Adding all the traits to the VideoElement.</li>
	     * 
	     * <li> Adding event listeners for some of the traits' change events.</li>
	     * 
	     * <li> Setting the VideoElement's state to READY, indicating that the element is 
	     * ready to be used.</li>
	     * 
	     * </ul>
	     * </p>
	     * <p> Use the VideoElement's <code>addTrait()</code> method to add a trait to the element.
	     * Use its <code>setState()</code> method to set the element's state.
	     * </p>
	     * 
		 * @inheritDoc
		 * @see VideoLoader
		 * @see org.openvideoplayer.traits
		 * @see org.openvideoplayer.media.MediaElement
		 * @see flash.media.Video
		 * @see flash.net.NetStream
		 **/
		override protected function processLoadedState():void
		{
			var loadableTrait:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			var context:NetLoadedContext = NetLoadedContext(loadableTrait.loadedContext);
			stream = context.stream;			
						
			var video:Video = new Video();
			
			video.attachNetStream( stream );
			// Hook up our metadata listeners for spatial
			NetClient(stream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
		
			playable = new NetStreamPlayableTrait(stream, resource as IURLResource); 
			pausible = new NetStreamPausibleTrait(stream);			
			playable.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);						
			pausible.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);
			viewable = new ViewableTrait();
			viewable.view = video;
			seekable = new NetStreamSeekableTrait(stream);
			temporal = new NetStreamTemporalTrait(stream); 
			spatial = new SpatialTrait();
			seekable.temporal = temporal;
			audible = new NetStreamAudibleTrait(stream);
			bufferable = new NetStreamBufferableTrait(stream); 
						
			addTrait(MediaTraitType.PLAYABLE, playable);
			addTrait(MediaTraitType.PAUSIBLE, pausible);
			addTrait(MediaTraitType.VIEWABLE, viewable);
			addTrait(MediaTraitType.TEMPORAL, temporal);
	    	addTrait(MediaTraitType.SEEKABLE, seekable);
	    	addTrait(MediaTraitType.SPATIAL, spatial);
	    	addTrait(MediaTraitType.AUDIBLE, audible);
	    	addTrait(MediaTraitType.BUFFERABLE, bufferable);	    	
		}
		
		/**
		 * @private
		 * 
		 * Processes the VideoElement after it has entered the UNLOADING state.
	     * <p>This processing includes:
	     * 
	     * <ul> 
	     * 
	     * <li>Unregistering the NetStream function for this video source.</li>
	     * <li> Removing event listeners previously added for the traits' change events.</li>
	     * <li> Removing all the traits from the VideoElement.</li>
	     * <li> Setting the VideoElement's state to CONSTRUCTED, indicating that the element is 
	     * not ready to be used.</li>
	     * 
	     * </ul>
	     * 
	     * </p>
	     * <p> Use the VideoElement's <code>removeTrait()</code> method to remove a trait from the element.
	     * Use its <code>setState()</code> method to set the element's state.
	     * </p>
	     * 
		 * 
		 *  @inheritDoc
		 **/
		override protected function processUnloadingState():void
		{
			var loadableTrait:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			var context:NetLoadedContext = NetLoadedContext(loadableTrait.loadedContext);
							
			NetClient(stream.client).removeHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			playable.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);						
			pausible.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);
			removeTrait(MediaTraitType.PLAYABLE);
			removeTrait(MediaTraitType.PAUSIBLE);
			removeTrait(MediaTraitType.VIEWABLE);
			removeTrait(MediaTraitType.TEMPORAL);
	    	removeTrait(MediaTraitType.SEEKABLE);
	    	removeTrait(MediaTraitType.SPATIAL);
	    	removeTrait(MediaTraitType.AUDIBLE);
	    	removeTrait(MediaTraitType.BUFFERABLE);
	    		    	
	    	// Null refs to garabage collect these.
	    	viewable = null;			
			seekable = null;
			temporal = null;
			playable = null;
			pausible = null;
			bufferable = null;			
		}
		
		/**
		 * Event handler for the Playable trait's playingChange event.
		 **/
		private function onPlayingChanged(event:PlayingChangeEvent):void
		{
			if (event.playing && pausible.paused)
			{
				pausible.resetPaused();
			}			
		}
		
		/**
		 * Event handler for the Pausible trait's pausedChange event.
		 **/		
		private function onPausedChanged(event:PausedChangeEvent):void
		{
			if (event.paused && playable.playing)
			{				
				playable.resetPlaying();
			}			
		}
	
		private function onMetaData(info:Object):void 
    	{			
			spatial.setDimensions(info.width, info.height);			 	
     	}
     	
     	// Stream
     	private var stream:NetStream;
     		 
	 	// Traits	 	
	 	private var bufferable:NetStreamBufferableTrait;
	 	private var audible:NetStreamAudibleTrait;
	 	private var temporal:NetStreamTemporalTrait;
	 	private var seekable:NetStreamSeekableTrait;	 	
	 	private var viewable:ViewableTrait;
	    private var playable:NetStreamPlayableTrait;
	    private var pausible:NetStreamPausibleTrait;
	    private var spatial:SpatialTrait;
	}
}

