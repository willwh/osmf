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
package org.osmf.model
{
	import __AS3__.vec.Vector;
	
	import org.osmf.media.*;
	
	public class AppResourceHandlerResolver extends MediaFactoryItemResolver
	{
		public function AppResourceHandlerResolver()
		{
		}

		override public function resolveItems(
			resource:MediaResourceBase, items:Vector.<MediaFactoryItem>):MediaFactoryItem
		{
			if (items == null || items.length <= 0)
			{
				return null;
			}
			
			var descriptor:ResourceHandlerDescriptor 
				= Model.getInstance().getResourceHandlerByMediaFactoryItemId((items[0] as MediaFactoryItem).id);
			
			var item:MediaFactoryItem = null;
			
			for (var i:int = 1; i < items.length; i++)
			{
				var iterDescriptor:ResourceHandlerDescriptor
					= Model.getInstance().getResourceHandlerByMediaFactoryItemId((items[i] as MediaFactoryItem).id);
				
				if (iterDescriptor.priority > descriptor.priority)
				{
					item = iterDescriptor.item;
				}
			}
			
			return item;
		}
	}
}