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
	import org.openvideoplayer.utils.URL;
	
	/**
	 *  Contains the static constants for metadata namespaces used with Open Source Media Framework.
	 */
	public class MetadataNamespaces
	{
		/**
		 * The namespace that holds OSMF specific metadata
		 */ 		
		public static const DEFAULT_METADATA:URL			= new URL("http://www.openvideoplayer.org/default/1.0");
		public static const MEDIATYPE_METADATA:URL			= new URL("http://www.openvideoplayer.org/media/type");
		
		public static const REGION_TARGET:URL				= new URL("http://www.openvideoplayer.org/region/target");
		
		public static const LAYOUT_RENDERER:URL				= new URL("http://www.openvideoplayer.org/layout/renderer");
		public static const ABSOLUTE_LAYOUT_PARAMETERS:URL	= new URL("http://www.openvideoplayer.org/layout/absolute");
		public static const RELATIVE_LAYOUT_PARAMETERS:URL	= new URL("http://www.openvideoplayer.org/layout/relative");
		public static const ANCHOR_LAYOUT_PARAMETERS: URL	= new URL("http://www.openvideoplayer.org/layout/anchor");
		public static const PADDING_LAYOUT_PARAMETERS:URL 	= new URL("http://www.openvideoplayer.org/layout/padding");
		public static const LAYOUT_ATTRIBUTES: URL 			= new URL("http://www.openvideoplayer.org/layout/attributes");
		
		public static const ELEMENT_ID: URL 				= new URL("http://www.openvideoplayer.org/elementId");
	}
}