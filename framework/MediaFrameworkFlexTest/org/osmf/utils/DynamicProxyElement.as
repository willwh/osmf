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
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.BufferTrait;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.traits.ViewTrait;
	
	public class DynamicProxyElement extends ProxyElement
	{
		public function DynamicProxyElement(wrappedElement:MediaElement=null, traitTypes:Array=null, loader:ILoader=null, resource:IMediaResource=null)
		{
			super(wrappedElement);
			
			if (traitTypes != null || loader != null || resource != null)
			{
				initialize(traitTypes, loader, resource);
			}
		}
				
		public function doAddTrait(type:String, instance:MediaTraitBase):void
		{
			this.addTrait(type,instance);
		}

		public function doRemoveTrait(type:String):MediaTraitBase
		{
			return this.removeTrait(type);
		}
		
		public function doBlockTrait(type:String):void
		{
			blockedTraits[type] = true;
		}

		override protected function blocksTrait(type:String):Boolean
		{
			return blockedTraits[type] == true;
		}

		private function initialize(traitTypes:Array, loader:ILoader, resource:IMediaResource):void
		{
			this.resource = resource;
		
			if (traitTypes != null)
			{
				for each (var traitType:String in traitTypes)
				{
					var trait:MediaTraitBase = null;
					
					switch (traitType)
					{
						case MediaTraitType.AUDIO:
							trait = new AudioTrait();
							break;
						case MediaTraitType.BUFFER:
							trait = new BufferTrait();
							break;
						case MediaTraitType.LOAD:
							trait = new LoadTrait(loader, resource);
							break;
						case MediaTraitType.PLAY:
							trait = new PlayTrait();
							break;
						case MediaTraitType.SEEK:
							trait = new SeekTrait(null);
							break;
						case MediaTraitType.TIME:
							trait = new TimeTrait();
							break;
						case MediaTraitType.VIEW:
							trait = new ViewTrait(null);
							break;
						default:
							throw new ArgumentError();
					}
					
					addTrait(traitType, trait);
				}
			}
		}
		
		private var blockedTraits:Dictionary = new Dictionary();
	}
}