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
	import org.osmf.events.DynamicStreamEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.BufferTrait;
	import org.osmf.traits.DynamicStreamTrait;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.traits.DisplayObjectTrait;
	
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
			var traitType:String;
			
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
		protected function processTraitAdd(traitType:String):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processTraitRemove(traitType:String):void
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
		protected function processBytesTotalChange(newBytes:Number):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processCanPauseChange(canPause:Boolean):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processPlayStateChange(playState:String):void
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
		protected function processComplete():void
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
		protected function processMediaSizeChange(oldWidth:Number, oldHeight:Number, newWidth:Number, newHeight:Number):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processSwitchingChange(switching:Boolean, detail:SwitchingDetail):void
		{
		}
		
		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processNumDynamicStreamsChange():void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processAutoSwitchChange(newAutoSwitch:Boolean):void
		{
		}

		/**
		 * Subclasses can override to perform custom processing in response to
		 * this change.
		 **/
		protected function processDisplayObjectChange(oldDisplayObject:DisplayObject, newView:DisplayObject):void
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
		
		private function onBytesTotalChange(event:LoadEvent):void
		{
			processBytesTotalChange(event.bytes);
		}
		
		private function onCanPauseChange(event:PlayEvent):void
		{
			processCanPauseChange(event.canPause);
		}

		private function onPlayStateChange(event:PlayEvent):void
		{
			processPlayStateChange(event.playState);
		}

		private function onSeekingChange(event:SeekEvent):void
		{
			processSeekingChange(event.type == SeekEvent.SEEK_BEGIN, event.time);
		}
		
		private function onComplete(event:TimeEvent):void
		{
			processComplete();
		}

		private function onDurationChange(event:TimeEvent):void
		{
			processDurationChange(event.time);
		}

		private function onSwitchingChange(event:DynamicStreamEvent):void
		{
			processSwitchingChange(event.switching, event.detail);
		}
		
		private function onNumDynamicStreamsChange(event:DynamicStreamEvent):void
		{
			processNumDynamicStreamsChange();
		}

		private function onAutoSwitchChange(event:DynamicStreamEvent):void
		{
			processAutoSwitchChange(event.autoSwitch);
		}

		private function onDisplayObjectChange(event:DisplayObjectEvent):void
		{
			processDisplayObjectChange(event.oldDisplayObject, event.newDisplayObject);
		}

		private function onMediaSizeChange(event:DisplayObjectEvent):void
		{
			processMediaSizeChange(event.oldWidth, event.oldHeight, event.newWidth, event.newHeight);
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
		
		private function processTrait(traitType:String, added:Boolean):void
		{
			switch (traitType)
			{
				case MediaTraitType.AUDIO:
					toggleAudioTraitListeners(added);
					break;
				case MediaTraitType.BUFFER:
					toggleBufferTraitListeners(added);
					break;
				case MediaTraitType.LOAD:
					toggleLoadTraitListeners(added);
					break;
				case MediaTraitType.PLAY:
					togglePlayTraitListeners(added);
					break;
				case MediaTraitType.SEEK:
					toggleSeekTraitListeners(added);
					break;
				case MediaTraitType.DYNAMIC_STREAM:
					toggleDynamicStreamTraitListeners(added);
					break;
				case MediaTraitType.TIME:
					toggleTimeTraitListeners(added);
					break;
				case MediaTraitType.DISPLAY_OBJECT:
					toggleDisplayObjectTraitListeners(added);
					
					// DisplayObjectTrait is the one trait where the change event is
					// merged with the trait addition/removal event.  So we
					// forcibly signal a view change event.
					var displayObjectTrait:DisplayObjectTrait = wrappedElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
					if (displayObjectTrait != null && displayObjectTrait.displayObject != null)
					{
						processDisplayObjectChange(added ? null : displayObjectTrait.displayObject, added ? displayObjectTrait.displayObject : null);
					}
					break;
			}
		}
		
		private function toggleAudioTraitListeners(added:Boolean):void
		{
			var audioTrait:AudioTrait = wrappedElement.getTrait(MediaTraitType.AUDIO) as AudioTrait;
			if (audioTrait)
			{
				if (added)
				{
					audioTrait.addEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
					audioTrait.addEventListener(AudioEvent.MUTED_CHANGE, onMutedChange);
					audioTrait.addEventListener(AudioEvent.PAN_CHANGE, onPanChange);
				}
				else
				{
					audioTrait.removeEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
					audioTrait.removeEventListener(AudioEvent.MUTED_CHANGE, onMutedChange);
					audioTrait.removeEventListener(AudioEvent.PAN_CHANGE, onPanChange);
				}
			}
		}

		private function toggleBufferTraitListeners(added:Boolean):void
		{
			var bufferTrait:BufferTrait = wrappedElement.getTrait(MediaTraitType.BUFFER) as BufferTrait;
			if (bufferTrait)
			{
				if (added)
				{
					bufferTrait.addEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChange);
					bufferTrait.addEventListener(BufferEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
				}
				else
				{
					bufferTrait.removeEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChange);
					bufferTrait.removeEventListener(BufferEvent.BUFFER_TIME_CHANGE, onBufferTimeChange);
				}
			}
		}
		
		private function toggleLoadTraitListeners(added:Boolean):void
		{
			var loadTrait:LoadTrait = wrappedElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
			if (loadTrait)
			{
				if (added)
				{
					loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					loadTrait.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
				else
				{
					loadTrait.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
					loadTrait.removeEventListener(LoadEvent.BYTES_TOTAL_CHANGE, onBytesTotalChange);
				}
			}
		}

		private function togglePlayTraitListeners(added:Boolean):void
		{
			var playTrait:PlayTrait = wrappedElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
			if (playTrait)
			{
				if (added)
				{
					playTrait.addEventListener(PlayEvent.CAN_PAUSE_CHANGE, onCanPauseChange);
					playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
				}
				else
				{
					playTrait.removeEventListener(PlayEvent.CAN_PAUSE_CHANGE, onCanPauseChange);
					playTrait.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
				}
			}
		}
		
		private function toggleSeekTraitListeners(added:Boolean):void
		{
			var seekTrait:SeekTrait = wrappedElement.getTrait(MediaTraitType.SEEK) as SeekTrait;
			if (seekTrait)
			{
				if (added)
				{
					seekTrait.addEventListener(SeekEvent.SEEK_BEGIN, onSeekingChange);
					seekTrait.addEventListener(SeekEvent.SEEK_END, onSeekingChange);
				}
				else
				{
					seekTrait.removeEventListener(SeekEvent.SEEK_BEGIN, onSeekingChange);
					seekTrait.removeEventListener(SeekEvent.SEEK_END, onSeekingChange);
				}
			}
		}
		
		private function toggleDynamicStreamTraitListeners(added:Boolean):void
		{
			var dynamicStreamTrait:DynamicStreamTrait = wrappedElement.getTrait(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait;
			if (dynamicStreamTrait)
			{
				if (added)
				{
					dynamicStreamTrait.addEventListener(DynamicStreamEvent.SWITCHING_CHANGE, onSwitchingChange);
					dynamicStreamTrait.addEventListener(DynamicStreamEvent.NUM_DYNAMIC_STREAMS_CHANGE, onNumDynamicStreamsChange);
					dynamicStreamTrait.addEventListener(DynamicStreamEvent.AUTO_SWITCH_CHANGE, onAutoSwitchChange);
				}
				else
				{
					dynamicStreamTrait.removeEventListener(DynamicStreamEvent.SWITCHING_CHANGE, onSwitchingChange);
					dynamicStreamTrait.removeEventListener(DynamicStreamEvent.NUM_DYNAMIC_STREAMS_CHANGE, onNumDynamicStreamsChange);
					dynamicStreamTrait.removeEventListener(DynamicStreamEvent.AUTO_SWITCH_CHANGE, onAutoSwitchChange);
				}
			}
		}
		private function toggleTimeTraitListeners(added:Boolean):void
		{
			var timeTrait:TimeTrait = wrappedElement.getTrait(MediaTraitType.TIME) as TimeTrait;
			if (timeTrait)
			{
				if (added)
				{
					timeTrait.addEventListener(TimeEvent.COMPLETE, onComplete);
					timeTrait.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
				}
				else
				{
					timeTrait.removeEventListener(TimeEvent.COMPLETE, onComplete);
					timeTrait.removeEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
				}
			}
		}
		
		private function toggleDisplayObjectTraitListeners(added:Boolean):void
		{
			var displayObjectTrait:DisplayObjectTrait = wrappedElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
			if (displayObjectTrait)
			{
				if (added)
				{
					displayObjectTrait.addEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, onDisplayObjectChange);
					displayObjectTrait.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange);
				}
				else
				{
					displayObjectTrait.removeEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, onDisplayObjectChange);
					displayObjectTrait.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange);
				}
			}
		}
	}
}