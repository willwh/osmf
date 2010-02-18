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
package org.osmf.elements
{
	import flash.events.Event;
	
	import org.osmf.elements.proxyClasses.FactoryLoadTrait;
	import org.osmf.elements.proxyClasses.MetadataProxy;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;

	/**
	 * The LoadableProxyElement will use a custom Loader to load and create a media element.
	 * The MediaElement will them be used as the proxies wrapped element.  The Loader needs
	 * to return a MediaElementContext.  This class is generally used to create on step loading and
	 * creation of compositions using playlists, such as SMIL.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class FactoryElement extends ProxyElement
	{
		/**
		 * Creates a new FactoryElement.  This is an abstract base class, and should be subclassed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function FactoryElement(resource:MediaResourceBase = null, loader:LoaderBase = null)
		{	
			super(null);		
			_metadata = new MetadataProxy();
			this.loader = loader;			
			this.resource = resource;
		}
	
		private function onLoaderStateChange(event:Event):void
		{			
			removeTrait(MediaTraitType.LOAD); // Remove the temporary LoadTrait.
			proxiedElement =  loadTrait.mediaElement;
			_metadata.metadata = proxiedElement.metadata;
		}
		
		// Overriding is neccessary because there is a null wrappedElement.
		/**
		 * @private
		 */ 
		override public function set resource(value:MediaResourceBase):void 
		{
			if (_resource != value && value != null)
			{
				_resource = value;
				loadTrait = new FactoryLoadTrait(loader, resource);
				loadTrait.addEventListener(FactoryLoadTrait.PROXY_READY, onLoaderStateChange);
				
				if (super.getTrait(MediaTraitType.LOAD) != null)
				{
					super.removeTrait(MediaTraitType.LOAD);
				}
				super.addTrait(MediaTraitType.LOAD, loadTrait);			
			}						
		}
			
		/**
		 * @private
		 */
		override public function get resource():MediaResourceBase
		{
			return _resource;
		}
		
		/**
		 * @private
		 * 
		 * Returns the MediaElement's metadata, if the media element hasn't been created yet this
		 * will return null.
		 */
		override public function get metadata():Metadata
		{			
			return _metadata;
		}

		private var _metadata:MetadataProxy;
		private var _resource:MediaResourceBase;
		private var loadTrait:FactoryLoadTrait;
		private var loader:LoaderBase;
	}
}