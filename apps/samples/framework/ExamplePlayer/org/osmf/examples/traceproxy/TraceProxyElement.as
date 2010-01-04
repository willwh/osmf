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
package org.osmf.examples.traceproxy
{
	import org.osmf.events.*;
	import org.osmf.media.*;
	import org.osmf.metadata.*;
	import org.osmf.proxies.*;
	import org.osmf.traits.*;
	
	/**
	 * A ProxyElement which traces all media events to the console.  This class
	 * demonstrates how to non-invasively layer functionality on top of another
	 * MediaElement.
	 **/
	public class TraceProxyElement extends ProxyElement
	{
		/**
		 * Constructor.
		 **/
		public function TraceProxyElement(wrappedElement:MediaElement=null)
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
				case MediaTraitType.BUFFERABLE:
					toggleBufferableListeners(added);
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
				case MediaTraitType.SPATIAL:
					toggleSpatialListeners(added);
					break;
				case MediaTraitType.SWITCHABLE:
					toggleSwitchableListeners(added);
					break;
				case MediaTraitType.TEMPORAL:
					toggleTemporalListeners(added);
					break;
				case MediaTraitType.DISPLAY_OBJECTABLE:
					toggleViewableListeners(added);
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
					audible.addEventListener(AudioEvent.PAN_CHANGE, onPanChange);
				}
				else
				{
					audible.removeEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
					audible.removeEventListener(AudioEvent.MUTED_CHANGE, onMutedChange);
					audible.removeEventListener(AudioEvent.PAN_CHANGE, onPanChange);
				}
			}
		}

		private function toggleBufferableListeners(added:Boolean):void
		{
			var bufferable:IBufferable = wrappedElement.getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
			if (bufferable)
			{
				if (added)
				{
					bufferable.addEventListener(BufferingChangeEvent.BUFFERING_CHANGE, onBufferingChange);
					bufferable.addEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
				}
				else
				{
					bufferable.removeEventListener(BufferingChangeEvent.BUFFERING_CHANGE, onBufferingChange);
					bufferable.removeEventListener(BufferTimeChangeEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
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
					seekable.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
				}
				else
				{
					seekable.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
				}
			}
		}

		private function toggleSpatialListeners(added:Boolean):void
		{
			var spatial:ISpatial = wrappedElement.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			if (spatial)
			{
				if (added)
				{
					spatial.addEventListener(DimensionEvent.DIMENSION_CHANGE, onDimensionChange);
				}
				else
				{
					spatial.removeEventListener(DimensionEvent.DIMENSION_CHANGE, onDimensionChange);
				}
			}
		}
		private function toggleSwitchableListeners(added:Boolean):void
		{
			var switchable:ISwitchable = wrappedElement.getTrait(MediaTraitType.SWITCHABLE) as ISwitchable;
			if (switchable)
			{
				if (added)
				{
					switchable.addEventListener(SwitchEvent.SWITCHING_CHANGE, onSwitchingChange);
				}
				else
				{
					switchable.removeEventListener(SwitchEvent.SWITCHING_CHANGE, onSwitchingChange);
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
					temporal.addEventListener(TimeEvent.COMPLETE, onComplete);
					temporal.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
				}
				else
				{
					temporal.removeEventListener(TimeEvent.COMPLETE, onComplete);
					temporal.removeEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
				}
			}
		}
		
		private function toggleViewableListeners(added:Boolean):void
		{
			var viewable:IViewable = wrappedElement.getTrait(MediaTraitType.DISPLAY_OBJECTABLE) as IViewable;
			if (viewable)
			{
				if (added)
				{
					viewable.addEventListener(ViewEvent.VIEW_CHANGE, onViewChange);
				}
				else
				{
					viewable.removeEventListener(ViewEvent.VIEW_CHANGE, onViewChange);
				}
			}
		}

		// Event Methods
		//
		
		private function onVolumeChange(event:AudioEvent):void
		{
			trace("VolumeChangeEvent: " + event.volume);
		}

		private function onMutedChange(event:AudioEvent):void
		{
			trace("MutedChangeEvent: " + (event.muted ? "muted" : "unmuted"));
		}

		private function onPanChange(event:AudioEvent):void
		{
			trace("PanChangeEvent: " + event.pan);
		}
		
		private function onBufferingChange(event:BufferingChangeEvent):void
		{
			trace("BufferingChangeEvent: " + (event.buffering ? "buffering" : "not buffering"));
		}

		private function onBufferTimeChange(event:BufferTimeChangeEvent):void
		{
			trace("BufferTimeChangeEvent: " + event.oldTime + " -> " + event.newTime);
		}

		private function onLoadStateChange(event:LoadEvent):void
		{
			trace("LoadEvent: " + event.oldState.toString() + " -> " + event.newState.toString());
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			trace("PlayingChangeEvent: " + (event.playing ? "playing" : "not playing"));
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			trace("PausedChangeEvent: " + (event.paused ? "paused" : "not paused"));
		}

		private function onSeekingChange(event:SeekEvent):void
		{
			trace("SeekingChangeEvent: " + (event.seeking ? "seeking" : "not seeking") + " at " + event.time);
		}
		
		private function onComplete(event:TimeEvent):void
		{
			trace("CompleteEvent");
		}

		private function onDurationChange(event:TimeEvent):void
		{
			trace("DurationChangeEvent: " + event.time);
		}

		private function onDimensionChange(event:DimensionEvent):void
		{
			trace("DimensionChangeEvent: " + event.oldWidth + "x" + event.oldHeight + " -> " + event.newWidth + "x" + event.newHeight);
		}
		
		private function onSwitchingChange(event:SwitchEvent):void
		{
			trace("SwitchingChangeEvent: " + event.oldState + " -> " + event.newState);
		}	

		private function onViewChange(event:ViewEvent):void
		{
			trace("ViewChangeEvent: " + event.oldView.toString() + " -> " + event.newView.toString());
		}
	}
}