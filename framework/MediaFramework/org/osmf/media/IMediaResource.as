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
	import org.osmf.metadata.Metadata;
	
	/**
	 * An IMediaResource is a marker interface for media that serves as input
	 * to a MediaElement.
	 * 
	 * <p>Different MediaElement instances can "handle" (i.e. input) different
	 * resource types (e.g. a URL vs. an array of streams), or even different
	 * variations of the same resource type (e.g. a URL with the ".jpg"
	 * extension vs. a URL with a ".mp3" extension).</p>
	 **/
	public interface IMediaResource
	{
		/**
		 * The metadata associated with this media resource.
		 */ 
		function get metadata():Metadata
	}
}