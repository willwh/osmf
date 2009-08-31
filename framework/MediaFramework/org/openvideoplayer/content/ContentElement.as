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
package org.openvideoplayer.content
{
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.LoadableMediaElement;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	
	/**
	 * ContentElement is a media element that can present the content loaded
	 * by a flash.display.Loader.

	 * @see flash.display.Loader
	 */
	public class ContentElement extends LoadableMediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param loader ContentLoader used to load the content.
		 * @param resource Url that points to the content that the ContentElement will use.
		 */		
		public function ContentElement(loader:ContentLoader = null, resource:IURLResource = null)
		{
			super(loader, resource);		
		}
			
		/**
		 *  @private 
		 */ 		
		override protected function processLoadedState():void
		{
			var context:ContentLoadedContext = (getTrait(MediaTraitType.LOADABLE) as ILoadable).loadedContext as ContentLoadedContext;
			var viewable:ViewableTrait	= new ViewableTrait();			
			var spatial:SpatialTrait 	= new SpatialTrait();
			
			// TODO: Add comment here on how the error can occur.
			try
			{
				viewable.view = context.loader.content;
				spatial.setDimensions(context.loader.contentLoaderInfo.width, context.loader.contentLoaderInfo.height);
			}
			catch (error:SecurityError)
			{
				dispatchEvent(new MediaErrorEvent(new MediaError(MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR, error.message)));
			}
			
			addTrait(MediaTraitType.VIEWABLE, viewable);
			addTrait(MediaTraitType.SPATIAL, spatial);
		}
		
		/**
		 *  @private 
		 */ 
		override protected function processUnloadingState():void
		{
			removeTrait(MediaTraitType.SPATIAL);
			removeTrait(MediaTraitType.VIEWABLE);	
		}		
	}
}