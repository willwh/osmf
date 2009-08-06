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
package org.openvideoplayer.image
{
	import flash.display.Loader;
	
	import org.openvideoplayer.traits.ILoadedContext;
	
	/**
	 * The ImageLoadedContext contains information about the output of the ImageLoader's 
	 * load operation.
	 *   
	 */
	internal class ImageLoadedContext implements ILoadedContext
	{
		/**
		 *  Constructor.
		 * 	@param imageLoader A new Loader object that has been
		 * 	successfully loaded.
		 */ 
		public function ImageLoadedContext(imageLoader:Loader)
		{
			_loader = imageLoader;
		}
		
		/**
		 * The object that contains the loaded image to be used by an ImageElement.
		 * The <code>content</code> property of the Loader class contains the image file that 
		 * was loaded.
		 * @see flash.display.Loader#content
		 */
		public function get loader():Loader
		{
			return _loader;
		}
		
		private var _loader:Loader;
	}
}