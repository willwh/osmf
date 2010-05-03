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
package org.osmf.elements
{
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.URLResource;

	/**
	 * The F4MElement is the MediaElement used to load media from F4M files.  F4M files are
	 * XML documents that adhere to the Flash Media Manifest format.
	 * 
	 * Note: It is simplest to use the MediaPlayer class in conjunction with the F4MElement.
	 * If you work directly with an F4MElement, then it's important to listen for events
	 * related to traits being added and removed.  If you use the MediaPlayer class with an
	 * F4MElement, then the MediaPlayer will automatically listen for these events for you. 
	 * 
	 *
	 * @see http://opensource.adobe.com/wiki/display/osmf/Flash%2BMedia%2BManifest%2BFile%2BFormat%2BSpecification Flash Media Manifest File Format Specification
	 *
	 * @see org.osmf.media.MediaPlayer
	 * 
 	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0	 	 	
	 *	 
	 */
  	public class F4MElement extends LoadFromDocumentElement
	{
		/**
		 * Creates a new F4MElement. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function F4MElement(resource:URLResource = null, loader:F4MLoader = null)
		{
			if (loader == null)
			{
				loader = new F4MLoader();
			}			
			super(resource, loader);									
		}	
	}
}