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
	 * When multiple MediaInfo can handle a media resource, an arbitration is needed to 
	 * pick the most suitable MediaInfo. This class encapsulates the details of how to 
	 * pick the right resource handler out of a list of candidates.
	 */
	public interface IMediaResourceHandlerResolver
	{
		/**
		* Given a resource and a Vector of IMediaResourceHandlers, returns the handler 
		* that has the highest relevance/priority for the given resource.
		**/
		function resolveHandlers(
			resource:IMediaResource, handlers:Vector.<IMediaResourceHandler>):IMediaResourceHandler;
	}
}