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
package org.osmf.layout
{
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.metadata.FacetKey;
	import org.osmf.metadata.MetadataNamespaces;

	/**
	 * @private
	 * 
	 * Defines a metadata facet that holds a number of box layout related attributes.
	 * 
	 * The default layout renderer adheres specific semantics to each attribute.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	internal class BoxAttributesFacet extends LayoutFacet
	{
		/**
		 * @private
		 * 
		 * Intentifier for the facet's relativeSum property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const RELATIVE_SUM:FacetKey = new FacetKey("relativeSum");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's absoluteSum property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const ABSOLUTE_SUM:FacetKey = new FacetKey("absoluteSum");
		
		
		public function BoxAttributesFacet()
		{
			_relativeSum = 0;
			_absoluteSum = 0;
			
		}
		
		// Facet
		//
		
		/**
		 * @private
		 */
		override public function get namespaceURL():String
		{
			return MetadataNamespaces.BOX_LAYOUT_ATTRIBUTES;
		}
		
		/**
		 * @private
		 */
		override public function getValue(key:FacetKey):*
		{
			if (key == null)
			{
				return undefined;
			}
			else if (key.equals(RELATIVE_SUM))
			{
				return relativeSum;
			}
			else if (key.equals(ABSOLUTE_SUM))
			{
				return absoluteSum;
			}
			else 
			{
				return undefined;
			}
		}
		
		// Public interface
		//
		
		/**
		 * @private
		 */
		public function get relativeSum():Number
		{
			return _relativeSum;
		}
		public function set relativeSum(value:Number):void
		{
			if (_relativeSum != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, RELATIVE_SUM, value, _relativeSum);
					
				_relativeSum = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get absoluteSum():Number
		{
			return _absoluteSum;
		}
		public function set absoluteSum(value:Number):void
		{
			if (_absoluteSum != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, ABSOLUTE_SUM, value, _absoluteSum);
					
				_absoluteSum = value;
						
				dispatchEvent(event);
			}
		}

		
		// Internals
		//
		
		private var _relativeSum:Number;
		private var _absoluteSum:Number;
	}
}