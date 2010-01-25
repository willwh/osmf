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
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.geom.Rectangle;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.LoadableMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * ContentElement is a media element that can present the content loaded
	 * by a flash.display.Loader.

	 * @see flash.display.Loader
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
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
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function ContentElement(loader:ContentLoader, resource:URLResource = null)
		{
			super(loader, resource);
		}
		
		// Overrides
		//
		
		/**
		 * @private 
		 */ 		
		override protected function createLoadTrait(loader:ILoader, resource:MediaResourceBase):LoadTrait
		{
			return new ContentLoadTrait(loader, resource);
		}
		
		/**
		 * @private 
		 */ 		
		override protected function processReadyState():void
		{
			var context:ContentLoadedContext
				=	(getTrait(MediaTraitType.LOAD) as LoadTrait).loadedContext
				as	ContentLoadedContext;
				
			var displayObject:DisplayObject = null;
			var mediaWidth:Number = 0;
			var mediaHeight:Number = 0;
			
			try
			{
				// Add a scroll rect, to allow the loaded content to
				// overdraw its bounds, while maintaining scale, and size
				// with the layout system.
				//
				// Note that it's critical that the DisplayObjectTrait's
				// displayObject be set to the Loader's content property (and
				// not to a container Sprite,as was the case with a previous fix),
				// since player-to-SWF communication is based on the player's
				// ability to reference the SWF's API.
				var info:LoaderInfo = context.loader.contentLoaderInfo;  
				context.loader.content.scrollRect = new Rectangle(0, 0, info.width, info.height);
				
				displayObject = context.loader.content;
				mediaWidth = info.width;
				mediaHeight = info.height;
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
			
			addTrait
				( MediaTraitType.DISPLAY_OBJECT
				, new DisplayObjectTrait(displayObject, mediaWidth, mediaHeight)
				);
		}
		
		/**
		 *  @private 
		 */ 
		override protected function processUnloadingState():void
		{
			removeTrait(MediaTraitType.DISPLAY_OBJECT);	
		}
	}
}