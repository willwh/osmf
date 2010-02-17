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
	import flash.events.EventDispatcher;
	
	import org.osmf.events.FacetValueChangeEvent;

	/**
	 * ObjectFacet defines a facet that holds a single object value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class ObjectFacet extends Facet
	{
		/**
		 * Constructor
		 * 
		 * @param namespaceURL Namespace for the object facet.
		 * @param value Value of the object facet.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function ObjectFacet(namespaceURL:String, value:Object, synthesizer:Class = null)
		{
			super(namespaceURL);
			_object = value;
			
			// If no synthesizer is specified, then use the default one:
			synthesizer ||= FacetSynthesizer;
			_synthesizer = new synthesizer(namespaceURL);
		}
		
		/**
		 * Defines this facet's object value. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function set object(value:Object):void
		{
			if (value != _object)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent
						( FacetValueChangeEvent.VALUE_CHANGE
						, false
						, false
						, null
						, value
						, _object
						);
					
				_object = value;
				
				dispatchEvent(event);
			}
		}
		public function get object():Object
		{
			return _object;
		}
						
		/**
		 * Always returns the set object value.
		 * 
		 * @private
		 */
		override public function getValue(identifier:IIdentifier):*
		{
			return _object;
		}
		
		/**
		 * @private
		 */
		override public function get synthesizer():FacetSynthesizer
		{
			return _synthesizer;
		}
		
		// Overrides
		//
		
		/**
		 * @private
		 */
		override public function toString():String
		{
			return _object.toString();
		}
		
		// Internals
		//
		
		protected var _object:Object;
		
		private var _synthesizer:FacetSynthesizer;
	}
}