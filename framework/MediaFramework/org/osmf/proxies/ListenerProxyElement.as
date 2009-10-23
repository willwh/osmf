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
package org.osmf.proxies
{
	import flash.display.DisplayObject;
	
	import org.osmf.events.BufferTimeChangeEvent;
	import org.osmf.events.BufferingChangeEvent;
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.events.DurationChangeEvent;
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.events.MutedChangeEvent;
	import org.osmf.events.PanChangeEvent;
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekingChangeEvent;
	import org.osmf.events.SwitchingChangeEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.events.ViewChangeEvent;
	import org.osmf.events.VolumeChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.traits.IAudible;
	import org.osmf.traits.IBufferable;
	import org.osmf.traits.IDownloadable;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.ISeekable;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.ISwitchable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * A ProxyElement which listens to all events from its wrapped MediaElement,
	 * and exposes hooks (available to subclasses) for doing custom processing
	 * in response to those events.
	 **/
	public class ListenerProxyElement extends ProxyElement
	{
		/**
		 * Constructor.
		 **/
		public function ListenerProxyElement(wrappedElement:MediaElement)
		{
			super(wrappedElement);
		}
		
		/**
		 * @private
		 **/
		override public function set wrappedElement(value:MediaElement):void
		{
			var traitType:MediaTraitType;
			
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
		
		// Protected
		//
	
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processTraitAdd(traitType:MediaTraitType):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processTraitRemove(traitType:MediaTraitType):void
		{
		}
	
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processVolumeChange(oldVolume:Number, newVolume:Number):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processMutedChange(muted:Boolean):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processPanChange(oldPan:Number, newPan:Number):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processBufferingChange(buffering:Boolean):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processBufferTimeChange(oldTime:Number, newTime:Number):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processLoadableStateChange(oldState:LoadState, newState:LoadState):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processPlayingChange(playing:Boolean):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processPausedChange(paused:Boolean):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processDurationReached():void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processDurationChange(oldDuration:Number, newDuration:Number):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processDimensionChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processSwitchingChange(oldState:int, newState:int, detail:SwitchingDetail):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processIndicesChange():void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processViewChange(oldView:DisplayObject, newView:DisplayObject):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processBytesTotalChange(newValue:Number):void
		{
		}

		// Internals
		
		private function onVolumeChange(event:VolumeChangeEvent):void
		{
			processVolumeChange(event.oldVolume, event.newVolume);
		}

		private function onMutedChange(event:MutedChangeEvent):void
		{
			processMutedChange(event.muted);
		}

		private function onPanChange(event:PanChangeEvent):void
		{
			processPanChange(event.oldPan, event.newPan);
		}
		
		private function onBufferingChange(event:BufferingChangeEvent):void
		{
			processBufferingChange(event.buffering);
		}

		private function onBufferTimeChange(event:BufferTimeChangeEvent):void
		{
			processBufferTimeChange(event.oldTime, event.newTime);
		}

		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			processLoadableStateChange(event.oldState, event.newState);
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			processPlayingChange(event.playing);
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			processPausedChange(event.paused);
		}

		private function onSeekingChange(event:SeekingChangeEvent):void
		{
			processSeekingChange(event.seeking, event.time);
		}
		
		private function onDurationReached(event:TraitEvent):void
		{
			processDurationReached();
		}

		private function onDurationChange(event:DurationChangeEvent):void
		{
			processDurationChange(event.oldDuration, event.newDuration);
		}

		private function onDimensionChange(event:DimensionChangeEvent):void
		{
			processDimensionChange(event.oldWidth, event.oldHeight, event.newWidth, event.newHeight);
		}
		
		private function onSwitchingChange(event:SwitchingChangeEvent):void
		{
			processSwitchingChange(event.oldState, event.newState, event.detail);
		}
		
		private function onIndicesChange(event:TraitEvent):void
		{
			processIndicesChange();
		}

		private function onViewChange(event:ViewChangeEvent):void
		{
			processViewChange(event.oldView, event.newView);
		}
		
		private function onBytesTotalChange(event:BytesTotalChangeEvent):void
		{
			processBytesTotalChange(event.newValue);
		}

		// Internals
		//
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			processTraitAdd(event.traitType);
			
			processTrait(event.traitType, true);
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			processTrait(event.traitType, false);

			processTraitRemove(event.traitType);
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
					
					// IViewable is the one trait where the change event is
					// merged with the trait addition/removal event.  So we
					// forcibly signal a view change event.
					var viewable:IViewable = wrappedElement.getTrait(MediaTraitType.VIEWABLE) as IViewable;
					if (viewable != null && viewable.view != null)
					{
						processViewChange(added ? null : viewable.view, added ? viewable.view : null);
					}
					break;
				case MediaTraitType.DOWNLOADABLE:
					toggleDownloadableListeners(added);
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
					audible.removeEventListener(VolumeChangeEvent.VOLUME_CHANGE, onVolumeChange);
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
					switchable.addEventListener(TraitEvent.INDICES_CHANGE, onIndicesChange);
				}
				else
				{
					switchable.removeEventListener(SwitchingChangeEvent.SWITCHING_CHANGE, onSwitchingChange);
					switchable.removeEventListener(TraitEvent.INDICES_CHANGE, onIndicesChange);
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
		
		private function toggleDownloadableListeners(added:Boolean):void
		{
			var downloadable:IDownloadable = wrappedElement.getTrait(MediaTraitType.DOWNLOADABLE) as IDownloadable;
			if (downloadable)
			{
				if (added)
				{
					downloadable.addEventListener(BytesTotalChangeEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
				else
				{
					downloadable.removeEventListener(BytesTotalChangeEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
			}
		}
	}
}