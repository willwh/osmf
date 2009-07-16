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
package org.openvideoplayer.media
{
	import org.openvideoplayer.utils.InterfaceTestCase;
	import org.openvideoplayer.utils.FMSURL;
	
	public class TestIURLResource extends InterfaceTestCase
	{
		public function testGetURL():void
		{
			// Simple URL
			var resource:IURLResource = createIURLResource("http://www.example.com");
			assertTrue(resource != null);
			assertTrue(resource.url.rawUrl == "http://www.example.com");
			assertTrue(resource.url.protocol == "http");
			assertTrue(resource.url.host == "www.example.com");
			
			// Empty URL
			resource = createIURLResource("");
			assertTrue(resource != null);
			assertTrue(resource.url.rawUrl == "");

			// null URL
			resource = createIURLResource(null);
			assertTrue(resource != null);
			assertTrue(resource.url.rawUrl == null);
			
			// URL with query string params
			resource = createIURLResource("rtmp://myhostname/myappname/foo/mystream.flv?param1=one&param2=two");
			assertTrue(resource != null);
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "myhostname");
			assertTrue(resource.url.path == "myappname/foo/mystream.flv");
			assertTrue(resource.url.getParamValue("param2") == "two");
			assertTrue(resource.url.getParamValue("param1") == "one");
			
			// Test the above URL as an FMS URL expecting no FMS instance name
			var fmsUrl:FMSURL = new FMSURL(resource.url);
			assertTrue(fmsUrl != null);
			assertTrue(fmsUrl.appName == "myappname");
			assertTrue(fmsUrl.instanceName == "");
			assertTrue(fmsUrl.streamName == "foo/mystream.flv");
			
			// Test it again but this time expecting an FMS instance name
			fmsUrl = new FMSURL(resource.url, true);
			assertTrue(fmsUrl != null);
			assertTrue(fmsUrl.appName == "myappname");
			assertTrue(fmsUrl.instanceName == "foo");
			assertTrue(fmsUrl.streamName == "mystream.flv");
			
			// A URL with username:password, a port number, a query string, and a fragment
			resource = createIURLResource("http://fred:wilma@hostexample.com:80/foo/bar.php?var1=foo&var2=bar#yyz");
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == "http://fred:wilma@hostexample.com:80/foo/bar.php?var1=foo&var2=bar#yyz");
			assertTrue(resource.url.protocol == "http");
			assertTrue(resource.url.userInfo == "fred:wilma");
			assertTrue(resource.url.host == "hostexample.com");
			assertTrue(resource.url.port == "80");
			assertTrue(resource.url.path == "foo/bar.php");
			assertTrue(resource.url.getParamValue("var1") == "foo");
			assertTrue(resource.url.getParamValue("var2") == "bar");
			assertTrue(resource.url.fragment == "yyz");
			
			// A URL for the purpose of connecting to a local dev install of FMS
			resource = createIURLResource("rtmp:/sudoku/room1");
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == "rtmp:/sudoku/room1");
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "sudoku");
			assertTrue(resource.url.path == "room1");
			
			// A URL with an empty port
			resource = createIURLResource("rtmp://mtserver.com:/myapp");
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == "rtmp://mtserver.com:/myapp");
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "mtserver.com");
			assertTrue(resource.url.port == "");
			assertTrue(resource.url.path == "myapp");
			
			// Test above with FMS URL to get the FMS app name
			fmsUrl = new FMSURL(resource.url);
			assertTrue(fmsUrl != null);
			assertTrue(fmsUrl.appName == "myapp");
			
			// A URL with an IP address
			resource = createIURLResource("telnet://192.0.2.16:80/");
			assertTrue(resource != null);
			assertTrue(resource.url.toString() == "telnet://192.0.2.16:80/");
			assertTrue(resource.url.protocol == "telnet");
			assertTrue(resource.url.host == "192.0.2.16");
			assertTrue(resource.url.port == "80");
			assertTrue(resource.url.path == "");
			
			// A URL with a prefix but no extension
			resource = createIURLResource("rtmp://localhost/vod/mp3:Legend");
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "localhost");
			fmsUrl = new FMSURL(resource.url);
			assertTrue(fmsUrl.appName == "vod");
			assertTrue(fmsUrl.streamName == "mp3:Legend");
			
			// A URL with a prefix and an extension
			resource = createIURLResource("rtmp://localhost/vod/mp4:Legend.mp4");
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "localhost");
			fmsUrl = new FMSURL(resource.url);
			assertTrue(fmsUrl.appName == "vod");
			assertTrue(fmsUrl.streamName == "mp4:Legend.mp4");
			
			// FMS URL with explicit _definst_
			resource = createIURLResource("rtmp://myhost/foo/_definst_/bar/mystream.flv");
			fmsUrl = new FMSURL(resource.url);
			assertTrue(fmsUrl.appName == "foo");
			assertTrue(fmsUrl.instanceName == "_definst_");
			assertTrue(fmsUrl.streamName == "bar/mystream.flv");
			
			// FMS URL with explicit _definst_
			resource = createIURLResource("rtmp://myhost/foo/_definst_/bar/mystream.flv");
			fmsUrl = new FMSURL(resource.url, true);
			assertTrue(fmsUrl.appName == "foo");
			assertTrue(fmsUrl.instanceName == "_definst_");
			assertTrue(fmsUrl.streamName == "bar/mystream.flv");
			
			// null URL then set it via a property
			resource = createIURLResource(null);
			assertTrue(resource != null);
			assertTrue(resource.url.rawUrl == null);
			resource.url.rawUrl = "rtmp://myhostname/myappname/foo/mystream.flv?param1=one&param2=two";
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "myhostname");
			assertTrue(resource.url.path == "myappname/foo/mystream.flv");
			assertTrue(resource.url.getParamValue("param2") == "two");
			assertTrue(resource.url.getParamValue("param1") == "one");
			
			// A URL with nested query string parameters.  This is odd, and a rare case, but FMS supports 
			// the concept of edge/origin servers.  The FMSURL class does not (yet) support this. But the URL
			// class should return the query string correctly, meaning everything after the first "?" up to the 
			// fragment if there is one.
			resource = createIURLResource("rtmp://myedge:443/?rtmp://myedge2/?rtmp://myorigin:1935/myapp3/streamname.flv?streamName=qsstreamname&mode=live&streamType=MP4");
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "myedge");
			assertTrue(resource.url.query == "rtmp://myedge2/?rtmp://myorigin:1935/myapp3/streamname.flv?streamName=qsstreamname&mode=live&streamType=MP4");

			// Same thing as last test but with a fragment on the end
			resource = createIURLResource("rtmp://myedge:443/?rtmp://myedge2/?rtmp://myorigin:1935/myapp3/streamname.flv?streamName=qsstreamname&mode=live&streamType=MP4#yyz");
			assertTrue(resource.url.protocol == "rtmp");
			assertTrue(resource.url.host == "myedge");
			assertTrue(resource.url.query == "rtmp://myedge2/?rtmp://myorigin:1935/myapp3/streamname.flv?streamName=qsstreamname&mode=live&streamType=MP4");
			assertTrue(resource.url.fragment == "yyz");
			
			// A local file location
			resource = createIURLResource("/Users/mynamehere/Documents/media/myfile.flv");
			assertTrue(resource.url.protocol == "");
			assertTrue(resource.url.userInfo == "");
			assertTrue(resource.url.host == "");
			assertTrue(resource.url.port == "");
			assertTrue(resource.url.path == "Users/mynamehere/Documents/media/myfile.flv");

		}
		
		protected function createIURLResource(url:String):IURLResource
		{
			return createInterfaceObject(url) as IURLResource; 
		}
	}
}