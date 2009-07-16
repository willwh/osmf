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
		
		override protected function blocksTrait(type:MediaTraitType):Boolean
		{
			return blockedTraits[type] == true;
		}
		
		public var args:Array = [];
		
		private var blockedTraits:Dictionary = new Dictionary();
	}
}