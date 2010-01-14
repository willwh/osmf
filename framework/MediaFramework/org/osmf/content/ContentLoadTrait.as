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
	import flash.events.ProgressEvent;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	
	internal class ContentLoadTrait extends LoadTrait
	{
		public function ContentLoadTrait(loader:ILoader, resource:MediaResourceBase)
		{
			super(loader, resource);
		}
		
		override protected function loadStateChangeStart(newState:String, newContext:ILoadedContext):void
		{
			if (newState == LoadState.READY)
			{
				var context:ContentLoadedContext = newContext as ContentLoadedContext;

				// Update to current values.
				setBytesTotal(context.loader.contentLoaderInfo.bytesTotal);
				setBytesLoaded(context.loader.contentLoaderInfo.bytesLoaded);
				
				// But listen for any changes.
				context
					.loader
					.contentLoaderInfo
					.addEventListener(ProgressEvent.PROGRESS, onContextLoadProgress, false, 0, true);
			}
			else if (newState == LoadState.UNINITIALIZED)
			{
				setBytesLoaded(0);
			}
		}
		
		// Internals
		//
		
		private function onContextLoadProgress(event:ProgressEvent):void
		{
			setBytesTotal(event.bytesTotal);
			setBytesLoaded(event.bytesLoaded);
		}
	}
}