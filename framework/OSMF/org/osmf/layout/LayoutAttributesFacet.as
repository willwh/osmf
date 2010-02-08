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
	import org.osmf.metadata.IIdentifier;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.StringIdentifier;
	import org.osmf.utils.URL;

	/**
	 * @private
	 * 
	 * Defines a metadata facet that holds a number of layout related attributes.
	 * 
	 * The default layout renderer adheres specific semantics to each attribute.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	internal class LayoutAttributesFacet extends LayoutFacet
	{
		/**
		 * @private
		 * 
		 * Intentifier for the facet's order property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const ORDER:StringIdentifier = new StringIdentifier("order");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's registrationPoint property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const REGISTRATION_POINT:StringIdentifier = new StringIdentifier("registrationPoint");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's order property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const SCALE_MODE:StringIdentifier = new StringIdentifier("scaleMode");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's vertical alignment property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const VERTICAL_ALIGNMENT:StringIdentifier = new StringIdentifier("verticalAlignment");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's horizontal alignment property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const HORIZONTAL_ALIGNMENT:StringIdentifier = new StringIdentifier("horizontalAlignment");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's snapToPixel property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const SNAP_TO_PIXEL:StringIdentifier = new StringIdentifier("snapToPixel");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's mode property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const MODE:StringIdentifier = new StringIdentifier("mode");
		
		public function LayoutAttributesFacet()
		{
			_verticalAlignment = null;
			_horizontalAlignment = null;
			_scaleMode = null;
		}
		
		// Facet
		//
		
		/**
		 * @private
		 */
		override public function get namespaceURL():URL
		{
			return MetadataNamespaces.LAYOUT_ATTRIBUTES;
		}
		
		/**
		 * @private
		 */
		override public function getValue(identifier:IIdentifier):*
		{
			if (identifier == null)
			{
				return undefined;
			}
			else if (identifier.equals(ORDER))
			{
				return order;
			}
			else if (identifier.equals(SCALE_MODE))
			{
				return scaleMode;
			}
			else if (identifier.equals(VERTICAL_ALIGNMENT))
			{
				return verticalAlignment;
			}
			else if (identifier.equals(HORIZONTAL_ALIGNMENT))
			{
				return horizontalAlignment;
			}
			else if (identifier.equals(SNAP_TO_PIXEL))
			{
				return snapToPixel;
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
		public function get order():Number
		{
			return _order;
		}
		public function set order(value:Number):void
		{
			if (_order != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, ORDER, value, _order);
					
				_order = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get scaleMode():String
		{
			return _scaleMode;
		}
		public function set scaleMode(value:String):void
		{
			if (_scaleMode != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, SCALE_MODE, value, _scaleMode);
					
				_scaleMode = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get verticalAlignment():String
		{
			return _verticalAlignment;
		}
		public function set verticalAlignment(value:String):void
		{
			if (_verticalAlignment != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, VERTICAL_ALIGNMENT, value, _verticalAlignment);
					
				_verticalAlignment = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get horizontalAlignment():String
		{
			return _horizontalAlignment;
		}
		public function set horizontalAlignment(value:String):void
		{
			if (_horizontalAlignment != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, HORIZONTAL_ALIGNMENT, value, _horizontalAlignment);
					
				_horizontalAlignment = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */	
		public function get snapToPixel():Boolean
		{
			return _snapToPixel;
		}
		public function set snapToPixel(value:Boolean):void
		{
			if (_snapToPixel != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, SNAP_TO_PIXEL, value, _snapToPixel);
					
				_snapToPixel = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get mode():String
		{
			return _mode;
		}
		public function set mode(value:String):void
		{
			if (_mode != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, MODE, value, _mode);
					
				_mode = value;
						
				dispatchEvent(event);
			}
		}
		
		// Internals
		//
		
		private var _order:Number = NaN;
		private var _scaleMode:String;
		private var _verticalAlignment:String;
		private var _horizontalAlignment:String;
		private var _snapToPixel:Boolean;
		private var _mode:String;
	}
}