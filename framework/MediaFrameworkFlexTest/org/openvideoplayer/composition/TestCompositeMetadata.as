package org.openvideoplayer.composition
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.events.MetadataEvent;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.Metadata;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	public class TestCompositeMetadata extends TestCase
	{
		
		public function testAddMetadata():void
		{
			var childMetadata:Metadata = new Metadata();
			var childMetadata2:Metadata = new Metadata();
			var onAddCalled:Boolean = false;
			var childFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DEFAULT_METADATA);
			childFacet.addValue( new ObjectIdentifier("childFacetKey"),"childFacet");
			var childFacet2:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DEFAULT_METADATA);
			childFacet2.addValue( new ObjectIdentifier("childFacet2Key"), "childFacet2");
			var ownFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DEFAULT_METADATA);
			ownFacet.addValue(new ObjectIdentifier("ownFacetKey"),"ownFacet");
			
			childMetadata.addFacet(childFacet);
			childMetadata2.addFacet(childFacet2);
			
			var metadata:CompositeMetadata = new CompositeMetadata();
			metadata.addEventListener(MetadataEvent.FACET_ADD, onFacetAdd);
			
			metadata.addChildMetadata(childMetadata);
			
			assertTrue(onAddCalled);
			onAddCalled = false;
			assertNotNull(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA));
			assertEquals(childFacet, metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA));
			
			metadata.addChildMetadata(childMetadata2);
			assertEquals("childFacet", KeyValueFacet(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA)).getValue(new ObjectIdentifier("childFacetKey")));
			assertEquals("childFacet2", KeyValueFacet(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA)).getValue(new ObjectIdentifier("childFacet2Key")));
						
			assertTrue(onAddCalled);
			onAddCalled = false;
			
			metadata.addFacet(ownFacet);
			assertTrue(onAddCalled);
						
			assertEquals("ownFacet", KeyValueFacet(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA)).getValue(new ObjectIdentifier("ownFacetKey")));
			
			//Test the Catching of Errors
			var nullThrown:Boolean = false;
			var nsThrown:Boolean = false;
			try
			{
				metadata.addFacet(null);
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, MediaFrameworkStrings.NULL_PARAM);
				nullThrown = true;
			}
			
			try
			{				
				metadata.addFacet(new CustomFacet(null));
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
				nsThrown = true;
			}			
			assertTrue(nullThrown);
			assertTrue(nsThrown);
			
			
												
			function onFacetAdd(event:MetadataEvent):void
			{							
				onAddCalled = true;
			}			
		}
		
		public function testRemoveMetadata():void
		{
			var childMetadata:Metadata = new Metadata();
			var childMetadata2:Metadata = new Metadata();
			var onRemoveCalled:Boolean = false;
			var childFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DEFAULT_METADATA);
			childFacet.addValue( new ObjectIdentifier("childFacetKey"),"childFacet");
			var childFacet2:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DEFAULT_METADATA);
			childFacet2.addValue( new ObjectIdentifier("childFacet2Key"), "childFacet2");
			var ownFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.DEFAULT_METADATA);
			ownFacet.addValue(new ObjectIdentifier("ownFacetKey"),"ownFacet");
			
			childMetadata.addFacet(childFacet);
			childMetadata2.addFacet(childFacet2);
			
			var metadata:CompositeMetadata = new CompositeMetadata();
			metadata.addEventListener(MetadataEvent.FACET_REMOVE, onFacetRemoved);			
			metadata.addChildMetadata(childMetadata);
			assertFalse(onRemoveCalled);	
			
			metadata.addChildMetadata(childMetadata2);
			assertTrue(onRemoveCalled);	
			onRemoveCalled = false;
			
			metadata.addFacet(ownFacet);
			assertTrue(onRemoveCalled);	
										
			metadata.removeChildMetadata(childMetadata);
			
			assertEquals("childFacet2", KeyValueFacet(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA)).getValue(new ObjectIdentifier("childFacet2Key")));
									
			assertTrue(onRemoveCalled);	
			onRemoveCalled = false;
						
			metadata.removeChildMetadata(childMetadata2);		
			
			assertEquals("ownFacet", KeyValueFacet(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA)).getValue(new ObjectIdentifier("ownFacetKey")));	
			
			assertTrue(onRemoveCalled);				
			onRemoveCalled = false;
			
			metadata.removeFacet(ownFacet);
			assertTrue(onRemoveCalled);	
									
			assertNull(metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA));
			
			//Test the Catching of Errors
			var nullThrown:Boolean = false;
			var nsThrown:Boolean = false;
			try
			{
				metadata.removeFacet(null);
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, MediaFrameworkStrings.NULL_PARAM);
				nullThrown = true;
			}
			
			try
			{				
				metadata.removeFacet(new CustomFacet(null));
			}
			catch(error:IllegalOperationError)
			{
				assertEquals(error.message, MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
				nsThrown = true;
			}			
			assertTrue(nullThrown);
			assertTrue(nsThrown);
			
						
			function onFacetRemoved(event:MetadataEvent):void
			{								
				onRemoveCalled = true;
			}			
		}				
	}
}


import org.openvideoplayer.metadata.IFacet;
import org.openvideoplayer.metadata.Metadata
import org.openvideoplayer.utils.URL;
import flash.events.EventDispatcher;
import org.openvideoplayer.metadata.IIdentifier;
	

internal class CustomFacet extends EventDispatcher implements IFacet
{
		
	public function CustomFacet(ns:URL)
	{
		_ns = ns;
	}

	
	public function get namespaceURL():URL
	{
		return _ns;
	}
	
	public function getValue(identifier:IIdentifier):*
	{
		return undefined;
	}
	
	public function merge(childFacet:IFacet):IFacet
	{
		return this;
	}
	
	private var _ns:URL;
}