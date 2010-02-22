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
package org.osmf.metadata
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.events.FacetValueEvent;
	import org.osmf.utils.OSMFStrings;
		 
     /**
	 * Signals that all of the Facets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetEvent.VALUE_ADD
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
     [Event(name='facetValueAdd', type='org.osmf.events.FacetValueEvent')]
	
     /**
	 * Signals that all of the Facets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetEvent.VALUE_REMOVE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
     [Event(name='facetValueRemove', type='org.osmf.events.FacetEvent')]
	
     /**
	 * Signals that all of the Facets's values have changed.
	 * 
	 * @eventType org.osmf.events.FacetValueChangeEvent.VALUE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
     [Event(name='facetValueChange', type='org.osmf.events.FacetValueChangeEvent')]
	
	/**
	 * The base class for all classes that hold metadata relating to Open Source Media Framework media. 
	 * Metadata is descriptive information relative to a piece of media.  
	 * Examples of metadata classes include DictionaryMetadata and XMPMetadata.  
	 * These classes are stored on all MediaResources as initial information relating to the media.  
	 * They are also stored on the MediaElement for per element, possibly dynamic metadata.
	 * Example of metadata content include: title, size, language, and subject.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */  
	public class Facet extends EventDispatcher
	{		
		/**
		 * Constructor.
		 * 
		 * @param namespaceURL The namespace for this facet.
		 * 
		 * @throws ArgumentError If namespaceURL is null or the empty string. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function Facet(namespaceURL:String = null)		
		{						
			_namespaceURL = namespaceURL;
			
			if (namespaceURL == null || namespaceURL.length == 0)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
		}
		
		/**
		 * The namespace for this facet.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get namespaceURL():String
		{
			return _namespaceURL;
		}
		
		/**
		 * Returns the value associate with a FacetKey.
		 * 
		 * Returns 'undefined' if the facet fails to resolve the key.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */

		public function getValue(key:FacetKey):*
		{
			if (key != null && data != null)
			{
				return data[key.key];
			}			
		}
		
		/**
		 * Stores the specified value in this Facet, using the specified
		 * FacetKey as the key.  The FacetKey can subsequently be used to
		 * retrieve the value.  If the FacetKey's key property is equal to
		 * the key of another object already in the Facet this will overwrite
		 * the association with the new value.
		 * 
		 * @param key The FacetKey to associate the value with.
		 * @param value The value to add to the Facet.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function addValue(key:FacetKey, value:Object):void
		{
			if (data == null)
			{
				data = new Dictionary();
			}
			
			var oldValue:* = data[key.key];			
			data[key.key] = value;
			
			if (oldValue != value)
			{				
				var event:Event
					= oldValue === undefined
						? new FacetValueEvent
							( FacetValueEvent.VALUE_ADD
							, false
							, false
							, key
							, value
							)
						: new FacetValueChangeEvent
							( FacetValueChangeEvent.VALUE_CHANGE
							, false
							, false
							, key
							, value
							, oldValue
							)
						;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * Removes the value associated with the specified FacetKey from this
		 * Facet. Returns undefined if there is no value associated with the
		 * FacetKey in this facet.
		 * 
		 * @param key The FacetKey associated with the value to be removed.
		 * @returns The removed item, null if no such item exists.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function removeValue(key:FacetKey):*
		{
			var value:* = data[key.key];
			if (value !== undefined)
			{
				delete data[key.key];
								
				dispatchEvent
					( new FacetValueEvent
						( FacetValueEvent.VALUE_REMOVE
						, false
						, false
						, key
						, value
						)
					);
			}
			return value;
		}
		
		/**
		 * All of the FacetKeys stored in this Facet.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get keys():Vector.<FacetKey>
		{
			var allKeys:Vector.<FacetKey> = new Vector.<FacetKey>;
			if (data != null)
			{
				for (var key:Object in data)
				{
					allKeys.push(new FacetKey(key));
				}
			}
			return allKeys;
		}

		/**
		 * @private
		 * 
		 * Defines the facet synthesizer that will be used by default to
		 * synthesize a new value based on a group of facets that share
		 * the namespace that this facet is registered under.
		 * 
		 * Note that facet synthesizers that get set on the facet's parent
		 * take precedence over the one that is defined here.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get synthesizer():FacetSynthesizer
		{
			return null;
		}
		
		private var _namespaceURL:String;
		private var data:Dictionary;
	}
}