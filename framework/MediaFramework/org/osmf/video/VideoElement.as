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
package org.osmf.video
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import org.osmf.events.ContentProtectionEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.media.LoadableMediaElement;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.metadata.TemporalFacet;
	import org.osmf.metadata.TemporalFacetEvent;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetLoadedContext;
	import org.osmf.net.NetLoader;
	import org.osmf.net.NetStreamAudibleTrait;
	import org.osmf.net.NetStreamBufferableTrait;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamDownloadableTrait;
	import org.osmf.net.NetStreamPausableTrait;
	import org.osmf.net.NetStreamPlayableTrait;
	import org.osmf.net.NetStreamSeekableTrait;
	import org.osmf.net.NetStreamTemporalTrait;
	import org.osmf.net.dynamicstreaming.DynamicNetStream;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.net.dynamicstreaming.NetStreamSwitchableTrait;
	import org.osmf.traits.IContentProtectable;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SeekableTrait;
	import org.osmf.traits.SpatialTrait;
	import org.osmf.traits.ViewableTrait;
	import org.osmf.utils.MediaFrameworkStrings;

	
	CONFIG::FLASH_10_1
	{
	import flash.events.DRMAuthenticateEvent;
	import flash.events.DRMErrorEvent;
	import flash.events.DRMStatusEvent;
	import flash.net.drm.DRMContentData;	
	import flash.system.SystemUpdaterType;
	import flash.system.SystemUpdater;
	
	import org.osmf.net.NetStreamContentProtectableTrait;
	}
	
	/**
	* VideoElement is a media element specifically created for video playback.
	* It supports both streaming and progressive formats.
	* <p>The VideoElement uses a NetLoader class to load and unload its media.
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
	* @see org.osmf.net.NetLoader
	* @see org.osmf.media.IURLResource
	* @see org.osmf.media.MediaElement
	* @see org.osmf.traits
	**/

	public class VideoElement extends LoadableMediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param loader Loader used to load the video.
		 * @param resource An object implementing IMediaResource that points to the video 
		 * the VideoElement will use.
		 * 
		 * @throws ArgumentError If loader is null, or resource is neither an
		 * IURLResource nor a DynamicStreamingResource.
		 */
		public function VideoElement(loader:NetLoader, resource:IMediaResource=null)
		{	
			super(loader, resource);
			
			// The resource argument must either implement IURLResource or be
			// a DynamicStreamingResource object			
			if (resource != null)
			{
				var urlResource:IURLResource = resource as IURLResource;
				var dsResource:DynamicStreamingResource = resource as DynamicStreamingResource;
				
				if (urlResource == null && dsResource == null) 
				{
					throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
				}
			}
		}
		       	
       	/**
       	 * The NetClient used by this VideoElement's NetStream.  Available after the 
       	 * element has been loaded.
       	 *  
       	 *  @langversion 3.0
       	 *  @playerversion Flash 10
       	 *  @playerversion AIR 1.0
       	 *  @productversion OSMF 1.0
       	 */ 
       	public function get client():NetClient
       	{
       		return stream.client as NetClient;
       	}           
       	     
	    /**
	     * @private
		 **/
		override protected function processReadyState():void
		{
			var loadableTrait:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			var context:NetLoadedContext = NetLoadedContext(loadableTrait.loadedContext);
			stream = context.stream;			
			
			// Set the video's dimensions so that it doesn't appear at the wrong size.
			// We'll set the correct dimensions once the metadata is loaded.  (FM-206)
			video = new Video();
			video.width = video.height = 0;
			video.attachNetStream(stream);
			
			// Hook up our metadata listeners
			NetClient(stream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			NetClient(stream.client).addHandler(NetStreamCodes.ON_CUE_POINT, onCuePoint);
						
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
						
			CONFIG::FLASH_10_1
    		{
    			// Listen for all errors
    			stream.addEventListener(DRMErrorEvent.DRM_ERROR, onDRMErrorEvent);
    						    			 			
    			// DRMContent data Sidecar
    			var metadataFacet:KeyValueFacet = resource.metadata.getFacet(MetadataNamespaces.DRM_METADATA) as KeyValueFacet;
    			if (metadataFacet != null)
    			{    				
    				var metadata:ByteArray = metadataFacet.getValue(new ObjectIdentifier(MediaFrameworkStrings.DRM_CONTENT_METADATA_KEY));
    				addProtectableTrait(metadata).addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, onMetadataAuth);	   
    				return;  //Don't add traits until the "auth" has completed. 			
	    		}
	    		else
	    		{
	    			// Non sidecar
    				stream.addEventListener(StatusEvent.STATUS, onStatus);
	    		}			
    		}
			finishLoad();			
		}
		
		// DRM APIs
		CONFIG::FLASH_10_1
    	{
  			private function onStatus(event:StatusEvent):void
			{
				if (event.code == MediaFrameworkStrings.DRM_STATUS_CODE 
					&& getTrait(MediaTraitType.CONTENT_PROTECTABLE) == null)
				{			
					createProtectableTrait().addEventListener(ContentProtectionEvent.AUTHENTICATION_COMPLETE, reloadAfterAuth);	  			
	    		}
	  		}
	  		
	  		// Inline metadata + credentials.  The NetStream is dead at this point, restart with new credentials
	  		private function reloadAfterAuth(event:ContentProtectionEvent):void
	  		{	  				  			
	  			ILoadable(getTrait(MediaTraitType.LOADABLE)).unload();	  	
	  			ILoadable(getTrait(MediaTraitType.LOADABLE)).load();  		  					
	  		}	
			
			private function createProtectableTrait():NetStreamContentProtectableTrait
			{				
				var protectableTrait:NetStreamContentProtectableTrait = new NetStreamContentProtectableTrait();		    	
		    	addTrait(MediaTraitType.CONTENT_PROTECTABLE, protectableTrait);	
		    	return protectableTrait;	    			
			}	
			
			private function addProtectableTrait(contentData:ByteArray):IContentProtectable
			{			
	    		var trait:NetStreamContentProtectableTrait = createProtectableTrait();
			   	trait.drmMetadata = contentData;
			   	return trait;
			}
							
			private function onDRMErrorEvent(event:DRMErrorEvent):void
			{
				if (event.errorID == MediaErrorCodes.DRM_NEEDS_AUTHENTICATION)  //Needs authentication
				{					
					NetStreamContentProtectableTrait(getTrait(MediaTraitType.CONTENT_PROTECTABLE)).drmMetadata = event.contentData;
				}
				else
				{					
					dispatchEvent
						( new MediaErrorEvent
							( MediaErrorEvent.MEDIA_ERROR
							, false
							, false
							, new MediaError(event.errorID)
							)
						);
				}				
			}	
			
			private function onMetadataAuth(event:Event):void
			{
				finishLoad();	
			}	
		}
			
		
		private function finishLoad():void
		{
			var loadableTrait:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			var context:NetLoadedContext = NetLoadedContext(loadableTrait.loadedContext);

			var viewable:ViewableTrait = new ViewableTrait();
			viewable.view = video;
			var seekable:SeekableTrait = new NetStreamSeekableTrait(stream);
			var temporal:NetStreamTemporalTrait = new NetStreamTemporalTrait(stream, resource); 
			spatial = new SpatialTrait();
			spatial.setDimensions(video.width, video.height);
			seekable.temporal = temporal;
					
			addTrait(MediaTraitType.PLAYABLE, new NetStreamPlayableTrait(this, stream, resource));
			addTrait(MediaTraitType.PAUSABLE,  new NetStreamPausableTrait(this, stream));
			addTrait(MediaTraitType.VIEWABLE, viewable);
			addTrait(MediaTraitType.TEMPORAL, temporal);
	    	addTrait(MediaTraitType.SEEKABLE, seekable);
	    	addTrait(MediaTraitType.SPATIAL, spatial);
	    	addTrait(MediaTraitType.AUDIBLE, new NetStreamAudibleTrait(stream));
	    	addTrait(MediaTraitType.BUFFERABLE, new NetStreamBufferableTrait(stream));

			// NetStreamDownloadableTrait will only be added when it is a progressive video.
			if (isProgressiveVideo(context))
			{
	    		addTrait(MediaTraitType.DOWNLOADABLE, new NetStreamDownloadableTrait(stream));
	  		}
	    	
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
	    	
	    	CONFIG::FLASH_10_1
    		{    			
    			stream.removeEventListener(DRMErrorEvent.DRM_ERROR, onDRMErrorEvent);
    			stream.removeEventListener(StatusEvent.STATUS, onStatus);
    			removeTrait(MediaTraitType.CONTENT_PROTECTABLE);    					
    		}
    		
    		removeTrait(MediaTraitType.DOWNLOADABLE);
	    		    		    	
	    	// Null refs to garbage collect.	    	
			spatial = null;
			video.attachNetStream(null);
			stream = null;
			video = null;		
		}

		private function isProgressiveVideo(context:NetLoadedContext):Boolean
		{
			var protocol:String = context.resource.url.protocol;
			
			if (protocol == null || protocol.length <= 0)
			{
				return true;
			}
			
			return (protocol.indexOf("rtmp") < 0);
		}
		
		private function onMetaData(info:Object):void 
    	{   
    		if 	(	info.width != spatial.width
    			||	info.height != spatial.height
    			)
    		{	
    			video.width = info.width;
    			video.height = info.height;
    				
				spatial.setDimensions(info.width, info.height);
    		}
    		
			var cuePoints:Array = info.cuePoints;
			
			if (cuePoints != null && cuePoints.length > 0)
			{
				var temporalFacetDynamic:TemporalFacet = new TemporalFacet(MetadataNamespaces.TEMPORAL_METADATA_DYNAMIC, this);
				
				for (var i:int = 0; i < cuePoints.length; i++)
				{
					var cuePoint:CuePoint = new CuePoint(CuePointType.fromString(cuePoints[i].type), cuePoints[i].time, 
																					cuePoints[i].name, cuePoints[i].parameters);
					temporalFacetDynamic.addValue(cuePoint);
				}
				
				metadata.addFacet(temporalFacetDynamic);			
			}			    		
     	}
     	
     	private function onCuePoint(info:Object):void
     	{
     		if (_temporalFacetEmbedded == null)
     		{
				_temporalFacetEmbedded = new TemporalFacet(MetadataNamespaces.TEMPORAL_METADATA_EMBEDDED, this);
				metadata.addFacet(_temporalFacetEmbedded);
     		}

			var cuePoint:CuePoint = new CuePoint(CuePointType.fromString(info.type), info.time, info.name, info.parameters);
			_temporalFacetEmbedded.dispatchEvent(new TemporalFacetEvent(TemporalFacetEvent.POSITION_REACHED, cuePoint));     		
     	}     	
     	     	
     	// Fired when the DRM subsystem is updated.  NetStream needs to be recreated.
     	private function onUpdateComplete(event:Event):void
     	{     		
    		(getTrait(MediaTraitType.LOADABLE) as ILoadable).unload();
    		(getTrait(MediaTraitType.LOADABLE) as ILoadable).load();		
     	}
     	
     	private function onUpdateError(event:Event):void
     	{     	
     		dispatchEvent(new ErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, "Error Updating DRM: " + event.toString()));
     		(getTrait(MediaTraitType.LOADABLE) as ILoadable).unload();
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
			
			CONFIG::FLASH_10_1
			{
				switch (event.info.code)
				{
					case NetStreamCodes.NETSTREAM_DRM_UPDATE:
		     			var drmUpdater:SystemUpdater = new SystemUpdater();
		     			drmUpdater.addEventListener(Event.COMPLETE, onUpdateComplete);
		     			drmUpdater.addEventListener(IOErrorEvent.IO_ERROR, onUpdateError);
		     			drmUpdater.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUpdateError);
		     			drmUpdater.addEventListener(Event.CANCEL, onUpdateError);
		     			drmUpdater.update(SystemUpdaterType.DRM);   
		     			break;				
	    		}
			}
						
			if (error != null)
			{
				dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, error));
			}
     	}
     	
     	/**
     	 * NetStream used to stream content for this video element.
     	 */ 
     	private var stream:NetStream;
     	
      	private var video:Video;	 
	    private var spatial:SpatialTrait;
	    
		private var _temporalFacetEmbedded:TemporalFacet;	// facet for cue points embedded in the stream	    		    
	}
}
