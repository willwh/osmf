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
	
	import org.osmf.events.AudioEvent;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.SwitchEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.ViewEvent;
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
		protected function processVolumeChange(newVolume:Number):void
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
		protected function processPanChange(newPan:Number):void
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
		protected function processBufferTimeChange(newBufferTime:Number):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processLoadStateChange(loadState:String):void
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
		protected function processDurationChange(newDuration:Number):void
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
		protected function processBytesTotalChange(newBytes:Number):void
		{
		}

		// Internals
		
		private function onVolumeChange(event:AudioEvent):void
		{
			processVolumeChange(event.volume);
		}

		private function onMutedChange(event:AudioEvent):void
		{
			processMutedChange(event.muted);
		}

		private function onPanChange(event:AudioEvent):void
		{
			processPanChange(event.pan);
		}
		
		private function onBufferingChange(event:BufferEvent):void
		{
			processBufferingChange(event.buffering);
		}

		private function onBufferTimeChange(event:BufferEvent):void
		{
			processBufferTimeChange(event.bufferTime);
		}

		private function onLoadStateChange(event:LoadEvent):void
		{
			processLoadStateChange(event.loadState);
		}
		
		private function onPlayingChange(event:PlayingChangeEvent):void
		{
			processPlayingChange(event.playing);
		}

		private function onPausedChange(event:PausedChangeEvent):void
		{
			processPausedChange(event.paused);
		}

		private function onSeekingChange(event:SeekEvent):void
		{
			processSeekingChange(event.type == SeekEvent.SEEK_BEGIN, event.time);
		}
		
		private function onDurationReached(event:TimeEvent):void
		{
			processDurationReached();
		}

		private function onDurationChange(event:TimeEvent):void
		{
			processDurationChange(event.time);
		}

		private function onDimensionChange(event:DimensionEvent):void
		{
			processDimensionChange(event.oldWidth, event.oldHeight, event.newWidth, event.newHeight);
		}
		
		private function onSwitchingChange(event:SwitchEvent):void
		{
			processSwitchingChange(event.oldState, event.newState, event.detail);
		}
		
		private function onIndicesChange(event:SwitchEvent):void
		{
			processIndicesChange();
		}

		private function onViewChange(event:ViewEvent):void
		{
			processViewChange(event.oldView, event.newView);
		}
		
		private function onBytesTotalChange(event:LoadEvent):void
		{
			processBytesTotalChange(event.bytes);
		}

		// Internals
		//
		
		private function onTraitAdd(event:MediaElementEvent):void
		{
			processTraitAdd(event.traitType);
			
			processTrait(event.traitType, true);
		}

		private function onTraitRemove(event:MediaElementEvent):void
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
					bufferable.addEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChange);
					bufferable.addEventListener(BufferEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
				}
				else
				{
					bufferable.removeEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChange);
					bufferable.removeEventListener(BufferEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
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
					seekable.addEventListener(SeekEvent.SEEK_BEGIN, onSeekingChange);
					seekable.addEventListener(SeekEvent.SEEK_END, onSeekingChange);
				}
				else
				{
					seekable.removeEventListener(SeekEvent.SEEK_BEGIN, onSeekingChange);
					seekable.removeEventListener(SeekEvent.SEEK_END, onSeekingChange);
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
					switchable.addEventListener(SwitchEvent.INDICES_CHANGE, onIndicesChange);
				}
				else
				{
					switchable.removeEventListener(SwitchEvent.SWITCHING_CHANGE, onSwitchingChange);
					switchable.removeEventListener(SwitchEvent.INDICES_CHANGE, onIndicesChange);
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
					temporal.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
				}
				else
				{
					temporal.removeEventListener(TimeEvent.DURATION_REACHED, onDurationReached);
					temporal.removeEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
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
					viewable.addEventListener(ViewEvent.VIEW_CHANGE, onViewChange);
				}
				else
				{
					viewable.removeEventListener(ViewEvent.VIEW_CHANGE, onViewChange);
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
					downloadable.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
				else
				{
					downloadable.removeEventListener(LoadEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
			}
		}
	}
}