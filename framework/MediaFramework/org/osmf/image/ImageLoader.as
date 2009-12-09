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
package org.osmf.image
{
	import __AS3__.vec.Vector;
	
	import org.osmf.content.ContentLoader;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.utils.*;

	/**
	 * The ImageLoader class creates a flash.display.Loader object, 
	 * which it uses to load and unload an image.
	 * <p>The image is loaded from the URL provided by the
	 * <code>resource</code> property of the ILoadable that is passed
	 * to the ImageLoader's <code>load()</code> method.</p>
	 *
	 * @see ImageElement
	 * @see org.osmf.traits.ILoadable
	 * @see flash.display.Loader
	 */ 
	public class ImageLoader extends ContentLoader
	{
		/**
		 * Constructs a new ImageLoader.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public function ImageLoader()
		{
			super();
		}
		
		/**
		 * Indicates whether this ImageLoader is capable of handling the specified resource.
		 * Returns <code>true</code> for IURLResources with GIF, JPG, or PNG extensions.
		 * @param resource Resource proposed to be loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			var rt:int = MetadataUtils.checkMetadataMatchWithResource(resource, MEDIA_TYPES_SUPPORTED, MIME_TYPES_SUPPORTED);
			if (rt != MetadataUtils.METADATA_MATCH_UNKNOWN)
			{
				return rt == MetadataUtils.METADATA_MATCH_FOUND;
			}			
			
			var urlResource:IURLResource = resource as IURLResource;
			if (urlResource != null &&
				urlResource.url != null)
			{
				return (urlResource.url.path.search(/\.gif$|\.jpg$|\.png$/i) != -1);
			}	
			return false;
		}
		
		// Internals
		//

		private static const MIME_TYPES_SUPPORTED:Vector.<String> = Vector.<String>(["image/png", "image/gif", "image/jpeg"]);
			
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.IMAGE]);
	}
}