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
package org.osmf.proxies
{
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;

	/**
	 * The LoadableProxyElement will use a custom Loader to load and create a media element.
	 * The MediaElement will them be used as the proxies wrapped element.  The Loader needs
	 * to return a MediaElementContext.  This class is generally used to create on step loading and
	 * creation of compositions using playlists, such as SMIL.
	 */ 
	public class LoadableProxyElement extends ProxyElement
	{
		/**
		 * Creates a new LoadableProxyElement.  The Loader needs to return a MediaElementLoadedContext.
		 */ 
		public function LoadableProxyElement(loader:MediaElementLoader)
		{	
			super(null);		
			_metadata = new MetadataProxy();
			this.loader = loader;			
		}
	
		private function onLoaderStateChange(event:LoadEvent):void
		{
			if (event.loadState == LoadState.READY)
			{
				removeTrait(MediaTraitType.LOAD); // Remove the temporary LoadTrait.
				var context:MediaElementLoadedContext = loadTrait.loadedContext as MediaElementLoadedContext;
				wrappedElement =  context.element;
				_metadata.metadata = wrappedElement.metadata;
			}
		}
		
		// Overriding is neccessary because there is a null wrappedElement.
		/**
		 * @private
		 */ 
		override public function set resource(value:IMediaResource):void 
		{
			if (_resource != value && value != null)
			{
				_resource = value;
				loadTrait = new LoadTrait(loader, resource);
				loadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoaderStateChange);
				super.addTrait(MediaTraitType.LOAD, loadTrait);			
			}						
		}
		
		/**
		 * @private
		 **/
		override public function get resource():IMediaResource
		{
			return _resource;
		}
		
		/**
		 * Returns the MediaElement's metadata, if the media element hasn't been created yet this
		 * will return null.
		 **/
		override public function get metadata():Metadata
		{			
			return _metadata;
		}

		private var _metadata:MetadataProxy;
		private var _resource:IMediaResource;
		private var loadTrait:LoadTrait;
		private var loader:ILoader;
	}
}