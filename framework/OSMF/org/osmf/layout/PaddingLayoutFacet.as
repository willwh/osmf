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
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	internal class PaddingLayoutFacet extends LayoutFacet
	{
		/**
		 * @private
		 *
		 * Identifier for the facet's left property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const LEFT:FacetKey = new FacetKey("left");
		
		/**
		 * @private
		 *
		 * Identifier for the facet's top property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const TOP:FacetKey = new FacetKey("top");
		
		/**
		 * @private
		 *
		 * Identifier for the facet's right property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const RIGHT:FacetKey = new FacetKey("right");
		
		/**
		 * @private
		 *
		 * Identifier for the facet's bottom property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const BOTTOM:FacetKey = new FacetKey("bottom");
		
		/**
		 * Constructor.
		 */		
		public function PaddingLayoutFacet()
		{
			super(MetadataNamespaces.PADDING_LAYOUT_PARAMETERS);
		}
		
		override public function getValue(key:FacetKey):*
		{
			if (key == null)
			{
				return undefined;
			}
			else if (key.equals(LEFT))
			{
				return left;
			}
			else if (key.equals(TOP))
			{
				return top;
			}
			else if (key.equals(RIGHT))
			{
				return right;
			}
			else if (key.equals(BOTTOM))
			{
				return bottom
			}
			else
			{
				return undefined;
			}
		}
		
		// Public Interface
		//
		
		/**
		 * @private
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
		 * @private
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
		 * @private
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
		 * @private
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