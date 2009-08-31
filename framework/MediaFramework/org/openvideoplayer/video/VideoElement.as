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
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.LoadableMediaElement;
	import org.openvideoplayer.net.NetClient;
	import org.openvideoplayer.net.NetLoadedContext;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.net.NetStreamAudibleTrait;
	import org.openvideoplayer.net.NetStreamBufferableTrait;
	import org.openvideoplayer.net.NetStreamCodes;
	import org.openvideoplayer.net.NetStreamPausableTrait;
	import org.openvideoplayer.net.NetStreamPlayableTrait;
	import org.openvideoplayer.net.NetStreamSeekableTrait;
	import org.openvideoplayer.net.NetStreamTemporalTrait;
	import org.openvideoplayer.net.dynamicstreaming.DynamicNetStream;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingResource;
	import org.openvideoplayer.net.dynamicstreaming.NetStreamSwitchableTrait;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	/**
	* VideoElement is a media element specifically created for video playback.
	* It supports both streaming and progressive formats.
	* <p>The VideoElement has IAudible, IBufferable, IPlayable, IPausable,
	* ISeekable, ISpatial, ITemporal, and IViewable traits.
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
		 * @param resource An object implementing IMediaResource that points to the video 
		 * the VideoElement will use.
		 */
		public function VideoElement(loader:NetLoader = null, resource:IMediaResource = null)
		{	
			super(loader, resource);

			// The resource argument must either implement IURLResource or be a DynamicStreamingResource object			
			if (resource != null)
			{
				var urlRes:IURLResource = resource as IURLResource;
				var dynRes:DynamicStreamingResource = resource as DynamicStreamingResource;
				
				if (urlRes == null && dynRes == null) 
				{
					throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
				}
			}
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
	     * @private
		 **/
		override protected function processLoadedState():void
		{
			var loadableTrait:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			var context:NetLoadedContext = NetLoadedContext(loadableTrait.loadedContext);
			stream = context.stream;			
						
			video = new Video();
			video.attachNetStream(stream);
			
			// Hook up our metadata listeners
			NetClient(stream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
		
			var viewable:ViewableTrait = new ViewableTrait();
			viewable.view = video;
			var seekable:SeekableTrait = new NetStreamSeekableTrait(stream);
			var temporal:NetStreamTemporalTrait = new NetStreamTemporalTrait(stream); 
			spatial = new SpatialTrait();
			seekable.temporal = temporal;
					
			addTrait(MediaTraitType.PLAYABLE, new NetStreamPlayableTrait(this, stream, resource));
			addTrait(MediaTraitType.PAUSABLE,  new NetStreamPausableTrait(this, stream));
			addTrait(MediaTraitType.VIEWABLE, viewable);
			addTrait(MediaTraitType.TEMPORAL, temporal);
	    	addTrait(MediaTraitType.SEEKABLE, seekable);
	    	addTrait(MediaTraitType.SPATIAL, spatial);
	    	addTrait(MediaTraitType.AUDIBLE, new NetStreamAudibleTrait(stream));
	    	addTrait(MediaTraitType.BUFFERABLE, new NetStreamBufferableTrait(stream));
	    	
			var dynRes:DynamicStreamingResource = resource as DynamicStreamingResource;
			if (dynRes != null)
			{
				addTrait(MediaTraitType.SWITCHABLE, new NetStreamSwitchableTrait(stream as DynamicNetStream, dynRes));
			}	    	
		}
		
		/**
		 * @private
		 **/
		override protected function processUnloadingState():void
		{
			NetClient(stream.client).removeHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			
			stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent)
			
			removeTrait(MediaTraitType.PLAYABLE);
			removeTrait(MediaTraitType.PAUSABLE);
			removeTrait(MediaTraitType.VIEWABLE);
			removeTrait(MediaTraitType.TEMPORAL);
	    	removeTrait(MediaTraitType.SEEKABLE);
	    	removeTrait(MediaTraitType.SPATIAL);
	    	removeTrait(MediaTraitType.AUDIBLE);
	    	removeTrait(MediaTraitType.BUFFERABLE);
    		removeTrait(MediaTraitType.SWITCHABLE);
	    		    		    	
	    	// Null refs to garbage collect.	    	
			spatial = null;
			video.attachNetStream(null);
			stream = null;
			video = null;		
		}

		private function onMetaData(info:Object):void 
    	{   		
			spatial.setDimensions(info.width, info.height);			
     	}
     	
     	private function onNetStatusEvent(event:NetStatusEvent):void
     	{
     		var error:MediaError = null;
     		
 			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
				case NetStreamCodes.NETSTREAM_FAILED:
					error = new MediaError(MediaErrorCodes.PLAY_FAILED);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND:
					error = new MediaError(MediaErrorCodes.STREAM_NOT_FOUND);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID:
					error = new MediaError(MediaErrorCodes.FILE_STRUCTURE_INVALID);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:
					error = new MediaError(MediaErrorCodes.NO_SUPPORTED_TRACK_FOUND);
					break;
			}
			
			if (error != null)
			{
				dispatchEvent(new MediaErrorEvent(error));
			}
     	}
     	
     	private var stream:NetStream;
     	private var video:Video;	 
	    private var spatial:SpatialTrait;
	}
}

