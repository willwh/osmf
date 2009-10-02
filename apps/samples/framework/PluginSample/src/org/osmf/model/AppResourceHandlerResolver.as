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
	
	public class AppResourceHandlerResolver implements IMediaResourceHandlerResolver
	{
		public function AppResourceHandlerResolver()
		{
			defaultResolver = new DefaultMediaResourceHandlerResolver();
		}

		public function resolveHandlers(
			resource:IMediaResource, handlers:Vector.<IMediaResourceHandler>):IMediaResourceHandler
		{
			if (handlers == null || handlers.length <= 0)
			{
				return null;
			}
			
			var handler:ResourceHandlerDescriptor 
				= Model.getInstance().getResourceHandlerByMediaInfoId((handlers[0] as IMediaInfo).id);
				
			for (var i:int = 1; i < handlers.length; i++)
			{
				var item:ResourceHandlerDescriptor
					= Model.getInstance().getResourceHandlerByMediaInfoId((handlers[i] as IMediaInfo).id);
				
				if (item.priority > handler.priority)
				{
					handler = item;
				}
			}
			
			return handler.mediaInfo;
		}
		
		private var defaultResolver:DefaultMediaResourceHandlerResolver;
	}
}