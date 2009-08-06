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
package org.openvideoplayer.plugin
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.utils.URL;
	
	public class TestPluginFactory extends TestCase
	{
		public function TestPluginFactory()
		{
		}

		public function testPluginFactoryConstruction():void
		{
			var mediaFactory:MediaFactory = new MediaFactory();
			var pluginFactory:PluginFactory = new PluginFactory(mediaFactory);
			
			// positive result for an HTTP URL
			var urlResource:URLResource = new URLResource(new URL("http://www.adobe.com/foo.swf"));
			var dynamicMediaInfo:IMediaInfo = pluginFactory.getMediaInfoByResource(urlResource);
			assertTrue(dynamicMediaInfo != null);

			// PluginClassResource containing a null ref should pass
			var classResource:PluginClassResource = new PluginClassResource(null);
			var staticMediaInfo:IMediaInfo = pluginFactory.getMediaInfoByResource(classResource);
			assertTrue(staticMediaInfo != null);

			// No result for an FTP URL, since it's not supported by the handler
			var urlResource2:URLResource = new URLResource(new URL("ftp://www.adobe.com/foo.swf"));
			var dynamicMediaInfo2:IMediaInfo = pluginFactory.getMediaInfoByResource(urlResource2);
			assertTrue(dynamicMediaInfo2 == null);


			
		}

	}
}