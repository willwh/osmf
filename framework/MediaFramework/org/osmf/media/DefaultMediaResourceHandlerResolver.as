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
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaResourceHandler;
	
	/**
	 * DefaultMediaResourceHandlerResolver implements IMediaResourceHandlerResolver. It provides
	 * the a default implementation to pick the right resource handler. Since the default
	 * media resource handler resolver has no further knowledge of various resource handlers,
	 * it picks the first resource handler from the candidate list, by default.
	 */
	public class DefaultMediaResourceHandlerResolver implements IMediaResourceHandlerResolver
	{
		public function DefaultMediaResourceHandlerResolver()
		{
		}

		public function resolveHandlers(
			resource:IMediaResource, handlers:Vector.<IMediaResourceHandler>):IMediaResourceHandler
		{
			if (resource == null || handlers == null)
			{
				return null;
			}
			
			// Since the default handler does not have any insight into the selection of handler, 
			// nothing can be better than picking the first handler on the list
			return handlers.length > 0 ? handlers[0] : null;		
		}
	}
}