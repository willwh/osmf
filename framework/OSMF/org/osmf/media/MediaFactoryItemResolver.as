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
package org.osmf.media
{
	import __AS3__.vec.Vector;
	
	/**
	 * Resolver class used by a MediaFactory to select one of out multiple possible
	 * MediaFactoryItems.
	 * 
	 * <p>When multiple MediaFactoryItems can handle a media resource, an arbitration
	 * is needed to pick the most suitable one.  This class encapsulates the details
	 * of how to pick the right item out of a list of candidates.</p>
	 * 
	 * <p>By default, this class selects the first one.  Clients can subclass this
	 * to provide their own selection logic.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MediaFactoryItemResolver
	{
		/**
		 * Returns the most appropriate MediaFactoryItem for the specified resource
		 * out of the MediaFactoryItems in the specified list.
		 */
		public function resolveItems(resource:MediaResourceBase, items:Vector.<MediaFactoryItem>):MediaFactoryItem
		{
			if (resource == null || items == null)
			{
				return null;
			}
			
			// Select the first item in the list
			return items.length > 0 ? items[0] : null;		
		}
	}
}