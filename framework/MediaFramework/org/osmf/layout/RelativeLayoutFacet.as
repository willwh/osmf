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
	 * Defines a metadata facet that defines x, y, width and height values.
	 * 
	 * On encountering this facet on a target, the default layout renderer
	 * will use the set values to position and size the target relative to the
	 * target context's width and height.
	 * 
	 * Please note that the default layout renderer gives precendence to absolute
	 * layout values. Relative values come next, and anchor values last.
	 */
	public class RelativeLayoutFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Identifier for the facet's x property.
		 */
		public static const X:StringIdentifier = new StringIdentifier("x");
		
		/**
		 * Identifier for the facet's y property.
		 */
		public static const Y:StringIdentifier = new StringIdentifier("y");
		
		/**
		 * Identifier for the facet's width property.
		 */
		public static const WIDTH:StringIdentifier = new StringIdentifier("width");
		
		/**
		 * Identifier for the facet's height property.
		 */
		public static const HEIGHT:StringIdentifier = new StringIdentifier("height");
		
		// IFacet
		//
		
		/**
		 * @inheritDoc
		 */
		public function get namespaceURL():URL
		{
			return MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue(identifier:IIdentifier):*
		{
			if (identifier == null)
			{
				return undefined;
			}
			else if (identifier.equals(X))
			{
				return x;
			}
			else if (identifier.equals(Y))
			{
				return y;
			}
			else if (identifier.equals(WIDTH))
			{
				return width;
			}
			else if (identifier.equals(HEIGHT))
			{
				return height;
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
		 */
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		// Public interface
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired horizontal offset of a target expressed as
		 * a percentage of its context's width.
		 */		
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if (_x != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(X,value,_x);
				
				_x = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired vertical offset of a target expressed as
		 * a percentage of its context's height.
		 */	
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if (_y != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(Y,value,_y);
					
				_y = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired width of a target expressed as
		 * a percentage of its context's width.
		 */	
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			if (_width != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(WIDTH,value,_width);
					
				_width = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired height of a target expressed as
		 * a percentage of its context's height.
		 */	
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			if (_height != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(HEIGHT,value,_height);
					
				_height = value;
						
				dispatchEvent(event);
			}
		}
		
		// Internals
		//
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
	}
}