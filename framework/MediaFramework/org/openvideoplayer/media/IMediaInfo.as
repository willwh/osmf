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
package org.openvideoplayer.media
{
	/**
	 * An IMediaInfo is an encapsulation of the information needed to
	 * dynamically create a MediaElement.  It extends IMediaResourceHandler
	 * because it needs to indicate for which IMediaResources it can
	 * create corresponding MediaElements.
	 */	
	public interface IMediaInfo extends IMediaResourceHandler
	{
		/**
		 * An identifier that represents this IMediaInfo.
		 **/
		function get id():String;
				
		/**
		 * Returns a MediaElement that can render the given IMediaResource,
		 * null if this IMediaInfo object is not capable of creating such
		 * a MediaElement (as indicated by canHandleResource).
		 * 
		 * @param resource The IMediaResource for which a corresponding
		 * MediaElement should be created.
		 * 
		 * @throws IllegalOperationError If this IMediaInfo object handles
		 * the given resource, but is unable to create a corresponding
		 * MediaElement.
		 **/
		function createMediaElement(resource:IMediaResource):MediaElement;
	}
}