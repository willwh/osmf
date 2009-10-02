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
package org.osmf.vast.model
{
	/**
	 * Enumeration of possible values for the VAST resourceType attribute.
	 **/
	public class VASTResourceType
	{
		/**
		 * Event constant for an iframe resource type.
		 **/
		public static const IFRAME:VASTResourceType = new VASTResourceType("iframe");

		/**
		 * Event constant for a script resource type.
		 **/
		public static const SCRIPT:VASTResourceType = new VASTResourceType("script");

		/**
		 * Event constant for an HTML resource type.
		 **/
		public static const HTML:VASTResourceType 	= new VASTResourceType("html");

		/**
		 * Event constant for a static resource type.
		 **/
		public static const STATIC:VASTResourceType = new VASTResourceType("static");

		/**
		 * Event constant for resource type of some other type.
		 **/
		public static const OTHER:VASTResourceType 	= new VASTResourceType("other");

		
		/**
		 * @private
		 * 
		 * Constructor.
		 * 
		 * @param name The name of the resource type.
		 **/
		public function VASTResourceType(name:String)
		{
			this.name = name;
		}
		
		/**
		 * Returns the resource type constant that matches the given name, null if
		 * there is none.
		 **/
		public static function fromString(name:String):VASTResourceType
		{
			var lowerCaseName:String = name != null ? name.toLowerCase() : name;
			
			for each (var resourceType:VASTResourceType in ALL_TYPES)
			{
				if (lowerCaseName == resourceType.name)
				{
					return resourceType;
				}
			}
			
			return null;
		}
		
		private static const ALL_TYPES:Array
			= [ IFRAME
			  , SCRIPT
			  , HTML
			  , STATIC
			  , OTHER
			  ];
		
		private var name:String;
	}
}