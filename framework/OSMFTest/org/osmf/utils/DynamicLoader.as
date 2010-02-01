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
package org.osmf.utils
{
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	
	public class DynamicLoader extends LoaderBase
	{
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var simpleResource:SimpleResource = resource as SimpleResource;
			return simpleResource != null &&
				   simpleResource.type != SimpleResource.UNHANDLED;
		}
		
		override public function load(loadTrait:LoadTrait):void
		{
			super.load(loadTrait);
			
			doUpdateLoadTrait(loadTrait, LoadState.LOADING);
			
			if (SimpleResource(loadTrait.resource).type == SimpleResource.SUCCESSFUL)
			{
				doUpdateLoadTrait(loadTrait, LoadState.READY, new SimpleLoadedContext());
			}
			else
			{
				doUpdateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
				loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR));
			}
		}

		override public function unload(loadTrait:LoadTrait):void
		{
			super.unload(loadTrait);
			
			doUpdateLoadTrait(loadTrait, LoadState.UNLOADING, new SimpleLoadedContext());
			doUpdateLoadTrait(loadTrait, LoadState.UNINITIALIZED);
		}

		public function doUpdateLoadTrait(loadTrait:LoadTrait, newState:String, loadedContext:ILoadedContext=null):void
		{
			super.updateLoadTrait(loadTrait, newState, loadedContext);
		}
	}
}