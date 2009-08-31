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
package org.openvideoplayer.examples.traceproxy
{
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.metadata.*;
	import org.openvideoplayer.proxies.*;
	import org.openvideoplayer.traits.*;
	
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
				wrappedElement.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				wrappedElement.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);

				for each (traitType in wrappedElement.traitTypes)
				{
					processTrait(traitType, false);
				}
			}
			
			super.wrappedElement = value;
			
			if (value != null)
			{
				// Listen for traits being added and removed.
				wrappedElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				wrappedElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
			
				for each (traitType in wrappedElement.traitTypes)
				{
					processTrait(traitType, true);
				}
			}
		}
		
		// Internals
		//
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			processTrait(event.traitType, true);
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
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
				case MediaTraitType.VIEWABLE:
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
					audible.addEventListener(VolumeChangeEvent.VOLUME_CHANGE, onVolumeChange);
					audible.addEventListener(MutedChangeEvent.MUTED_CHANGE, onMutedChange);
					audible.addEventListener(PanChangeEvent.PAN_CHANGE, onPanChange);
				}
				else
				{
					audible.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
					audible.removeEventListener(MutedChangeEvent.MUTED_CHANGE, onMutedChange);
					audible.removeEventListener(PanChangeEvent.PAN_CHANGE, onPanChange);
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
					loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
				}
				else
				{
					loadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
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

		private function toggleSpatialListeners(added:Boolean):void
		{
			var spatial:ISpatial = wrappedElement.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			if (spatial)
			{
				if (added)
				{
					spatial.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensionChange);
				}
				else
				{
					spatial.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensionChange);
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
					switchable.addEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onSwitchingChange);
				}
				else
				{
					switchable.removeEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onSwitchingChange);
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
					temporal.addEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
					temporal.addEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChange);
				}
				else
				{
					temporal.removeEventListener(TraitEvent.DURATION_REACHED, onDurationReached);
					temporal.removeEventListener(DurationChangeEvent.DURATION_CHANGE, onDurationChange);
				}
			}
		}
		
		private function toggleViewableListeners(added:Boolean):void
		{
			var viewable:IViewable = wrappedElement.getTrait(MediaTraitType.VIEWABLE) as IViewable;
			if (viewable)
			{
				if (added)
				{
					viewable.addEventListener(ViewChangeEvent.VIEW_CHANGE, onViewChange);
				}
				else
				{
					viewable.removeEventListener(ViewChangeEvent.VIEW_CHANGE, onViewChange);
				}
			}
		}

		// Event Methods
		//
		
		private function onVolumeChange(event:VolumeChangeEvent):void
		{
			trace("VolumeChangeEvent: " + event.oldVolume + " -> " + event.newVolume);
		}

		private function onMutedChange(event:MutedChangeEvent):void
		{
			trace("MutedChangeEvent: " + (event.muted ? "muted" : "unmuted"));
		}

		private function onPanChange(event:PanChangeEvent):void
		{
			trace("PanChangeEvent: " + event.oldPan + " -> " + event.newPan);
		}
		
		private function onBufferingChange(event:BufferingChangeEvent):void
		{
			trace("BufferingChangeEvent: " + (event.buffering ? "buffering" : "not buffering"));
		}

		private function onBufferTimeChange(event:BufferTimeChangeEvent):void
		{
			trace("BufferTimeChangeEvent: " + event.oldTime + " -> " + event.newTime);
		}

		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			trace("LoadableStateChangeEvent: " + event.oldState.toString() + " -> " + event.newState.toString());
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			trace("PlayingChangeEvent: " + (event.playing ? "playing" : "not playing"));
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			trace("PausedChangeEvent: " + (event.paused ? "paused" : "not paused"));
		}

		private function onSeekingChange(event:SeekingChangeEvent):void
		{
			trace("SeekingChangeEvent: " + (event.seeking ? "seeking" : "not seeking") + " at " + event.time);
		}
		
		private function onDurationReached(event:TraitEvent):void
		{
			trace("DurationReachedEvent");
		}

		private function onDurationChange(event:DurationChangeEvent):void
		{
			trace("DurationChangeEvent: " + event.oldDuration + " -> " + event.newDuration);
		}

		private function onDimensionChange(event:DimensionChangeEvent):void
		{
			trace("DimensionChangeEvent: " + event.oldWidth + "x" + event.oldHeight + " -> " + event.newWidth + "x" + event.newHeight);
		}
		
		private function onSwitchingChange(event:SwitchingChangeEvent):void
		{
			trace("SwitchingChangeEvent: " + event.oldState + " -> " + event.newState);
		}	

		private function onViewChange(event:ViewChangeEvent):void
		{
			trace("ViewChangeEvent: " + event.oldView.toString() + " -> " + event.newView.toString());
		}
	}
}