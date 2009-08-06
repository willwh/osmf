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
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	
	/**
	 * Default implementation of IMediaFactory.
	 **/
	public class MediaFactory implements IMediaFactory
	{
		/**
		 * @inheritDoc
		 **/
		public function addMediaInfo(info:IMediaInfo):void
		{
			if (info == null || info.id == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			infos[info.id] = info;
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

			delete infos[info.id];
		}

		/**
		 * @inheritDoc
		 **/
		public function getMediaInfoById(id:String):IMediaInfo
		{
			return infos[id];
		}
		
		/**
		 * @inheritDoc
		 **/
		public function getMediaInfoByResource(resource:IMediaResource):IMediaInfo
		{
			var result:IMediaInfo;
			
			for each (var info:IMediaInfo in infos)
			{
				if (info.canHandleResource(resource) == true)
				{
					result = info;
					break;
				}
			}
			
			return result;
		}

		/**
		 * @inheritDoc
		 **/
		public function createMediaElement(resource:IMediaResource):MediaElement
		{
			var info:IMediaInfo = getMediaInfoByResource(resource);
			if (info != null)
			{
				return info.createMediaElement(resource);
			}
			
			return null;
		}
		
		// Internals
		//
		
		private var infos:Array = [];
	}
}