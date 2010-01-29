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
package org.osmf.swf
{
	import flash.display.ActionScriptVersion;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.utils.*;

	[ExcludeClass]
	
	/**
	 * @private
	 **/
	public class LoaderUtils
	{
		/**
		 * Creates a DisplayObjectTrait for the content in the given
		 * flash.display.Loader.
		 **/
		public static function createDisplayObjectTrait(loader:Loader, mediaElement:MediaElement):DisplayObjectTrait
		{
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
				// not to a container Sprite, as was the case with a previous fix),
				// since player-to-SWF communication is based on the player's
				// ability to reference the SWF's API.
				var info:LoaderInfo = loader.contentLoaderInfo;  
				loader.content.scrollRect = new Rectangle(0, 0, info.width, info.height);
				
				if (info.contentType == SWF_MIME_TYPE &&
					info.actionScriptVersion == ActionScriptVersion.ACTIONSCRIPT2)
				{
					// You can't change the parent of an AVM1 SWF, instead you have
					// to add the Loader directly. 
					displayObject = loader;
				}
				else
				{
					displayObject = loader.content;
				}
				mediaWidth = info.width;
				mediaHeight = info.height;
			}
			catch (error:SecurityError)
			{
				mediaElement.dispatchEvent
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

			return new DisplayObjectTrait(displayObject, mediaWidth, mediaHeight);
		}
		
		/**
		 * Loads the given LoadTrait.
		 **/
		public static function loadLoadTrait(loadTrait:LoadTrait, updateLoadTraitCallback:Function, useCurrentSecurityDomain:Boolean):void
		{
			var loader:Loader = new Loader();
			var loadedContext:LoaderLoadedContext = new LoaderLoadedContext(loader);
			
			updateLoadTraitCallback(loadTrait, LoadState.LOADING, loadedContext);
			
			var context:LoaderContext 	= new LoaderContext();
			var urlReq:URLRequest 		= new URLRequest((loadTrait.resource as URLResource).url.toString());
			
			context.checkPolicyFile = true;
			if (useCurrentSecurityDomain)
			{
				context.securityDomain = SecurityDomain.currentDomain;
			}
			
			toggleLoaderListeners(loader, true);
			try
			{
				loader.load(urlReq, context);
			}
			catch (ioError:IOError)
			{
				onIOError(null, ioError.message);
			}
			catch (securityError:SecurityError)
			{
				onSecurityError(null, securityError.message);
			}

			function toggleLoaderListeners(loader:Loader, on:Boolean):void
			{
				if (on)
				{
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
				else
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
			}
		
			function onLoadComplete(event:Event):void
			{
				toggleLoaderListeners(loader, false);
				
				updateLoadTraitCallback(loadTrait, LoadState.READY, loadedContext);
			}

			function onIOError(ioEvent:IOErrorEvent, ioEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				loader = null;
				loadedContext = null;
				
				updateLoadTraitCallback(loadTrait, LoadState.LOAD_ERROR, null);
				loadTrait.dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError
							( MediaErrorCodes.CONTENT_IO_LOAD_ERROR
							, ioEvent ? ioEvent.text : ioEventDetail
							)
						)
					);
			}

			function onSecurityError(securityEvent:SecurityErrorEvent, securityEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				loader = null;
				loadedContext = null;
				
				updateLoadTraitCallback(loadTrait, LoadState.LOAD_ERROR, loadedContext);
				loadTrait.dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError
							( MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR
							, securityEvent ? securityEvent.text : securityEventDetail
							)
						)
					);
			}
		}
		
		/**
		 * Unloads the given LoadTrait.
		 **/
		public static function unloadLoadTrait(loadTrait:LoadTrait, updateLoadTraitCallback:Function):void
		{
			var context:LoaderLoadedContext = loadTrait.loadedContext as LoaderLoadedContext;
			updateLoadTraitCallback(loadTrait, LoadState.UNLOADING, context);			
			context.loader.unloadAndStop();
			updateLoadTraitCallback(loadTrait, LoadState.UNINITIALIZED);

		}
		
		private static const SWF_MIME_TYPE:String = "application/x-shockwave-flash";
	}
}