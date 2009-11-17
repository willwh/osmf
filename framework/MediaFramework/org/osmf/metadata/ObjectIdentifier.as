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
	/**
	 * The ObjectIdentifier is the implementation of IIdentifier 
	 * used to wrap any given Object.
	 */ 
	public class ObjectIdentifier implements IIdentifier
	{
		/**
		 * Construct an ObjectIdentifier with the specified object as the key.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function ObjectIdentifier(key:Object)
		{
			_key = key;
		}
		
		/**
		 * @returns the key to this Identifier.  The key is the object used
		 * to identify the value within a KeyValueFacet.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function get key():Object
		{
			return _key;
		}
		
		/**
		 * Overridable quality method for comparing two Identifiers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function equals(value:IIdentifier):Boolean
		{
			if(value is ObjectIdentifier)
			{				
				return _key == ObjectIdentifier(value).key;
			}
			return false;
		}
		
		private var _key:Object;
		
	}
}