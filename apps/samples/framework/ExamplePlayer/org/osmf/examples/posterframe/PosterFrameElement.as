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
package org.osmf.examples.posterframe
{
	import org.osmf.image.ImageElement;
	import org.osmf.image.ImageLoader;
	import org.osmf.media.IURLResource;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * A PosterFrameElement is a playable Image Element.  Making it playable
	 * ensures it shows up as a poster frame.
	 **/
	public class PosterFrameElement extends ImageElement
	{
		public function PosterFrameElement(loader:ImageLoader, resource:IURLResource=null)
		{
			super(loader, resource);
		}
		
		/**
		 * @private
		 **/
		override protected function setupTraits():void
		{
			addTrait(MediaTraitType.PLAY, new PosterFramePlayTrait());
		}
	}
}