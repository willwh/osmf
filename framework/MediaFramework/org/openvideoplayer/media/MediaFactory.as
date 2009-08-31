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
package org.openvideoplayer.media
{
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	/**
	 * Default implementation of IMediaFactory.
	 **/
	public class MediaFactory implements IMediaFactory
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
		 * @inheritDoc
		 **/
		public function addMediaInfo(info:IMediaInfo):void
		{
			if (info == null || info.id == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var infos:Vector.<IMediaInfo> = findOrCreateInfos(info.type);
			
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
		 * @inheritDoc
		 **/
		public function removeMediaInfo(info:IMediaInfo):void
		{
			if (info == null || info.id == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			var infos:Vector.<IMediaInfo> = allInfos[info.type];
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
		 * @inheritDoc
		 **/
		public function get numMediaInfos():int
		{
			var numInfos:int = 0;
			
			for each (var type:MediaInfoType in MediaInfoType.ALL_TYPES)
			{
				var infos:Vector.<IMediaInfo> = allInfos[type];
				if (infos != null)
				{
					numInfos += infos.length;
				}
			}
			
			return numInfos;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function getMediaInfoAt(index:int):IMediaInfo
		{
			var result:IMediaInfo = null;
			
			if (index >= 0)
			{
				for each (var type:MediaInfoType in MediaInfoType.ALL_TYPES)
				{
					var infos:Vector.<IMediaInfo> = allInfos[type];
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
		 * @inheritDoc
		 **/
		public function getMediaInfoById(id:String):IMediaInfo
		{
			var result:IMediaInfo = null;
			
			for each (var type:MediaInfoType in MediaInfoType.ALL_TYPES)
			{
				var infos:Vector.<IMediaInfo> = allInfos[type];
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
		 * @inheritDoc
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
		
		private function findOrCreateInfos(type:MediaInfoType):Vector.<IMediaInfo>
		{
			if (allInfos[type] == null)
			{
				allInfos[type] = new Vector.<IMediaInfo>();
			}
			
			return allInfos[type] as Vector.<IMediaInfo>;
		}
		
		private function createMediaElementByResource
			( resource:IMediaResource
			, mediaInfoType:MediaInfoType
			, wrappedElement:MediaElement=null
			):MediaElement
		{
			var mediaElement:MediaElement = null;
			
			var infos:Vector.<IMediaInfo> = getMediaInfosByResource(resource, allInfos[mediaInfoType]);
			
			if (mediaInfoType == MediaInfoType.STANDARD)
			{
				var info:IMediaInfo = handlerResolver.resolveHandlers(resource, Vector.<IMediaResourceHandler>(infos)) as IMediaInfo;
				if (info != null)
				{
					mediaElement = info.createMediaElement();
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
					var proxyInfo:IMediaInfo = infos[i-1] as IMediaInfo;
					var proxyElement:ProxyElement = proxyInfo.createMediaElement() as ProxyElement;
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
				
		private static function getMediaInfosByResource(resource:IMediaResource, infos:Vector.<IMediaInfo>):Vector.<IMediaInfo>
		{
			var results:Vector.<IMediaInfo> = new Vector.<IMediaInfo>();
			
			for each (var info:IMediaInfo in infos)
			{
				if (info.canHandleResource(resource) == true)
				{
					results.push(info);
				}
			}
			
			return results;
		}
		
		private static function getIndexOfMediaInfo(id:String, infos:Vector.<IMediaInfo>):int
		{
			for (var i:int = 0; i < infos.length; i++)
			{
				var info:IMediaInfo = infos[i] as IMediaInfo;
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
			// Values are: Vector.<IMediaInfo>
		
		private var createdElements:Dictionary;
			// Keys are: MediaElement
			// Values are: MediaElement

		private var referrers:Dictionary;
			// Keys are: IMediaReferrer
			// Values are: IMediaReferrer
	}
}