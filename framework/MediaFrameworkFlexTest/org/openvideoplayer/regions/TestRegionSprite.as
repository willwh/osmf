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
package org.openvideoplayer.regions
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.utils.DynamicMediaElement;

	public class TestRegionSprite extends TestCase
	{
		public function testRegionElements():void
		{
			var parent:RegionSprite = new RegionSprite();
			var element1:DynamicMediaElement = new DynamicMediaElement();
			var element2:DynamicMediaElement = new DynamicMediaElement();
			
			assertNotNull(parent);
			assertFalse(parent.containsElement(element1));
			assertFalse(parent.containsElement(element2));
			
			parent.addChildElement(element1);
			assertTrue(parent.containsElement(element1));
			
			parent.addChildElement(element2);
			assertTrue(parent.containsElement(element2));
			
			assertTrue(element1 == parent.removeChildElement(element1));
			assertFalse(parent.containsElement(element1));
			
			var error:Error;
			try
			{
				parent.removeChildElement(element1);
			}
			catch(e:Error)
			{
				error = e;
			}
			
			assertNotNull(error);
			assertTrue(error is IllegalOperationError);
		}
		
		public function testRegionSubRegions():void
		{
			var parent:RegionSprite = new RegionSprite();
			var sub1:RegionSprite = new RegionSprite();
			var sub2:RegionSprite = new RegionSprite();
			
			assertNotNull(parent);
			assertFalse(parent.containsRegion(sub1));
			assertFalse(parent.containsRegion(sub2));
			
			parent.addChildRegion(sub1);
			assertTrue(parent.containsRegion(sub1));
			
			parent.addChildRegion(sub2);
			assertTrue(parent.containsRegion(sub2));
			
			parent.removeChildRegion(sub1);
			assertFalse(parent.containsRegion(sub1));
			
			var error:Error;
			try
			{
				parent.removeChildRegion(sub1);
			}
			catch(e:Error)
			{
				error = e;
			}
			
			assertNotNull(error);
			assertTrue(error is IllegalOperationError);
		}
	}
}