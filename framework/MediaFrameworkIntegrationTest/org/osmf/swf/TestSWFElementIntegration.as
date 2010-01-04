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
	import org.osmf.content.TestContentElementIntegration;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.utils.IntegrationTestUtils;
	import org.osmf.utils.URL;

	public class TestSWFElementIntegration extends TestContentElementIntegration
	{
		override protected function createMediaElement():MediaElement
		{
			return new SWFElement(new SWFLoader()); 
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(new URL(IntegrationTestUtils.REMOTE_VALID_SWF_URL));
		}
		
		override protected function get expectedBytesTotal():Number
		{
			// Size of resourceForMediaElement.
			return 2125;
		}
	}
}