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
package org.openvideoplayer.content
{
	import org.openvideoplayer.events.MediaError;
	import org.openvideoplayer.events.MediaErrorCodes;
	import org.openvideoplayer.loaders.TestILoader;
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.TestConstants;
	import org.openvideoplayer.utils.URL;
	
	public class TestContentLoaderIntegration extends TestILoader
	{
		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get unhandledResource():IMediaResource
		{
			return new URLResource(new URL(TestConstants.REMOTE_STREAMING_VIDEO));
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorCode == MediaErrorCodes.CONTENT_IO_LOAD_ERROR ||
					   error.errorCode == MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR ||
					   error.errorCode == MediaErrorCodes.INVALID_SWF_AS_VERSION);
		}
	}
}