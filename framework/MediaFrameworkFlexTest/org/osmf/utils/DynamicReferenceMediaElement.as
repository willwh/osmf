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
package org.osmf.utils
{
	import org.osmf.loaders.ILoader;
	import org.osmf.media.IMediaReferrer;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;

	public class DynamicReferenceMediaElement extends DynamicMediaElement implements IMediaReferrer
	{
		public function DynamicReferenceMediaElement(traitTypes:Array=null, loader:ILoader=null, resource:IMediaResource=null)
		{
			super(traitTypes, loader, resource);
			
			_references = new Array();
		}
		
		public function canReferenceMedia(target:MediaElement):Boolean
		{
			var referenceUrlToMatch:String = (args != null && args.length > 0) ? args[0] : null;
			
			// It can reference any DynamicMediaElement whose URL contains
			// a predefined string.
			return 		target is DynamicMediaElement
					&&	target.resource is URLResource
					&&  referenceUrlToMatch != null
					&&  URLResource(target.resource).url.rawUrl == referenceUrlToMatch;
		}

		public function addReference(target:MediaElement):void
		{
			_references.push(target);
		}
		
		public function get references():Array
		{
			return _references;
		}
		
		private var _references:Array;
	}
}