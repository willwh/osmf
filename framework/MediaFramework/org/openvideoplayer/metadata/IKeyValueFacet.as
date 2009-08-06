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
package org.openvideoplayer.metadata
{
	import __AS3__.vec.Vector;
	
	/**
	 * The KeyValue Facet interface represents a common interface for key value pairs for 
	 * storing metadata in a facet.  The keys are all Object, and the values are all Objects.
	 * Keys and values may not available for garbage collection until they are removed from the collection. 
	 */
	public interface IKeyValueFacet extends IFacet
	{
		/**
		 * Associates the key with the value object.  If the key is already associated with
		 * another object, this will overwrite the association with the new value.
		 * 
		 * @param key the object to associate the value with
		 * @param the value  
		 */ 
		function addValue(key:Object, value:Object):void;
		
		/**
		 * Removes the data associated with the specififed key from this facet.
		 * 
		 * @param key the key associated with the value to be removed.
		 * @returns the removed item
		 */ 
		function removeValue(key:Object):Object;
	
		/**
		 * @returns All of the keys used in this dictionary.
		 */ 
		function get keys():Vector.<Object>;
	
		/**
		 *  @returns the value associated with the specified key.
		 */ 
		function getValue(key:Object):Object;
		
	}
}