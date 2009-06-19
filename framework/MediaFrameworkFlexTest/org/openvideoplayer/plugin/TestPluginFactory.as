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
package org.openvideoplayer.plugin
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.media.URLResource;
	
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
			var urlResource:URLResource = new URLResource("http://www.adobe.com/foo.swf");
			var dynamicMediaInfo:IMediaInfo = pluginFactory.getMediaInfoByResource(urlResource);
			assertTrue(dynamicMediaInfo != null);

			// PluginClassResource containing a null ref should pass
			var classResource:PluginClassResource = new PluginClassResource(null);
			var staticMediaInfo:IMediaInfo = pluginFactory.getMediaInfoByResource(classResource);
			assertTrue(staticMediaInfo != null);

			// No result for an FTP URL, since it's not supported by the handler
			var urlResource2:URLResource = new URLResource("ftp://www.adobe.com/foo.swf");
			var dynamicMediaInfo2:IMediaInfo = pluginFactory.getMediaInfoByResource(urlResource2);
			assertTrue(dynamicMediaInfo2 == null);


			
		}

	}
}