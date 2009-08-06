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
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.MediaFactory;
	import org.openvideoplayer.media.TestMediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class TestPluginElement extends TestMediaElement
	{
		public function TestPluginElement()
		{
		}

		public function testPluginElementConstruction():void
		{
			var pluginElement:MediaElement = new PluginElement(new StaticPluginLoader(new MediaFactory()), new PluginClassResource(null));
			assertTrue(pluginElement.resource != null);	
			assertTrue(pluginElement.resource is PluginClassResource);
			
		}

		

		override protected function createMediaElement():MediaElement
		{
			return new PluginElement(new StaticPluginLoader(new MediaFactory())); 
		}
		
		override protected function get loadable():Boolean
		{
			return true;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new PluginClassResource(SimpleVideoPluginInfo);
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.LOADABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [MediaTraitType.LOADABLE];
		}	



	}
}