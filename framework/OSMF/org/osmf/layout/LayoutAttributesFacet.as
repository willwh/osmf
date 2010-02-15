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
		 * Intentifier for the facet's index property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const INDEX:StringIdentifier = new StringIdentifier("index");
		
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
		 * Intentifier for the facet's index property.
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
		 * Intentifier for the facet's vertical align property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const VERTICAL_ALIGN:StringIdentifier = new StringIdentifier("verticalAlign");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's horizontal align property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const HORIZONTAL_ALIGN:StringIdentifier = new StringIdentifier("horizontalAlign");
		
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
		 * Intentifier for the facet's layoutMode property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const MODE:StringIdentifier = new StringIdentifier("layoutMode");
		
		/**
		 * @private
		 *
		 * Intentifier for the facet's includeInLayout property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public static const INCLUDE_IN_LAYOUT:StringIdentifier = new StringIdentifier("includeInLayout");
		
		public function LayoutAttributesFacet()
		{
			_verticalAlign = null;
			_horizontalAlign = null;
			_scaleMode = null;
			_snapToPixel = true;
			_layoutMode = LayoutMode.NONE;
			_includeInLayout = true;
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
			else if (identifier.equals(INDEX))
			{
				return index;
			}
			else if (identifier.equals(SCALE_MODE))
			{
				return scaleMode;
			}
			else if (identifier.equals(VERTICAL_ALIGN))
			{
				return verticalAlign;
			}
			else if (identifier.equals(HORIZONTAL_ALIGN))
			{
				return horizontalAlign;
			}
			else if (identifier.equals(SNAP_TO_PIXEL))
			{
				return snapToPixel;
			}
			else if (identifier.equals(INCLUDE_IN_LAYOUT))
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
		public function get index():Number
		{
			return _index;
		}
		public function set index(value:Number):void
		{
			if (_index != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, INDEX, value, _index);
					
				_index = value;
						
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
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, VERTICAL_ALIGN, value, _verticalAlign);
					
				_verticalAlign = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		public function set horizontalAlign(value:String):void
		{
			if (_horizontalAlign != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, HORIZONTAL_ALIGN, value, _horizontalAlign);
					
				_horizontalAlign = value;
						
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
		public function get layoutMode():String
		{
			return _layoutMode;
		}
		public function set layoutMode(value:String):void
		{
			if (_layoutMode != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, MODE, value, _layoutMode);
					
				_layoutMode = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}
		public function set includeInLayout(value:Boolean):void
		{
			if (_includeInLayout != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, INCLUDE_IN_LAYOUT, value, _layoutMode);
					
				_includeInLayout = value;
						
				dispatchEvent(event);
			}
		}
		
		// Internals
		//
		
		private var _index:Number = NaN;
		private var _scaleMode:String;
		private var _verticalAlign:String;
		private var _horizontalAlign:String;
		private var _snapToPixel:Boolean;
		private var _layoutMode:String;
		private var _includeInLayout:Boolean;
	}
}