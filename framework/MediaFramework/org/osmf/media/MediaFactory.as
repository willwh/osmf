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
package org.osmf.media
{
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	
	import org.osmf.proxies.ProxyElement;
	import org.osmf.utils.MediaFrameworkStrings;
	
	/**
	 * A MediaFactory represents a factory class for media elements.
	 * 
	 * <p>The factory operation takes an IMediaResource as input and produces a MediaElement
	 * as output.</p>
	 * <p>The MediaFactory maintains a list of MediaInfo objects,
	 * each of which encapsulates all the information necessary to create 
	 * a specific MediaElement. The MediaFactory relies on
	 * the <code>IMediaResourceHandler.canHandleResource()</code> method to find a MediaInfo
	 * object than can handle the specified IMediaResource.</p>
	 *
	 * <p>The factory interface also exposes methods for querying for specific MediaInfo 
	 * objects.</p>
	 * @see MediaInfo
	 * @see IMediaResource
	 * @see IMediaResourceHandler    
	 * @see MediaElement
	 */	
	public class MediaFactory
	{
		/**
		 * Constructor.
		 **/
		public function MediaFactory(handlerResolver:IMediaResourceHandlerResolver=null)
		{
			allInfos = new Dictionary();
			
			// Our two dictionaries are set to store with weak keys, so that
			// if this object is the only object that references either a
			// created MediaElement or a referrer, then the MediaElement or
			// referrer will still be garbage collected.
			createdElements = new Dictionary(false);
			referrers = new Dictionary(false);
			
			this.handlerResolver
				= (handlerResolver == null)? new DefaultMediaResourceHandlerResolver() : handlerResolver;
		}
		
		/**
		 * Adds the specified MediaInfo to the factory.
		 * After the MediaInfo has been added, for any IMediaResource
		 * that this MediaInfo can handle, the factory will be able to create
		 * the corresponding media element.
		 * 
		 * If a MediaInfo with the same ID already exists in this
		 * factory, the new MediaInfo object replaces it.
		 * 
		 * @param info The MediaInfo to add.
		 * 
		 * @throws ArgumentError If the argument is <code>null</code> or if the argument
		 * has a <code>null</code> ID field.
		 **/
		public function addMediaInfo(info:MediaInfo):void
		{
			if (info == null || info.id == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var infos:Vector.<MediaInfo> = findOrCreateInfos(info.type);
			
			// Make sure to overwrite any duplicate.
			var existingIndex:int = getIndexOfMediaInfo(info.id, infos);
			if (existingIndex != -1)
			{
				infos[existingIndex] = info;
			}
			else
			{
				infos.push(info);
			}
		}
		
		/**
		 * Removes the specified MediaInfo from the factory.
		 * 
		 * If no such MediaInfo exists in this factory, does nothing.
		 * 
		 * @param info The MediaInfo to remove.
		 * 
		 * @throws ArgumentError If the argument is <code>null</code> or if the argument
		 * has a <code>null</code> ID field.
		 **/
		public function removeMediaInfo(info:MediaInfo):void
		{
			if (info == null || info.id == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var infos:Vector.<MediaInfo> = allInfos[info.type];
			if (infos != null)
			{
				var existingIndex:int = infos.indexOf(info);
				if (existingIndex != -1)
				{
					infos.splice(existingIndex, 1);
				}
			}
		}

		/**
		 * The number of MediaInfos managed by the factory.
		 **/
		public function get numMediaInfos():int
		{
			var numInfos:int = 0;
			
			for each (var type:MediaInfoType in MediaInfoType.ALL_TYPES)
			{
				var infos:Vector.<MediaInfo> = allInfos[type];
				if (infos != null)
				{
					numInfos += infos.length;
				}
			}
			
			return numInfos;
		}
		
		/**
		 * Gets the MediaInfo at the specified index.
		 * 
		 * @param index The index in the list from which to retrieve the MediaInfo.
		 * 
		 * @return The MediaInfo at that index or <code>null</code> if there is none.
		 **/
		public function getMediaInfoAt(index:int):MediaInfo
		{
			var result:MediaInfo = null;
			
			if (index >= 0)
			{
				for each (var type:MediaInfoType in MediaInfoType.ALL_TYPES)
				{
					var infos:Vector.<MediaInfo> = allInfos[type];
					if (infos != null)
					{
						if (index < infos.length)
						{
							result = infos[index];
							break;
						}
						else
						{
							// Not in this list, try the next.
							index -= infos.length;
						}
					}
				}
			}
			
			return result;
		}

		/**
		 * Returns the MediaInfo with the specified ID or <code>null</code> if the
		 * specified MediaInfo does not exist in this factory.
		 * 
		 * @param The ID of the MediaInfo to retrieve.
		 * 
		 * @return The MediaInfo with the specified ID or <code>null</code> if the specified
		 * MediaInfo does not exist in this factory. 
		 **/
		public function getMediaInfoById(id:String):MediaInfo
		{
			var result:MediaInfo = null;
			
			for each (var type:MediaInfoType in MediaInfoType.ALL_TYPES)
			{
				var infos:Vector.<MediaInfo> = allInfos[type];
				if (infos != null)
				{
					var existingIndex:int = getIndexOfMediaInfo(id, infos);
					if (existingIndex != -1)
					{
						result = infos[existingIndex];
						break;
					}
				}
			}
			
			return result;
		}

		/**
		 * Returns a MediaElement that can be created based on the specified
		 * IMediaResource.
		 * <p>Returns <code>null</code> if the
		 * <code>IMediaResourceHandler.canHandleResource()</code> method cannot         
		 * find a MediaInfo object
		 * capable of creating such a MediaElement in this factory.</p>
		 * 
		 * @see IMediaResourceHandler#canHandleResource()
		 *
		 * @param resource The IMediaResource for which a corresponding
		 * MediaElement should be created.
		 * 
		 * @return The MediaElement that was created or <code>null</code> if no such
		 * MediaElement could be created from the IMediaResource.
		 **/
		public function createMediaElement(resource:IMediaResource):MediaElement
		{
			// Note that proxies are resolved before references are applied:
			// if a media element is proxied, then references apply to the root
			// proxy, not the wrapped media element.
			// 

			// We attempt to create a MediaElement of the STANDARD type.
			var mediaElement:MediaElement = createMediaElementByResource(resource, MediaInfoType.STANDARD);
			if (mediaElement != null)
			{
				var proxyElement:MediaElement = 
						createMediaElementByResource
							( mediaElement.resource
							, MediaInfoType.PROXY
							, mediaElement			/* element to wrap */
							);
				
				// If we have a corresponding ProxyElement, then instead of
				// returning the STANDARD MediaElement, we instead return that
				// PROXY element as the wrapper for the STANDARD element.
				mediaElement = (proxyElement != null ? proxyElement : mediaElement);
				
				// Set up any references to the created MediaElement.
				addReferencesToMediaElement(mediaElement);
				
				// If the created element is a referrer element, we should
				// register it as such.
				var newReferrer:IMediaReferrer = mediaElement as IMediaReferrer;
				if (newReferrer != null)
				{
					// Set up any references from the new referrer to other
					// MediaElements.
					addReferenceToCreatedMediaElements(newReferrer);
	
					// Add the new referrer to our list of referrers, so that it
					// can acquire references to any (relevant) MediaElements that
					// are created in the future.
					referrers[newReferrer] = newReferrer;
				}
							
				// Add the newly created MediaElement (or its root proxy) to
				// our list of created elements, so that it can be added as a
				// reference to future reference elements too.
				createdElements[mediaElement] = mediaElement;
			}
			
			return mediaElement;
		}
		
		// Internals
		//
		
		private function findOrCreateInfos(type:MediaInfoType):Vector.<MediaInfo>
		{
			if (allInfos[type] == null)
			{
				allInfos[type] = new Vector.<MediaInfo>();
			}
			
			return allInfos[type] as Vector.<MediaInfo>;
		}
		
		private function createMediaElementByResource
			( resource:IMediaResource
			, mediaInfoType:MediaInfoType
			, wrappedElement:MediaElement=null
			):MediaElement
		{
			var mediaElement:MediaElement = null;
			
			var infos:Vector.<MediaInfo> = getMediaInfosByResource(resource, allInfos[mediaInfoType]);
			
			if (mediaInfoType == MediaInfoType.STANDARD)
			{
				var info:MediaInfo = handlerResolver.resolveHandlers(resource, Vector.<IMediaResourceHandler>(infos)) as MediaInfo;
				if (info != null)
				{
					try
					{
						mediaElement = info.mediaElementCreationFunction.call();
					}
					catch (error:Error)
					{
						// Swallow, the creation function is wrongly specified.
						// We'll just return a null MediaElement.
					}
				}
			}
			else if (mediaInfoType == MediaInfoType.PROXY)
			{
				var nextElementToWrap:MediaElement = wrappedElement;
				
				// Create our chain of proxies, starting from the bottom so
				// that we can assign the base wrapped element.  (Note that
				// we iterate from the end to the beginning simply to make
				// it easier to assign the wrappedElement in our for loop.
				// In the future, we may want to provide control for the
				// ordering to the client through some type of resolver.
				for (var i:int = infos.length; i > 0; i--)
				{
					var proxyInfo:MediaInfo = infos[i-1] as MediaInfo;
					var proxyElement:ProxyElement = proxyInfo.mediaElementCreationFunction.call() as ProxyElement;
					if (proxyElement != null)
					{
						proxyElement.wrappedElement = nextElementToWrap;
					
						nextElementToWrap = proxyElement;
					}
				}
				
				mediaElement = nextElementToWrap;
			}
			
			if (mediaElement != null)
			{
				mediaElement.resource = resource;
			}
			
			return mediaElement;
		}
				
		private static function getMediaInfosByResource(resource:IMediaResource, infos:Vector.<MediaInfo>):Vector.<MediaInfo>
		{
			var results:Vector.<MediaInfo> = new Vector.<MediaInfo>();
			
			for each (var info:MediaInfo in infos)
			{
				if (info.canHandleResource(resource) == true)
				{
					results.push(info);
				}
			}
			
			return results;
		}
		
		private static function getIndexOfMediaInfo(id:String, infos:Vector.<MediaInfo>):int
		{
			for (var i:int = 0; i < infos.length; i++)
			{
				var info:MediaInfo = infos[i] as MediaInfo;
				if (info.id == id)
				{
					return i;
				}
			}
			
			return -1;
		}

		private function addReferenceToCreatedMediaElements(newReferrer:IMediaReferrer):void
		{
			for each (var element:MediaElement in createdElements)
			{
				if (newReferrer.canReferenceMedia(element))
				{
					newReferrer.addReference(element);
				}
			}
		}
		
		private function addReferencesToMediaElement(mediaElement:MediaElement):void
		{
			for each (var referrer:IMediaReferrer in referrers)
			{
				if (referrer.canReferenceMedia(mediaElement))
				{
					referrer.addReference(mediaElement);
				}
			}
		}

		private var handlerResolver:IMediaResourceHandlerResolver;
		
		private var allInfos:Dictionary;
			// Keys are: MediaInfoType
			// Values are: Vector.<MediaInfo>
		
		private var createdElements:Dictionary;
			// Keys are: MediaElement
			// Values are: MediaElement

		private var referrers:Dictionary;
			// Keys are: IMediaReferrer
			// Values are: IMediaReferrer
	}
}