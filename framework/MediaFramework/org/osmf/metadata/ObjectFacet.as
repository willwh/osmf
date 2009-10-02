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
	import org.osmf.utils.URL;

	/**
	 * ObjectFacet defines a facet that holds a single object value.
	 */	
	public class ObjectFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Constructor
		 * 
		 * @param namespaceURL Namespace for the object facet.
		 * @param value Value of the object facet.
		 * 
		 */		
		public function ObjectFacet(namespaceURL:URL, value:Object)
		{
			_namespaceURL = namespaceURL;
			_object = value;
		}
		
		/**
		 * Defines this facet's object value. 
		 */		
		public function set object(value:Object):void
		{
			if (value != _object)
			{
				var event:FacetValueChangeEvent
					= new FacetValueChangeEvent(null, value, _object);
					
				_object = value;
				
				dispatchEvent(event);
			}
		}
		public function get object():Object
		{
			return _object;
		}
		
		// IFacet
		//
		
		/**
		 * @inheritDoc
		 */
		public function get namespaceURL():URL
		{
			return _namespaceURL;
		}
		
		/**
		 * Always returns the set object value.
		 * @inheritDoc
		 */
		public function getValue(identifier:IIdentifier):*
		{
			return _object;
		}
		
		/**
		 * @inheritDoc
		 */
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return _object.toString();
		}
		
		// Internals
		//
		
		protected var _namespaceURL:URL;
		protected var _object:Object;
	}
}