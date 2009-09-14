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
package org.openvideoplayer.composition
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.layout.*;
	import org.openvideoplayer.media.MediaElement;

	public class TestCompositeViewableTrait extends TestCase
	{
		public function testCompositeViewableTrait():void
		{
			var aggregator:TraitAggregator = new TraitAggregator();
			
			var owner:MediaElement = new SerialElement;
			
			var trait:CompositeViewableTrait
				= new CompositeViewableTrait(aggregator, owner); 
			
			// No layout renderer class being assigned, the default
			// should have been used:
			assertTrue(trait.layoutRenderer is DefaultLayoutRenderer);
			
			var layoutRendererFacet:LayoutRendererFacet
				= new LayoutRendererFacet(MyLayoutRenderer);
			owner.metadata.addFacet(layoutRendererFacet);
			
			// Layout should now have changed to be of type
			// MyLayoutRenderer:
			assertTrue(trait.layoutRenderer is MyLayoutRenderer);
			
			owner.metadata.removeFacet(layoutRendererFacet);
			
			// Should be 'default' once more: 
			assertTrue(trait.layoutRenderer is DefaultLayoutRenderer);
			
			// Assigning class that is not ILayoutRenderer implementing:
			layoutRendererFacet = new LayoutRendererFacet(Array);
			owner.metadata.addFacet(layoutRendererFacet);
			
			// Should be 'default' once more: 
			assertTrue(trait.layoutRenderer is DefaultLayoutRenderer);
		}
	}
	
}

import org.openvideoplayer.layout.*;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

internal class MyLayoutRenderer extends EventDispatcher implements ILayoutRenderer
{
	public function get parent():ILayoutRenderer
	{
		return _parent;
	}
	
	public function set parent(value:ILayoutRenderer):void
	{
		_parent = value;
	}
	
	public function set context(value:ILayoutContext):void
	{
		
	}
	
	public function addTarget(target:ILayoutTarget):ILayoutTarget
	{
		return null;
	}
	
	public function removeTarget(target:ILayoutTarget):ILayoutTarget
	{
		return null;
	}
	
	public function targets(target:ILayoutTarget):Boolean
	{
		return false;
	}
	
	public function invalidate():void
	{
		
	}
	
	public function validateNow():void
	{
	
	}
	
	public function updateCalculatedBounds():Rectangle
	{
		return null;
	}
	
	public function updateLayout():void
	{
	}
	
	private var _parent:ILayoutRenderer;
}