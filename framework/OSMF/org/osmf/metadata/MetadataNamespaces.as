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
	 *  Contains the static constants for metadata namespaces used with Open Source Media Framework.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class MetadataNamespaces
	{
		/**
		 * The namespace that holds OSMF-specific metadata
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 		
		public static const DEFAULT_METADATA:String						= "http://www.osmf.org/default/1.0";
		public static const METADATA_KEY_MEDIA_TYPE:String				= "mediaType";
		
		public static const MEDIATYPE_METADATA:String					= "http://www.osmf.org/mediatype/default";
		
		public static const SUBCLIP_METADATA:String						= "http://www.osmf.org/subclip/1.0";
		public static const SUBCLIP_START_KEY:String					= "startTime";
		public static const SUBCLIP_END_KEY:String						= "endTime";
		public static const SUBCLIP_START_ID:ObjectIdentifier			= new ObjectIdentifier(SUBCLIP_START_KEY);
		public static const SUBCLIP_END_ID:ObjectIdentifier				= new ObjectIdentifier(SUBCLIP_END_KEY);
		
		public static const DRM_METADATA:String							= "http://www.osmf.org/drm/default";
		public static const DRM_CONTENT_METADATA_KEY:String				= "DRMContentMetadata";
		public static const DRM_ADDITIONAL_HEADER_KEY:String			= "DRMAdditionalHeader";
		
		public static const REGION_TARGET:String						= "http://www.osmf.org/region/target";
		
		public static const LAYOUT_RENDERER_TYPE:String					= "http://www.osmf.org/layout/renderer_type";
		public static const ABSOLUTE_LAYOUT_PARAMETERS:String			= "http://www.osmf.org/layout/absolute";
		public static const RELATIVE_LAYOUT_PARAMETERS:String			= "http://www.osmf.org/layout/relative";
		public static const ANCHOR_LAYOUT_PARAMETERS:String				= "http://www.osmf.org/layout/anchor";
		public static const PADDING_LAYOUT_PARAMETERS:String 			= "http://www.osmf.org/layout/padding";
		public static const LAYOUT_ATTRIBUTES:String 					= "http://www.osmf.org/layout/attributes";
		public static const BOX_LAYOUT_ATTRIBUTES:String				= "http://www.osmf.org/layout/attributes/box";
		
		public static const ELEMENT_ID:String	 						= "http://www.osmf.org/elementId";
		
		public static const TEMPORAL_METADATA_EMBEDDED:String			= "http://www.osmf.org/temporal/embedded";
		public static const TEMPORAL_METADATA_DYNAMIC:String			= "http://www.osmf.org/temporal/dynamic";

		public static const PLUGIN_PARAMETERS:String					= "http://www.osmf.org/plugin/parameters";
		public static const PLUGIN_METADATA_MEDIAFACTORY_KEY:ObjectIdentifier
																		= new ObjectIdentifier("pluginMediaFactory");
		
		public static const HTTP_STREAMING_METADATA:String				= "http://www.osmf.org/httpstreaming/1.0";
		
		public static const HTTP_STREAMING_BOOTSTRAP_KEY:String			= "bootstrap";
		public static const HTTP_STREAMING_STREAM_METADATA_KEY:String 	= "streamMetadata";
		public static const HTTP_STREAMING_XMP_METADATA_KEY:String 		= "xmpMetadata";
		
		public static const HTTP_STREAMING_ABST_URL_KEY:String			= "abstUrl";
		public static const HTTP_STREAMING_ABST_DATA_KEY:String			= "abstData";
		public static const HTTP_STREAMING_SERVER_BASE_URLS_KEY:String 	= "serverBaseUrls";
	}
}
