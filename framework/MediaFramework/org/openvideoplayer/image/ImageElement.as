/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.image
{
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.LoadableMediaElement;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	import org.openvideoplayer.traits.ViewableTrait;
	
	/**
	 * ImageElement is a media element specifically created for
	 * presenting still images.
	 * It can load and present any PNG, GIF, or JPG image.
	 * <p>The ImageElement has the ILoadable, ISpatial and IViewable traits.
	 * It uses an ImageLoader class to load and unload its media.
	 * Developers requiring custom loading logic for images
	 * can pass their own loaders to the ImageElement constructor. 
	 * These loaders should subclass ImageLoader.</p>
	 * <p>The basic steps for creating and using an ImageElement are:
	 * <ol>
	 * <li>Create a new IURLResource pointing to the URL of image to be loaded.</li>
	 * <li>Create a new ImageLoader.</li>
	 * <li>Create the new ImageElement, passing the ImageLoader and IURLResource
	 * as parameters.</li>
	 * <li>Get the ImageElement's ILoadable trait using the 
	 * <code>MediaElement.getTrait(LOADABLE)</code> method.</li>
	 * <li>Load the image using the ILoadable's <code>load()</code> method.</li>
	 * <li>Get the ImageElement's IViewable trait using the 
	 * <code>MediaElement.getTrait(VIEWABLE)</code> method.</li>
	 * <li>Add the DisplayObject that represents the ImageElement's IViewable trait
	 * to the display list. This DisplayObjects is in the <code>view</code>
	 * property of the IViewable.</li>
	 * <li>When done with the ImageElement, unload the image using the
	 *  ILoadable's <code>load()</code> method.</li>
	 * </ol>
	 * </p>
	 * 
	 * @see ImageLoader
	 * @see org.openvideoplayer.media.IURLResource
	 * @see org.openvideoplayer.media.MediaElement
	 * @see org.openvideoplayer.traits
	 * @see flash.display.DisplayObjectContainer#addChild()
	 */
	public class ImageElement extends LoadableMediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param loader Loader used to load the image.
		 * @param resource Url that points to the image that the ImageElement will use.
		 */		
		public function ImageElement(loader:ImageLoader = null, resource:IURLResource = null)
		{
			super(loader, resource);		
		}
			
		/**
		 *  @private 
		 */ 		
		override protected function processLoadedState():void
		{
			var context:ImageLoadedContext = (getTrait(MediaTraitType.LOADABLE) as ILoadable).loadedContext as ImageLoadedContext;
			viewable	= new ViewableTrait();			
			spatial 	= new SpatialTrait();
			
			viewable.view = context.loader.content;
			spatial.setDimensions(context.loader.contentLoaderInfo.width, context.loader.contentLoaderInfo.height);
			
			addTrait(MediaTraitType.VIEWABLE, viewable);
			addTrait(MediaTraitType.SPATIAL, spatial);
		}
		
		/**
		 *  @private 
		 */ 
		override protected function processUnloadingState():void
		{
			removeTrait(MediaTraitType.SPATIAL);
			removeTrait(MediaTraitType.VIEWABLE);	
			spatial = null;
			viewable = null;		
		}		
		
		private var viewable:ViewableTrait;
		private var spatial:SpatialTrait;	
	}
}