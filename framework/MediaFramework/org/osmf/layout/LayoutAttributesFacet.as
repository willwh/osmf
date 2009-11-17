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
	
	import org.osmf.display.ScaleMode;
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
	 * Defines a metadata facet that holds a number of layout related attributes.
	 * 
	 * The default layout renderer adheres specific semantics to each attribute.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class LayoutAttributesFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Intentifier for the facet's order property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ORDER:StringIdentifier = new StringIdentifier("order");
		
		/**
		 * Intentifier for the facet's registrationPoint property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const REGISTRATION_POINT:StringIdentifier = new StringIdentifier("registrationPoint");
		
		/**
		 * Intentifier for the facet's order property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const SCALE_MODE:StringIdentifier = new StringIdentifier("scaleMode");
		
		/**
		 * Intentifier for the facet's alignment property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ALIGNMENT:StringIdentifier = new StringIdentifier("alignment");
		
		/**
		 * Intentifier for the facet's snapToPixel property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const SNAP_TO_PIXEL:StringIdentifier = new StringIdentifier("snapToPixel");
		
		public function LayoutAttributesFacet()
		{
			_registrationPoint = RegistrationPoint.TOP_LEFT;
			_alignment = RegistrationPoint.TOP_LEFT;
			_scaleMode = null;
		}
		
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
			return MetadataNamespaces.LAYOUT_ATTRIBUTES;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function getValue(identifier:IIdentifier):*
		{
			if (identifier == null)
			{
				return undefined;
			}
			else if (identifier.equals(ORDER))
			{
				return order;
			}
			else if (identifier.equals(REGISTRATION_POINT))
			{
				return registrationPoint;
			}
			else if (identifier.equals(SCALE_MODE))
			{
				return scaleMode;
			}
			else if (identifier.equals(ALIGNMENT))
			{
				return alignment;
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
		
		// Public interface
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired position of the target in the display list
		 * of its context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired position of the target in the display list
		 * of its context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get registrationPoint():RegistrationPoint
		{
			return _registrationPoint;
		}
		public function set registrationPoint(value:RegistrationPoint):void
		{
			if (_registrationPoint != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, REGISTRATION_POINT, value, _registrationPoint);
					
				_registrationPoint = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired scale mode to be applied to the target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired alignment mode to be applied to the target when
		 * scaling of the target leaves a blank space.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get alignment():RegistrationPoint
		{
			return _alignment;
		}
		public function set alignment(value:RegistrationPoint):void
		{
			if (_alignment != value)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(FacetValueChangeEvent.VALUE_CHANGE, false, false, ALIGNMENT, value, _alignment);
					
				_alignment = value;
						
				dispatchEvent(event);
			}
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * If set to true, the target's calculated position and size will
		 * be rounded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		
		// Internals
		//
		
		private var _order:Number = NaN;
		private var _registrationPoint:RegistrationPoint;
		private var _scaleMode:String; // ScaleMode
		private var _alignment:RegistrationPoint;
		private var _snapToPixel:Boolean;
	}
}