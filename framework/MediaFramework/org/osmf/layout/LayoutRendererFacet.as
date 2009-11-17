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
package org.osmf.layout
{
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectFacet;

	/**
	 * The LayoutRendererFacet is a facet that holds a single value of type
	 * Class that implements ILayoutRenderer.
	 */	
	public class LayoutRendererFacet extends ObjectFacet
	{
		/**
		 * Constructor
		 *  
		 * @param renderer The renderer type that this facet holds.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function LayoutRendererFacet(rendererType:Class)
		{
			super(MetadataNamespaces.LAYOUT_RENDERER, rendererType);
		}
		
		// Public API
		//
		
		public function get rendererType():Class
		{
			return _object as Class;
		}
	}
}