/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.utils
{
	import org.openvideoplayer.events.PausedChangeEvent;
	import org.openvideoplayer.events.PlayingChangeEvent;
	import org.openvideoplayer.events.SeekingChangeEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.AudibleTrait;
	import org.openvideoplayer.traits.BufferableTrait;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.PausibleTrait;
	import org.openvideoplayer.traits.PlayableTrait;
	import org.openvideoplayer.traits.SeekableTrait;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.TemporalTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	
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
						case MediaTraitType.PAUSIBLE:
							trait = new PausibleTrait();
							break;
						case MediaTraitType.PLAYABLE:
							trait = new PlayableTrait();
							break;
						case MediaTraitType.SEEKABLE:
							trait = new SeekableTrait();
							break;
						case MediaTraitType.SPATIAL:
							trait = new SpatialTrait();
							break;
						case MediaTraitType.TEMPORAL:
							trait = new TemporalTrait();
							break;
						case MediaTraitType.VIEWABLE:
							trait = new ViewableTrait();
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
				seekable.addEventListener(SeekingChangeEvent.SEEKING_CHANGE, onSeekingChanged);
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
			else if (type == MediaTraitType.PAUSIBLE)
			{
				pausible = instance as PausibleTrait;
				pausible.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);				
			}
		}

		public function doRemoveTrait(type:MediaTraitType):IMediaTrait
		{
			if (type == MediaTraitType.PLAYABLE)
			{
				playable.removeEventListener(PlayingChangeEvent.PLAYING_CHANGE, onPlayingChanged);
				playable = null;
			}
			else if (type == MediaTraitType.PAUSIBLE)
			{
				pausible.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);
				pausible = null;
			}
			
			return this.removeTrait(type);
		}
		
		override public function initialize(value:Array):void
		{
			this.args = value;
		}
		
		private function onPlayingChanged(event:PlayingChangeEvent):void
		{
			if (event.playing == true && pausible != null)
			{
				pausible.resetPaused();
			}
		}
		
		private function onPausedChanged(event:PausedChangeEvent):void
		{
			if (event.paused == true && playable != null)
			{
				playable.resetPlaying();
			}
		}
		
		private function onSeekingChanged(event:SeekingChangeEvent):void
		{
			if (temporal != null && event.seeking == true)
			{
				temporal.position = event.time;
			}
		}
		
		public var args:Array = []
		public var playable:PlayableTrait;
		public var pausible:PausibleTrait;
		public var temporal:TemporalTrait;
	}
}