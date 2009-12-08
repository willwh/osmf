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
package org.osmf.composition
{
	import flash.events.Event;
	
	import org.osmf.metadata.FacetGroup;
	import org.osmf.metadata.FacetSynthesizer;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.Metadata;

	/**
	 * Defines the event class that CompositeMetadata uses on signaling
	 * various event.
	 */	
	internal class CompositeMetadataEvent extends Event
	{
		public static const CHILD_ADD:String = "childAdd";
		public static const CHILD_REMOVE:String = "childRemove";
		public static const CHILD_FACET_ADD:String = "childFacetAdd";
		public static const CHILD_FACET_REMOVE:String = "childFacetRemove";
		public static const FACET_GROUP_ADD:String = "facetGroupAdd";
		public static const FACET_GROUP_REMOVE:String = "facetGroupRemove";
		public static const FACET_GROUP_CHANGE:String = "facetGroupChange";
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * @param child
		 * @param facet
		 * @param facetGroup
		 * @param facetSynthesizer
		 * 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function CompositeMetadataEvent
							( type:String
							, bubbles:Boolean=false
							, cancelable:Boolean=false
							, child:Metadata = null
							, facet:IFacet = null
							, facetGroup:FacetGroup = null
							, suggestedFacetSynthesizer:FacetSynthesizer = null
							)
		{
			super(type, bubbles, cancelable);
			
			_child = child;
			_facet = facet;
			_facetGroup = facetGroup;
			
			suggestFacetSynthesizer(suggestedFacetSynthesizer);
		}
		
		/**
		 * Defines the metadata child that is associated with the event.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get child():Metadata
		{
			return _child;
		}
		
		/**
		 * Defines the facet that is associated with the event.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get facet():IFacet
		{
			return _facet;
		}
		
		/**
		 * Defines the facetGroup that is associated with the event.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get facetGroup():FacetGroup
		{
			return _facetGroup;
		}
		
		/**
		 * @private
		 * 
		 * Method for hanlder functions to suggest a facet synthesizer to
		 * the dispatching composite metadata instance.
		 * 
		 * @param value The suggested facet synthesizer.
		 */		
		public function suggestFacetSynthesizer(value:FacetSynthesizer):void
		{
			_suggestedFacetSynthesizer = value;
		}
		
		/**
		 * @private
		 * 
		 * Defines the facetSynthesizer that is to be used for synthesis. This
		 * value can be set by listeners that wish to suggest a synthesizer. 
		 * 
		 */	
		public function get suggestedFacetSynthesizer():FacetSynthesizer
		{
			return _suggestedFacetSynthesizer;
		}
		
		// Overrides
		//
		
		override public function clone():Event
		{
			return new CompositeMetadataEvent
				( type , bubbles, cancelable
				, _child, _facet, _facetGroup, _suggestedFacetSynthesizer
				);
		}
		
		// Internal
		//
		
		private var _child:Metadata;
		private var _facet:IFacet;
		private var _facetGroup:FacetGroup;
		private var _suggestedFacetSynthesizer:FacetSynthesizer;
	}
}