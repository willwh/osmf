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
package org.osmf.plugin
{
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadableTrait;
	import org.osmf.traits.TestILoader;
	import org.osmf.utils.IntegrationTestUtils;
	import org.osmf.utils.URL;
	
	public class TestDynamicPluginLoaderIntegration extends TestILoader
	{
		override public function setUp():void
		{
			mediaFactory  = new MediaFactory();

			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			mediaFactory = null;
		}
		
		override protected function createInterfaceObject(... args):Object
		{
			return new DynamicPluginLoader(mediaFactory);
		}
		
		override protected function createILoadable(resource:IMediaResource=null):ILoadable
		{
			return new LoadableTrait(loader, resource);
		}
		
		override protected function get successfulResource():IMediaResource
		{
			return new URLResource(new URL(IntegrationTestUtils.REMOTE_VALID_PLUGIN_SWF_URL));
		}

		override protected function get failedResource():IMediaResource
		{
			return new URLResource(new URL(IntegrationTestUtils.REMOTE_INVALID_PLUGIN_SWF_URL));
		}

		override protected function get unhandledResource():IMediaResource
		{
			return new URLResource(new URL(IntegrationTestUtils.REMOTE_UNHANDLED_PLUGIN_RESOURCE_URL));
		}
		
		public function testLoadOfPlugin():void
		{
			// TODO: Verify that class types are merged.
		}

		private var mediaFactory:MediaFactory;
	}
}