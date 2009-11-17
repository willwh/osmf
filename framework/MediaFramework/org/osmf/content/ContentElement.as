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
package org.osmf.content
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.IURLResource;
	import org.osmf.media.LoadableMediaElement;
	import org.osmf.traits.IDownloadable;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SpatialTrait;
	import org.osmf.traits.ViewableTrait;
	
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
		 * 
		 * @throws ArgumentError If loader is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function ContentElement(loader:ContentLoader, resource:IURLResource = null)
		{
			super(loader, resource);
		}
		
		// Overrides
		//
		
		/**
		 *  @private 
		 */ 
		override protected function processLoadingState():void
		{
			var context:ContentLoadedContext
				=	(getTrait(MediaTraitType.LOADABLE) as ILoadable).loadedContext
				as	ContentLoadedContext;
			
			// Add a downloadable trait:
			var downloadable:IDownloadable = new ContentDownloadableTrait(context)
			addTrait(MediaTraitType.DOWNLOADABLE, downloadable);
		}
			
		/**
		 *  @private 
		 */ 		
		override protected function processReadyState():void
		{
			var context:ContentLoadedContext
				=	(getTrait(MediaTraitType.LOADABLE) as ILoadable).loadedContext
				as	ContentLoadedContext;
				
			var viewable:ViewableTrait	= new ViewableTrait();			
			var spatial:SpatialTrait 	= new SpatialTrait();
			
			// TODO: Add comment here on how the error can occur.
			try
			{
				// Add a container layer, to allow the loaded content to
				// overdraw its bounds, while maintaining scale, and size
				// with the layout system.
				var viewContainer:Sprite = new Sprite();
				viewContainer.addChild(context.loader);
				
				var info:LoaderInfo = context.loader.contentLoaderInfo;  
				
				context.loader.scrollRect = new Rectangle(0, 0, info.width, info.height);
						
				viewable.view = viewContainer;
				
				spatial.setDimensions(info.width, info.height);
			}
			catch (error:SecurityError)
			{
				dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError
							( MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR
							, error.message
							)
						)
					);
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
			removeTrait(MediaTraitType.DOWNLOADABLE);
		}
	}
}