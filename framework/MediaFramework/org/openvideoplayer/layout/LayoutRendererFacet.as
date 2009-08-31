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
package org.openvideoplayer.layout
{
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.IIdentifier;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.utils.URL;

	/**
	 * The LayoutRendererFacet is a facet that holds a single value of type
	 * Class that implements ILayoutRenderer.
	 */	
	public class LayoutRendererFacet extends EventDispatcher implements IFacet
	{
		/**
		 * Constructor
		 *  
		 * @param renderer The renderer type that this facet holds.
		 * 
		 */		
		public function LayoutRendererFacet(renderer:Class)
		{
			_renderer = renderer;
		}
		
		// IFacet
		//
		
		/**
		 * @inheritDoc
		 */		
		public function get namespaceURL():URL
		{
			return MetadataNamespaces.LAYOUT_RENDERER;
		}
		
		/**
		 * Always returns the renderer type that this facet holds.
		 * 
		 * @inheritDoc 
		 */		
		public function getValue(identifier:IIdentifier):*
		{
			return _renderer;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		// Public API
		//
		
		public function get renderer():Class
		{
			return _renderer;
		}
		
		// Internals
		//
		
		private var _renderer:Class;
	}
}