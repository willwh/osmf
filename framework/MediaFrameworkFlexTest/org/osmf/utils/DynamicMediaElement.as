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
package org.osmf.utils
{
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.events.PlayingChangeEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.*;
	import org.osmf.traits.AudibleTrait;
	import org.osmf.traits.BufferableTrait;
	import org.osmf.traits.DownloadableTrait;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.PausableTrait;
	import org.osmf.traits.PlayableTrait;
	import org.osmf.traits.SeekableTrait;
	import org.osmf.traits.SpatialTrait;
	import org.osmf.traits.SwitchableTrait;
	import org.osmf.traits.TemporalTrait;
	import org.osmf.traits.ViewableTrait;
	
	public class DynamicMediaElement extends MediaElement
	{
		public function DynamicMediaElement(traitTypes:Array=null, loader:ILoader=null, resource:IMediaResource=null)
		{
			this.resource = resource;
			
			if (traitTypes != null)
			{
				for each (var traitType:MediaTraitType in traitTypes)
				{
					var trait:IMediaTrait = null;
					
					switch (traitType)
					{
						case MediaTraitType.AUDIBLE:
							trait = new AudibleTrait();
							break;
						case MediaTraitType.BUFFERABLE:
							trait = new BufferableTrait();
							break;
						case MediaTraitType.LOADABLE:
							trait = new LoadableTrait(loader, resource);
							break;
						case MediaTraitType.PAUSABLE:
							trait = new PausableTrait(this);
							break;
						case MediaTraitType.PLAYABLE:
							trait = new PlayableTrait(this);
							break;
						case MediaTraitType.SEEKABLE:
							trait = new SeekableTrait();
							break;
						case MediaTraitType.SPATIAL:
							trait = new SpatialTrait();
							break;
						case MediaTraitType.SWITCHABLE:
							trait = new SwitchableTrait(true, 0, 5);
							break;
						case MediaTraitType.TEMPORAL:
							trait = new TemporalTrait();
							break;
						case MediaTraitType.VIEWABLE:
							trait = new ViewableTrait();
							break;
						case MediaTraitType.DOWNLOADABLE:
							trait = new DownloadableTrait(10, 100);
							break;
						default:
							throw new ArgumentError();
					}
					
					doAddTrait(traitType, trait);
				}
			}
			
			temporal = getTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
			var seekable:SeekableTrait = getTrait(MediaTraitType.SEEKABLE) as SeekableTrait;
			
			if (seekable != null && temporal != null)
			{
				seekable.temporal = temporal;
				seekable.addEventListener(SeekEvent.SEEK_BEGIN, onSeekingChanged);
				seekable.addEventListener(SeekEvent.SEEK_END, onSeekingChanged);
			}
		}
		
		public function doAddTrait(type:MediaTraitType,instance:IMediaTrait):void
		{
			this.addTrait(type,instance);
			if (type == MediaTraitType.PLAYABLE)
			{
				playable = instance as PlayableTrait;
				playable.addEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);
			}
			else if (type == MediaTraitType.PAUSABLE)
			{
				pausable = instance as PausableTrait;
				pausable.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);				
			}
		}

		public function doRemoveTrait(type:MediaTraitType):IMediaTrait
		{
			if (type == MediaTraitType.PLAYABLE)
			{
				playable.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);
				playable = null;
			}
			else if (type == MediaTraitType.PAUSABLE)
			{
				pausable.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);
				pausable = null;
			}
			
			return this.removeTrait(type);
		}
		
		private function onPlayingChanged(event:PlayingChangeEvent):void
		{
			if (event.playing == true && pausable != null)
			{
				pausable.resetPaused();
			}
		}
		
		private function onPausedChanged(event:PausedChangeEvent):void
		{
			if (event.paused == true && playable != null)
			{
				playable.resetPlaying();
			}
		}
		
		private function onSeekingChanged(event:SeekEvent):void
		{
			if (temporal != null && event.type == SeekEvent.SEEK_BEGIN)
			{
				temporal.currentTime = event.time;
			}
		}
		
		public var playable:PlayableTrait;
		public var pausable:PausableTrait;
		public var temporal:TemporalTrait;
	}
}