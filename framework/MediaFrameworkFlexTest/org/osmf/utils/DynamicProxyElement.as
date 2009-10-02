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
	import flash.utils.Dictionary;
	
	import org.osmf.loaders.ILoader;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.AudibleTrait;
	import org.osmf.traits.BufferableTrait;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PausableTrait;
	import org.osmf.traits.PlayableTrait;
	import org.osmf.traits.SeekableTrait;
	import org.osmf.traits.SpatialTrait;
	import org.osmf.traits.TemporalTrait;
	import org.osmf.traits.ViewableTrait;
	
	public class DynamicProxyElement extends ProxyElement
	{
		public function DynamicProxyElement(wrappedElement:MediaElement=null, traitTypes:Array=null, loader:ILoader=null, resource:IMediaResource=null)
		{
			super(wrappedElement);
			
			if (traitTypes != null || loader != null || resource != null)
			{
				initialize([traitTypes, loader, resource]);
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
			
			if (value && value.length == 3)
			{
				var traitTypes:Array = value[0] as Array;
				var loader:ILoader = value[1] as ILoader;
				var resource:IMediaResource = value[2] as IMediaResource;

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
			else
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_INITIALIZATION_ARGS);
			}
		}
		
		override protected function blocksTrait(type:MediaTraitType):Boolean
		{
			return blockedTraits[type] == true;
		}
		
		public var args:Array = [];
		
		private var blockedTraits:Dictionary = new Dictionary();
	}
}