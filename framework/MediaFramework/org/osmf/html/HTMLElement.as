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
package org.osmf.html
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Represents a media element who's characteristics are governed by
	 * HTML, and that (by contract) has its resource pointing to a URL.
	 * 
	 * Internally, an HTMLElement holds switchable playable, pausible,
	 * temporal and audible traits that HTMLGateway uses to bridge between 
	 * HTML and Flash.
	 */	
	public class HTMLElement extends MediaElement
	{
		// Public API
		//
		
		/**
		 * @private
		 */		
		public function set scriptPath(value:String):void
		{
			_scriptPath = value;
		}
		
		public function get scriptPath():String
		{
			return _scriptPath;
		}
		
		public function set loadState(value:String):void
		{
			loadTrait.loadState = value;
		}
		
		public function get loadState():String
		{
			return loadTrait.loadState;
		}
		
		/**
		 * @private
		 */		
		public function setTraitEnabled(type:String, enabled:Boolean):void
		{
			if (switchableTraitTypes.indexOf(type) == -1)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.UNSUPPORTED_TRAIT_TYPE));
			}
			
			var trait:MediaTraitBase = switchableTraits[type];
			if (trait == null && enabled == true)
			{
				// Instantiate the correct trait implementation:
				switch(type)
				{
					case MediaTraitType.PLAY:
						trait = new PlayTrait();
						break;
					case MediaTraitType.TIME:
						trait = new TimeTrait();
						break;
					case MediaTraitType.AUDIO:
						trait = new AudioTrait();
						break;
				}
				switchableTraits[type] = trait;
				updateTraits();
			}
			else if (trait != null && enabled == false)
			{
				// Remove the current trait implementation:
				delete switchableTraits[type];
				updateTraits();
			}
		}
		
		/**
	 	 * @private
	 	 */
	 	public function getSwitchableTrait(type:String):MediaTraitBase
	 	{
	 		return switchableTraits[type];
	 	}
		
		// Overrides
		//
		
		override protected function setupTraits():void
		{
			super.setupTraits();
			
			loadTrait = new HTMLLoadTrait(this);
			addTrait(MediaTraitType.LOAD, loadTrait);
			
			loadTrait.addEventListener
				( LoadEvent.LOAD_STATE_CHANGE
				, onLoadStateChange
				);
		}
		
		// Private
		//
	
		private function onLoadStateChange(event:LoadEvent):void
		{
			updateTraits();
		}
	
		private function updateTraits():void
		{
			var type:String;
			
			if (loadTrait.loadState == LoadState.READY)
			{
				// Make sure that the constructed trait objects are
				// being reflected on being loaded:
				for (var typeObject:Object in switchableTraits)
				{
					type = String(typeObject);
					var trait:MediaTraitBase = switchableTraits[type]; 
					if (hasTrait(type) == false)
					{
						addTrait(type, trait);
					}
				}
			}
			else
			{
				// Don't expose any traits if not loaded (except for the 
				// LoadTrait):
				for each (type in traitTypes)
				{
					if (type != MediaTraitType.LOAD)
					{
						removeTrait(type);
					}
				}
			}
		}
	
		private var loadTrait:HTMLLoadTrait;
		
		private var switchableTraits:Dictionary = new Dictionary();
		
		private var _scriptPath:String;
		
		/* static */
		
		private static const switchableTraitTypes:Vector.<String> = new Vector.<String>(3);
			switchableTraitTypes[0] = MediaTraitType.PLAY;
			switchableTraitTypes[1] = MediaTraitType.TIME;
			switchableTraitTypes[2] = MediaTraitType.AUDIO;
	}
}