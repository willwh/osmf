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
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.traits.DownloadableTrait;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.MediaTraitType;
	
	internal class ContentDownloadableTrait extends DownloadableTrait
	{
		public function ContentDownloadableTrait(context:ContentLoadedContext)
		{
			context
				.loader
				.contentLoaderInfo
				.addEventListener(ProgressEvent.PROGRESS, onContextLoadableProgress);
			
			super();
		}
		
		// Internals
		//
		
		private function onContextLoadableProgress(event:ProgressEvent):void
		{
			bytesTotal = event.bytesTotal;
			bytesDownloaded = event.bytesLoaded;
		}
		
	}
}