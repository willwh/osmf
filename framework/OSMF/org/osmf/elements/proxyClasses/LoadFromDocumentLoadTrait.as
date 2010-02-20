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
package org.osmf.elements.proxyClasses
{
	import flash.events.Event;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	[ExcludeClass]
	
	/**
	 * Dispatched load complete in order to notify the factory element that the 
	 * proxied item is ready.
	 */ 
	[Event('proxyReady')]
	
	/**
	 * @private
	 */ 
	public class LoadFromDocumentLoadTrait extends LoadTrait
	{
		public static const PROXY_READY:String = "proxyReady";
		
		/**
		 * Constructor.
		 */ 
		public function LoadFromDocumentLoadTrait(loader:LoaderBase, resource:MediaResourceBase)
		{
			super(loader, resource);
		}
		
		override protected function loadStateChangeEnd():void
		{
			if (loadState != LoadState.READY)
			{
				dispatchEvent(new LoadEvent(LoadEvent.LOAD_STATE_CHANGE, false, false, loadState));
			}
			else  // Notify the Factory we are done loading
			{
				dispatchEvent(new Event(PROXY_READY));
			}
		}
		
		/**
		 * @private
		 * The MediaElement created by the FactoryElement's loader.
		 */ 
		public var mediaElement:MediaElement;
	}
}