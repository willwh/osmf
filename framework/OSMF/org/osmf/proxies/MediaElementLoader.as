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
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.LoaderBase;

	/**
	 * The Base class for Chained loaders that are used by the 
	 * LoadableProxyElement.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class MediaElementLoader extends LoaderBase
	{
		/**
		 * Creates a new MediaElementLoader
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function MediaElementLoader()
		{
			super();
		}
		
		/**
		 * @private
		 * 
		 * @throws Error if the LoadedContext is not a MediaElementLoadedContext
		 */ 
		override protected function updateLoadTrait(loadTrait:LoadTrait, newState:String, loadedContext:ILoadedContext=null):void
		{
			if (loadedContext != null && !(loadedContext is MediaElementLoadedContext))
			{
				throw new Error("Invalid LoadedContext for MediaElementLoadedContext");
			}	
			super.updateLoadTrait(loadTrait, newState, loadedContext);
		}  
		
	}
}