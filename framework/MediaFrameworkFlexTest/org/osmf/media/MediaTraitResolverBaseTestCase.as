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
package org.osmf.media
{
	import flexunit.framework.TestCase;
	
	import org.osmf.traits.BufferTrait;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.osmf.traits.ViewTrait;

	public class MediaTraitResolverBaseTestCase extends TestCase
	{
		public function constructResolver(type:String, traitOfType:MediaTraitBase):MediaTraitResolver
		{
			return null;	
		}
		
		public function testConstructor():void
		{
			var resolver:MediaTraitResolver;
			
			try
			{
				resolver = constructResolver(null, null);
				fail();
			}
			catch(_:*)
			{	
			}
			
			assertNull(resolver);
		}
		
		public function testType():void
		{
			var resolver:MediaTraitResolver;
			resolver = constructResolver(MediaTraitType.BUFFER, new BufferTrait());
			assertNotNull(resolver);
			assertEquals(MediaTraitType.BUFFER, resolver.type);
		}
		
		public function testAddTrait():void
		{
			var type:String = MediaTraitType.TIME;
			var resolver:MediaTraitResolver = constructResolver(type, new TimeTrait());
			
			try
			{
				resolver.addTrait(null);
				fail();
			}
			catch(_:*)
			{	
			}
			
			try
			{
				resolver.addTrait(new ViewTrait(null));
				fail();
			}
			catch(_:*)
			{	
			}
		}
		
		public function testRemoveTrait():void
		{
			var type:String = MediaTraitType.TIME;
			var resolver:MediaTraitResolver = constructResolver(type, new TimeTrait());
			
			try
			{
				resolver.removeTrait(null);
				fail();
			}
			catch(_:*)
			{	
			}
			
			try
			{
				resolver.removeTrait(new ViewTrait(null));
				fail();
			}
			catch(_:*)
			{	
			}
		}
		
		public function testMediaTraitResolverBase():void
		{
			var resolver:MediaTraitResolver;
			 	
		}
	}
}