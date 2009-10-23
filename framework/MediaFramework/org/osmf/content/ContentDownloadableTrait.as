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
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.traits.DownloadableTrait;
	
	internal class ContentDownloadableTrait extends DownloadableTrait
	{
		public function ContentDownloadableTrait(contentLoader:ContentLoader)
		{
			this.contentLoader = contentLoader;
			
			contentLoader.addEventListener
				( BytesTotalChangeEvent.BYTES_TOTAL_CHANGE
				, onContentLoaderBytesTotalChange
				);
			
			super(contentLoader.bytesLoaded, contentLoader.bytesTotal);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */
		override public function get bytesDownloaded():Number
		{
			return contentLoader.bytesLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get bytesTotal():Number
		{
			return contentLoader.bytesTotal;
		}
		
		// Internals
		
		private function onContentLoaderBytesTotalChange(event:BytesTotalChangeEvent):void
		{
			dispatchEvent(event.clone());	
		}
		
		private var contentLoader:ContentLoader;
	}
}