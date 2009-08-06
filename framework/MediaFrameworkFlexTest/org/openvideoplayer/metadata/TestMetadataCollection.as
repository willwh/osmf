package org.openvideoplayer.metadata
{
	import __AS3__.vec.Vector;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.utils.URL;

	public class TestMetadataCollection extends TestCase
	{
		
		override public function setUp():void
		{
			super.setUp();			
			collection = new Metadata();				
		}
		
		public function testAddMetadata():void
		{			
			var value:KeyValueFacet = new KeyValueFacet();
			collection.addFacet(value);
						
			var facet:IFacet = 	collection.getFacet(value.nameSpace, FacetType.KEY_VALUE_FACET);
			
			var sd:String = "sfsdf";
			sd += "3sdfdf";
			
			assertEquals(value, facet );			
		}
			
		public function testgetFacet():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:KeyValueFacet = new KeyValueFacet(new URL(adobe));
			var value2:KeyValueFacet = new KeyValueFacet(new URL(example));
			
			collection.addFacet(value);
			collection.addFacet(value2);
			
			var facetTypes:Vector.<FacetType> = collection.getFacetTypes(new URL(example));
						
			assertEquals(1, facetTypes.length);
			assertEquals(FacetType.KEY_VALUE_FACET, facetTypes[0]);
			
			var facet:IFacet = collection.getFacet(new URL(adobe), FacetType.KEY_VALUE_FACET);
			assertEquals(value, facet);
						
			facet = collection.getFacet(new URL("testNamespace"), FacetType.KEY_VALUE_FACET);
			assertNull(facet);			
		}
		
		public function testgetFacetTypes():void
		{
			var adobe:String =  "http://www.adobe.com/";
			var example:String = "http://www.example.com/";
			var value:KeyValueFacet = new KeyValueFacet(new URL(adobe));
			var value2:KeyValueFacet = new KeyValueFacet(new URL(example));
			var value3:CustomFacet = new CustomFacet(new URL(example));
			
			assertEquals(example, value3.nameSpace.rawUrl)
						
			collection.addFacet(value);
			collection.addFacet(value2);
			collection.addFacet(value3);
			
			var facetTypes:Vector.<FacetType> = collection.getFacetTypes(new URL(example));
			var facetTypes2:Vector.<FacetType> = collection.getFacetTypes(new URL("http://www.adobe.com/"));		
			
			assertEquals(2, facetTypes.length); 
			//Can't predict the order of the facet types, so we need to check for both.
			assertTrue(value2.facetType == facetTypes[0] || value3.facetType == facetTypes[0]);
			assertTrue(value2.facetType == facetTypes[1] || value3.facetType == facetTypes[1]);
			assertTrue(facetTypes[1] != facetTypes[0]);
			assertEquals(1, facetTypes2.length);
			assertEquals(FacetType.KEY_VALUE_FACET, facetTypes2[0]);
			
			var facet:IFacet = collection.getFacet(new URL(adobe), FacetType.KEY_VALUE_FACET);
			assertEquals(value, facet);
						
			facetTypes = collection.getFacetTypes(new URL("testNamespace"));
			assertEquals(0, facetTypes.length);
			
			collection.removeFacet(value2);
			assertNull(collection.getFacet(value2.nameSpace, value2.facetType));
		}
		
			
		// Utils
		//
		
		protected var collection:IMetadata;
				
	}
}


import org.openvideoplayer.metadata.IFacet;
import org.openvideoplayer.metadata.IMetadata;
import org.openvideoplayer.utils.URL;
import org.openvideoplayer.metadata.FacetType;
	

internal class CustomFacet implements IFacet
{
	public static const CUSTOM_FACET:FacetType = new FacetType('CustomFacet');
	
	public function CustomFacet(ns:URL)
	{
		_ns = ns;
	}
	
	public function get facetType():FacetType
	{
		return CUSTOM_FACET;
	}
	
	public function get nameSpace():URL
	{
		return _ns;
	}
	
	private var _ns:URL;
}