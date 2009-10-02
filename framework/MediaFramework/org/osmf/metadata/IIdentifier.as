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
	 * The IIdentifier interface is a marker for an object which can serve as a pointer into
	 * a collection of objects.  The IIdentifier should point to one value within the collection.
	 * an equality function is required to determine of two keys are pointing to the 
	 * same value.
	 */ 
	public interface IIdentifier
	{
		/**
		 * Determines if this IIdentifier is equal to the value parameter.
		 */ 
		function equals(value:IIdentifier):Boolean;
	}
}