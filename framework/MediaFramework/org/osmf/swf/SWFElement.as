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
package org.osmf.swf
{
	import flash.display.DisplayObject;
	
	import org.osmf.content.ContentElement;
	import org.osmf.media.IURLResource;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * SWFElement is a media element specifically created for
	 * presenting SWFs.
	 * <p>The SWFElement has the ILoadable, ISpatial and IViewable traits.
	 * It uses a SWFLoader class to load and unload its media.
	 * Developers requiring custom loading logic for SWFs
	 * can pass their own loaders to the SWFElement constructor. 
	 * These loaders should subclass SWFLoader.</p>
	 * <p>The basic steps for creating and using a SWFElement are:
	 * <ol>
	 * <li>Create a new IURLResource pointing to the URL of the SWF to be loaded.</li>
	 * <li>Create a new SWFLoader.</li>
	 * <li>Create the new SWFElement, passing the SWFLoader and IURLResource
	 * as parameters.</li>
	 * <li>Get the SWFElement's ILoadable trait using the 
	 * <code>MediaElement.getTrait(LOADABLE)</code> method.</li>
	 * <li>Load the SWF using the ILoadable's <code>load()</code> method.</li>
	 * <li>Get the SWFElement's IViewable trait using the 
	 * <code>MediaElement.getTrait(VIEWABLE)</code> method.</li>
	 * <li>Add the DisplayObject that represents the SWFElement's IViewable trait
	 * to the display list. This DisplayObject is in the <code>view</code>
	 * property of the IViewable.</li>
	 * <li>When done with the SWFElement, unload the SWF using the
	 *  ILoadable's <code>unload()</code> method.</li>
	 * </ol>
	 * </p>
	 * 
	 * @see SWFLoader
	 * @see org.osmf.media.IURLResource
	 * @see org.osmf.media.MediaElement
	 * @see org.osmf.traits
	 * @see flash.display.DisplayObjectContainer#addChild()
	 */
	public class SWFElement extends ContentElement
	{
		/**
		 * Constructor.
		 * 
		 * @param loader Loader used to load the SWF.
		 * @param resource Url that points to the SWF that the SWFElement will use.
		 * 
		 * @throws ArgumentError If loader is null.
		 */		
		public function SWFElement(loader:SWFLoader, resource:IURLResource = null)
		{
			super(loader, resource);		
		}
		
		/**
		 * @private 
		 */ 		
		override protected function processLoadedState():void
		{
			super.processLoadedState();
			
			var viewable:IViewable = getTrait(MediaTraitType.VIEWABLE) as IViewable;
			_swfRoot = viewable != null ? viewable.view : null;
		}
		
		/**
		 * @private 
		 */ 		
		override protected function processUnloadingState():void
		{
			super.processUnloadingState();
			
			_swfRoot = null;
		}

		/**
		 * The root DisplayObject of the loaded SWF.  Null until the SWF is in
		 * the loaded state, or after it enters the unloading state.
		 **/
		protected function get swfRoot():DisplayObject
		{
			return _swfRoot;
		}
		
		private var _swfRoot:DisplayObject;
	}
}