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
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ProxyElement;
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
	
	public class DynamicProxyElement extends ProxyElement
	{
		public function DynamicProxyElement(wrappedElement:MediaElement, traitTypes:Array=null, loader:ILoader=null, resource:IMediaResource=null)
		{
			super(wrappedElement);
			
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
					
					addTrait(traitType, trait);
				}
			}
		}
		
		public function doAddTrait(type:MediaTraitType,instance:IMediaTrait):void
		{
			this.addTrait(type,instance);
		}

		public function doRemoveTrait(type:MediaTraitType):IMediaTrait
		{
			return this.removeTrait(type);
		}
		
		public function doBlockTrait(type:MediaTraitType):void
		{
			blockedTraits[type] = true;
		}
		
		override public function initialize(value:Array):void
		{
			this.args = value;
		}
		
		override protected function blockTrait(type:MediaTraitType):Boolean
		{
			return blockedTraits[type] == true;
		}
		
		public var args:Array = [];
		
		private var blockedTraits:Dictionary = new Dictionary();
	}
}