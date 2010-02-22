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
	 * Contains the static constants for metadata namespaces and facet keys
	 * used within OSMF.
	 * 
	 * Each of these namespaces represents metadata that can be assigned to
	 * a MediaResourceBase, and which certain MediaElement subclasses will
	 * look for and upon detecting, adjust their behavior.  For example, if
	 * the subclip metadata is assigned to a StreamingURLResource that is
	 * passed to the VideoElement, then the VideoElement will play the
	 * specified subclip, rather than the whole vide.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public final class MetadataNamespaces
	{
		/**
		 * Metadata namespace that holds media type information.
		 **/
		public static const MEDIATYPE_METADATA:String					= "http://www.osmf.org/mediatype/1.0";
		
		/**
		 * Metadata namespace that holds subclip information.
		 **/
		public static const SUBCLIP_METADATA:String						= "http://www.osmf.org/subclip/1.0";
		
		/**
		 * Metadata FacetKey for the subclip startTime property.
		 **/
		public static const SUBCLIP_START_TIME_KEY:FacetKey				= new FacetKey("startTime");

		/**
		 * Metadata FacetKey for the subclip endTime property.
		 **/
		public static const SUBCLIP_END_TIME_KEY:FacetKey				= new FacetKey("endTime");
		
		/**
		 * Metadata namespace that holds DRM metadata.
		 **/
		public static const DRM_METADATA:String							= "http://www.osmf.org/drm/1.0";
		
		/**
		 * Metadata FacetKey for DRM content metadata.
		 **/
		public static const DRM_CONTENT_METADATA_KEY:FacetKey			= new FacetKey("DRMContentMetadata");

		/**
		 * Metadata FacetKey for the DRM additional header.
		 **/
		public static const DRM_ADDITIONAL_HEADER_KEY:FacetKey			= new FacetKey("DRMAdditionalHeader");
		
		/**
		 * Metadata namespace that holds embedded temporal metadata.
		 **/
		public static const TEMPORAL_EMBEDDED_METADATA:String			= "http://www.osmf.org/metadata/temporalEmbedded/1.0";

		/**
		 * Metadata namespace that holds dynamic (runtime) temporal metadata.
		 **/
		public static const TEMPORAL_DYNAMIC_METADATA:String			= "http://www.osmf.org/metadata/temporalDynamic/1.0";

		/**
		 * Metadata namespace that holds parameters that are passed from OSMF to
		 * plugins.
		 **/
		public static const PLUGIN_METADATA:String						= "http://www.osmf.org/plugin/parameters/1.0";

		/**
		 * Metadata FacetKey for a MediaFactory that is a parameter from the
		 * player to a plugin. 
		 **/
		public static const PLUGIN_MEDIAFACTORY_KEY:FacetKey	= new FacetKey("pluginMediaFactory");

		// Internal OSMF Namespaces
		//
		
		/**
		 * @private
		 **/
		public static const DVRCAST_METADATA:String						= "http://www.osmf.org/dvr/dvrcast/1.0";

		/**
		 * @private
		 * 
		 * Used by the layout system to log individual IDs of regions.  For debugging only.
		 **/
		public static const ELEMENT_ID:String	 						= "http://www.osmf.org/layout/elementId/1.0";

		/**
		 * @private
		 **/
		public static const LAYOUT_RENDERER_TYPE:String					= "http://www.osmf.org/layout/renderer_type/1.0";

		/**
		 * @private
		 **/
		public static const ABSOLUTE_LAYOUT_PARAMETERS:String			= "http://www.osmf.org/layout/absolute/1.0";

		/**
		 * @private
		 **/
		public static const RELATIVE_LAYOUT_PARAMETERS:String			= "http://www.osmf.org/layout/relative/1.0";

		/**
		 * @private
		 **/
		public static const ANCHOR_LAYOUT_PARAMETERS:String				= "http://www.osmf.org/layout/anchor/1.0";

		/**
		 * @private
		 **/
		public static const PADDING_LAYOUT_PARAMETERS:String 			= "http://www.osmf.org/layout/padding/1.0";

		/**
		 * @private
		 **/
		public static const LAYOUT_ATTRIBUTES:String 					= "http://www.osmf.org/layout/attributes/1.0";

		/**
		 * @private
		 **/
		public static const BOX_LAYOUT_ATTRIBUTES:String				= "http://www.osmf.org/layout/attributes/box/1.0";
		
		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_METADATA:String				= "http://www.osmf.org/httpstreaming/1.0";
		
		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_BOOTSTRAP_KEY:String			= "bootstrap";

		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_STREAM_METADATA_KEY:String 	= "streamMetadata";

		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_XMP_METADATA_KEY:String 		= "xmpMetadata";
		
		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_ABST_URL_KEY:String			= "abstUrl";

		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_ABST_DATA_KEY:String			= "abstData";

		/**
		 * @private
		 **/
		public static const HTTP_STREAMING_SERVER_BASE_URLS_KEY:String 	= "serverBaseUrls";
	}
}
