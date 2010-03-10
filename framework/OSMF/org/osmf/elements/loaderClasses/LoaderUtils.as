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
package org.osmf.elements.loaderClasses
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
						
			var info:LoaderInfo = loader.contentLoaderInfo;  
			
			
			//The display object must be a loader in order to support crossdomain
			//swf loading.
			
			//The content of a loaded swf can be accessed (at the developers discrection) 
			// by casting the display object back to a loader and accessing it's content property.
			displayObject = loader;
			
			
			// Add a scroll rect, to allow the loaded content to
			// overdraw its bounds, while maintaining scale, and size
			// with the layout system.
			//
			displayObject.scrollRect = new Rectangle(0, 0, info.width, info.height);
			
			mediaWidth = info.width;
			mediaHeight = info.height;

			return new DisplayObjectTrait(displayObject, mediaWidth, mediaHeight);
		}
		
		/**
		 * Loads the given LoadTrait.
		 **/
		public static function loadLoadTrait(loadTrait:LoadTrait, updateLoadTraitCallback:Function, useCurrentSecurityDomain:Boolean):void
		{
			var loaderLoadTrait:LoaderLoadTrait = loadTrait as LoaderLoadTrait;

			var loader:Loader = new Loader();
			loaderLoadTrait.loader = loader;
			
			updateLoadTraitCallback(loadTrait, LoadState.LOADING);
			
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
				
				updateLoadTraitCallback(loadTrait, LoadState.READY);
			}

			function onIOError(ioEvent:IOErrorEvent, ioEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				loader = null;
				
				updateLoadTraitCallback(loadTrait, LoadState.LOAD_ERROR);
				loadTrait.dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError
							( MediaErrorCodes.IMAGE_OR_SWF_IO_LOAD_ERROR
							, ioEvent ? ioEvent.text : ioEventDetail
							)
						)
					);
			}

			function onSecurityError(securityEvent:SecurityErrorEvent, securityEventDetail:String=null):void
			{	
				toggleLoaderListeners(loader, false);
				loader = null;
				
				updateLoadTraitCallback(loadTrait, LoadState.LOAD_ERROR);
				loadTrait.dispatchEvent
					( new MediaErrorEvent
						( MediaErrorEvent.MEDIA_ERROR
						, false
						, false
						, new MediaError
							( MediaErrorCodes.IMAGE_OR_SWF_SECURITY_LOAD_ERROR
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
			var loaderLoadTrait:LoaderLoadTrait = loadTrait as LoaderLoadTrait;
			updateLoadTraitCallback(loadTrait, LoadState.UNLOADING);			
			loaderLoadTrait.loader.unloadAndStop();
			updateLoadTraitCallback(loadTrait, LoadState.UNINITIALIZED);
		}
		
		private static const SWF_MIME_TYPE:String = "application/x-shockwave-flash";
	}
}