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
	import flash.events.EventDispatcher;
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.IIdentifier;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.StringIdentifier;
	import org.osmf.utils.URL;

	/**
	 * Signals that one of IFacets's values has changed.
	 * 
	 * @eventType org.osmf.events.FacetChangeEvent.VALUE_CHANGE
	 */
    [Event(name='facetValueChange', type='org.osmf.events.FacetChangeEvent')]

	/**
	 * Defines a metadata facet that defines left, top, right and bottom values.
	 * 
	 * On encountering this facet on a target, the default layout renderer
	 * will use the set values to apply a blank space border with the set
	 * thickness for each side.
	 * 
	 * On applying padding, the default layout renderer consumes part of the width
	 * and height of its target. As such, padding does not affect the size of a
	 * target.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class PaddingLayoutFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Identifier for the facet's left property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const LEFT:StringIdentifier = new StringIdentifier("left");
		
		/**
		 * Identifier for the facet's top property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const TOP:StringIdentifier = new StringIdentifier("top");
		
		/**
		 * Identifier for the facet's right property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const RIGHT:StringIdentifier = new StringIdentifier("right");
		
		/**
		 * Identifier for the facet's bottom property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const BOTTOM:StringIdentifier = new StringIdentifier("bottom");
		
		// IFacet
		//
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get namespaceURL():URL
		{
			return MetadataNamespaces.PADDING_LAYOUT_PARAMETERS;
		}
		
		public function getValue(identifier:IIdentifier):*
		{
			if (identifier == null)
			{
				return undefined;
			}
			else if (identifier.equals(LEFT))
			{
				return left;
			}
			else if (identifier.equals(TOP))
			{
				return top;
			}
			else if (identifier.equals(RIGHT))
			{
				return right;
			}
			else if (identifier.equals(BOTTOM))
			{
				return bottom
			}
			else
			{
				return undefined;
			}
		}
		
		/**
		 * This facet does not merge.
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		// Public Interface
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's left-hand side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */					
		public function get left():Number
		{
			return _left;
		}
		public function set left(value:Number):void
		{
			if (_left != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, LEFT, value, _left);
				
				_left = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's top side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function get top():Number
		{
			return _top;
		}
		public function set top(value:Number):void
		{
			if (_top != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, TOP, value, _top);
					
				_top = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's right-hand side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function get right():Number
		{
			return _right;
		}
		
		public function set right(value:Number):void
		{
			if (_right != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, RIGHT, value, _right);
					
				_right = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's bottom side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public function get bottom():Number
		{
			return _bottom;
		}
		public function set bottom(value:Number):void
		{
			if (_bottom != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, BOTTOM, value, _bottom);
					
				_bottom = value;
						
				dispatchEvent(event);
			}
		}
		
		// Internals
		//
		
		private var _left:Number;
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
	}
}