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
package org.osmf.plugins.smoothing
{
	import org.osmf.media.IMediaReferrer;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.elements.VideoElement;

	/**
	 * The actual media element that does the referrencing and smoothing of
	 * video elements.
	 */ 
	public class Smoother extends MediaElement implements IMediaReferrer
	{
		public function Smoother()
		{
			super();
		}
		
		public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			return false;
		}
		
		public function addReference(element:MediaElement):void
		{
			if (element is VideoElement)
			{
				VideoElement(element).smoothing = true;
			}
		}
		
		public function canReferenceMedia(element:MediaElement):Boolean
		{
			return element is VideoElement;			
		}
		
		
		
	}
}