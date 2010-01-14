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
package org.osmf.content
{
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.TestILoader;
	import org.osmf.utils.TestConstants;
	import org.osmf.utils.URL;
	
	public class TestContentLoaderIntegration extends TestILoader
	{
		override protected function createLoadTrait(loader:ILoader, resource:MediaResourceBase):LoadTrait
		{
			return new LoadTrait(loader, resource);
		}
		
		override protected function get unhandledResource():MediaResourceBase
		{
			return new URLResource(new URL(TestConstants.REMOTE_STREAMING_VIDEO));
		}
		
		override protected function verifyMediaErrorOnLoadFailure(error:MediaError):void
		{
			assertTrue(error.errorID == MediaErrorCodes.CONTENT_IO_LOAD_ERROR ||
					   error.errorID == MediaErrorCodes.CONTENT_SECURITY_LOAD_ERROR ||
					   error.errorID == MediaErrorCodes.INVALID_SWF_AS_VERSION);
		}
	}
}