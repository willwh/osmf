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
package org.osmf.gg
{
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.metadata.*;
	import org.osmf.proxies.*;
	import org.osmf.traits.*;
	
	/**
	 * A ProxyElement which tracks media playback and publishes events to
	 * GlanceGuide via the GlanceGuide SWF.  Works with any MediaElement, not
	 * just VideoElement.
	 **/
	public class GGVideoProxyElement extends ProxyElement
	{
		/**
		 * Constructor.
		 **/
		public function GGVideoProxyElement(wrappedElement:MediaElement=null)
		{
			super(wrappedElement);
		}
		
		override public function set wrappedElement(value:MediaElement):void
		{
			var traitType:MediaTraitType
			
			if (wrappedElement != null)
			{
				// Clear our old listeners.
				wrappedElement.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				wrappedElement.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);

				for each (traitType in wrappedElement.traitTypes)
				{
					processTrait(traitType, false);
				}
			}
			
			super.wrappedElement = value;
			
			if (value != null)
			{
				// Listen for traits being added and removed.
				wrappedElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				wrappedElement.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
			
				for each (traitType in wrappedElement.traitTypes)
				{
					processTrait(traitType, true);
				}
			}
		}
		
		// Internals
		//
		
		private function onTraitAdd(event:MediaElementEvent):void
		{
			processTrait(event.traitType, true);
		}

		private function onTraitRemove(event:MediaElementEvent):void
		{
			processTrait(event.traitType, false);
		}
		
		private function processTrait(traitType:MediaTraitType, added:Boolean):void
		{
			switch (traitType)
			{
				case MediaTraitType.AUDIBLE:
					toggleAudibleListeners(added);
					break;
				case MediaTraitType.LOADABLE:
					toggleLoadableListeners(added);
					break;
				case MediaTraitType.PAUSABLE:
					togglePausableListeners(added);
					break;
				case MediaTraitType.PLAYABLE:
					togglePlayableListeners(added);
					break;
				case MediaTraitType.SEEKABLE:
					toggleSeekableListeners(added);
					break;
				case MediaTraitType.TEMPORAL:
					toggleTemporalListeners(added);
					break;
			}
		}
		
		private function toggleAudibleListeners(added:Boolean):void
		{
			var audible:IAudible = wrappedElement.getTrait(MediaTraitType.AUDIBLE) as IAudible;
			if (audible)
			{
				if (added)
				{
					audible.addEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
					audible.addEventListener(AudioEvent.MUTED_CHANGE, onMutedChange);
				}
				else
				{
					audible.removeEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
					audible.removeEventListener(AudioEvent.MUTED_CHANGE, onMutedChange);
				}
			}
		}
		
		private function toggleLoadableListeners(added:Boolean):void
		{
			var loadable:ILoadable = wrappedElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			if (loadable)
			{
				if (added)
				{
					loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
				}
				else
				{
					loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
				}
			}
		}

		private function togglePausableListeners(added:Boolean):void
		{
			var pausable:IPausable = wrappedElement.getTrait(MediaTraitType.PAUSABLE) as IPausable;
			if (pausable)
			{
				if (added)
				{
					pausable.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
				}
				else
				{
					pausable.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChange);
				}
			}
		}
	
		private function togglePlayableListeners(added:Boolean):void
		{
			var playable:IPlayable = wrappedElement.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
			if (playable)
			{
				if (added)
				{
					playable.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
				}
				else
				{
					playable.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChange);
				}
			}
		}
		
		private function toggleSeekableListeners(added:Boolean):void
		{
			var seekable:ISeekable = wrappedElement.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			if (seekable)
			{
				if (added)
				{
					seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChange);
				}
				else
				{
					seekable.removeEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChange);
				}
			}
		}

		private function toggleTemporalListeners(added:Boolean):void
		{
			var temporal:ITemporal = wrappedElement.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			if (temporal)
			{
				if (added)
				{
					temporal.addEventListener(TimeEvent.DURATION_REACHED, onDurationReached);
				}
				else
				{
					temporal.removeEventListener(TimeEvent.DURATION_REACHED, onDurationReached);
				}
			}
		}
		
		// Tracking Methods
		//
		
		private function onVolumeChange(event:AudioEvent):void
		{
			// Volume parameters must be between 1 and 100, inclusive.
			sendEvent(SET_VOLUME, Math.max(1, event.volume * 100));
		}

		private function onMutedChange(event:AudioEvent):void
		{
			sendEvent(MUTE, event.muted);
		}

		private function onLoadStateChange(event:LoadEvent):void
		{
			var videoType:String;
			
			switch (event.loadState)
			{
				case LoadState.UNINITIALIZED:
					if (lastLoadState == LoadState.UNLOADING)
					{
						// The call to UNLOAD_VIDEO has two optional params.
						//
						
						videoType = getContentTypeFromMetadata(wrappedElement.resource.metadata);
						
						sendEvent(UNLOAD_VIDEO, currentTime, videoType);
					}
					break;
				case LoadState.READY:
					// The call to LOAD_VIDEO has three required params.
					//
					
					// URL of the video:
					var urlResource:URLResource = wrappedElement.resource as URLResource; 
					var url:String = urlResource != null ? urlResource.url.rawUrl : null;
					
					// Type of the video:
					videoType = getContentTypeFromMetadata(wrappedElement.resource.metadata);
					
					// Metadata about the video:
					var videoInfo:String = getVideoInfoFromMetadata(wrappedElement.resource.metadata);
					
					sendEvent(LOAD_VIDEO, url, videoType, videoInfo);
					break;
			}
			
			lastLoadState = event.loadState;
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			if (event.playing)
			{
				sendEvent(PLAY_VIDEO, currentTime);
				trace("play: " + currentTime);
			}
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			if (event.paused)
			{
				sendEvent(PAUSE_VIDEO, currentTime);
				trace("pause: " + currentTime);
			}
		}

		private function onSeekingChange(event:SeekingChangeEvent):void
		{
			if (event.seeking)
			{
				sendEvent(SEEK, currentTime, event.time);
			}
		}
		
		private function onDurationReached(event:TimeEvent):void
		{
			sendEvent(STOP, currentTime);
		}

		// Utility Methods
		//
		
		private function get currentTime():Number
		{
			var temporal:ITemporal = getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			return temporal != null ? temporal.currentTime : 0;
		}

		private function get duration():Number
		{
			var temporal:ITemporal = getTrait(MediaTraitType.TEMPORAL) as ITemporal;
			return temporal != null ? temporal.duration : 0;
		}
		
		private function getContentTypeFromMetadata(metadata:Metadata):String
		{
			// Typically, we'll work with a specific metadata schema (facet)
			// here in order to get the content type field.  But for this
			// simple sample app, I'll just hardcode it.
			return "content";
		}

		private function getVideoInfoFromMetadata(metadata:Metadata):String
		{
			// Typically, we'll work with a specific metadata schema (facet)
			// here in order to get the video info.  Some of the metadata can
			// be retrieved from the traits.  For the rest, I'll hardcode it.
			
			var xml:XML = 
				<videoInfo>
					<length>{duration}</length>
					<title>Sample Title</title>
				</videoInfo>
				
			return xml.toXMLString();
		}
		
		private function sendEvent(eventType:int, ...params):void
		{
			// Uncomment the following line to integrate with the GlanceGuide
			// library.  Note that to do so, you'll need to link in the
			// GlanceGuide source or SWC, or else this class will fail to
			// compile.
			//ggCom.getInstance().PM(eventType, params);
		}
		
		// PM Constants
		//
		
		private var lastLoadState:String;
		
		private static const LOAD_VIDEO:int 	= 3;
		private static const UNLOAD_VIDEO:int 	= 4;
		private static const PLAY_VIDEO:int 	= 5;
		private static const PAUSE_VIDEO:int 	= 6;
		private static const STOP:int 			= 7;
		private static const SEEK:int		 	= 8;
		private static const MUTE:int 			= 9;
		private static const SET_VOLUME:int 	= 11;
	}
}