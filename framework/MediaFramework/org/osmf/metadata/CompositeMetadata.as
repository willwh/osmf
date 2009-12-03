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
package org.osmf.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.osmf.composition.CompositionMode;
	import org.osmf.events.CompositeMetadataEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;

	/**
	 * Event fired when a child metadata instance was added to the composite. 
	 */	
	[Event(name="childAdd", type="org.osmf.events.CompositeMetadataEvent")]
	
	/**
	 * Event fired when a child metadata instance was removed from the composite. 
	 */
	[Event(name="childRemove", type="org.osmf.events.CompositeMetadataEvent")]
	
	/**
	 * Event fired when a child metadata instance got a facet added. 
	 */
	[Event(name="childFacetAdd", type="org.osmf.events.CompositeMetadataEvent")]
	
	/**
	 * Event fired when a child metadata instance got a facet removed. 
	 */
	[Event(name="childFacetRemove", type="org.osmf.events.CompositeMetadataEvent")]
	
	/**
	 * Event fired when a new facet group emerged. 
	 */
	[Event(name="facetGroupAdd", type="org.osmf.event.CompositeMetadataEvent")]
	
	/**
	 * Event fired when an existing facet group seized to exist. 
	 */
	[Event(name="facetGroupRemove", type="org.osmf.event.CompositeMetadataEvent")]
	
	/**
	 * Event fired when a facet group changed. 
	 */
	[Event(name="facetGroupChange", type="org.osmf.event.CompositeMetadataEvent")]
	
	/**
	 * Defines a piece of meta data that keeps track of a collection
	 * of child meta data references as a plain list.
	 * 
	 * By default, no syntesis takes place. External clients can inspect facet
	 * groups at will, and monitor them for change. However, the class provides
	 * any infrastructure for synthesis like so:
	 * 
	 * By using 'addFacetSynthesizer' and 'removeFacetSynthesizer', clients can
	 * define how facets groups of a given name space will be synthesized into
	 * a new facet. If a facet group changes that matches an added facet
	 * synthesizer's namespace, then this synthesizer is used to synthesize the
	 * composite value. After synthesis, the value gets added as one of the
	 * composite's own facets.
	 * 
	 * If a CompositeMetadata instance is itself a child of another
	 * CompositeMetadata instance, then any facet synthesizer that is set on
	 * the parent instance, will be used by the child instance automatically
	 * too. If the child has its own facet synthesizer listed, than that
	 * synthesizer takes precedence over the inherited one.
	 * 
	 * Last, facet synthesis occurs if the first facet from a FacetGroup
	 * returns a facet synthesizer for it IFacet.synthesizer property. Facet
	 * synthesizer set on this class directly, or indirectly via its parent,
	 * take precedence over the facet's suggested synthesizer.
	 * 
	 */	
	public class CompositeMetadata extends Metadata
	{
		// Public Interface
		//
		
		/**
		 * Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function CompositeMetadata()
		{
			super();
			
			children = new Vector.<Metadata>();
			childFacetGroups = new Dictionary();
			
			facetSynthesizers = new Dictionary();
		}
		
		/**
		 * Adds a metadata child.
		 * 
		 * @param child The child to add.
		 * @throws IllegalOperationError Thrown if the specified child is
		 * already a child.
		 * @throws ArgumentError if the specified child is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function addChild(child:Metadata):void
		{
			if (child == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			var childIndex:int = children.indexOf(child);
			if (childIndex != -1)
			{
				throw new IllegalOperationError();	
			}
			else
			{
				children.push(child);
				childrenLength++;
				
				child.addEventListener
					( MetadataEvent.FACET_ADD
					, onChildFacetAdd
					);
					
				child.addEventListener
					( MetadataEvent.FACET_REMOVE
					, onChildFacetRemove
					);
					
				if (child is CompositeMetadata)
				{
					child.addEventListener
						( CompositeMetadataEvent.FACET_GROUP_CHANGE
						, onChildFacetGroupChange
						);
				}
					
				for each (var url:String in child.namespaceURLs)
				{
					processChildFacetAdd(child, child.getFacet(new URL(url)));
				}
				
				dispatchEvent
					( new CompositeMetadataEvent
						( CompositeMetadataEvent.CHILD_ADD
						, false, false
						, child
						)
					);
			}
		}
		
		/**
		 * Removes a metadata child.
		 * 
		 * @param child The child to remove.
		 * @throws IllegalOperationError Thrown if the specified child is
		 * not a child.
		 * @throws ArgumentError if the specified child is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function removeChild(child:Metadata):void
		{
			if (child == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			var childIndex:int = children.indexOf(child);
			if (childIndex == -1)
			{
				throw new IllegalOperationError();
			}	
			else
			{
				children.splice(childIndex,1);
				childrenLength--;
				
				child.removeEventListener
					( MetadataEvent.FACET_ADD
					, onChildFacetAdd
					);
					
				child.removeEventListener
					( MetadataEvent.FACET_REMOVE
					, onChildFacetRemove
					);
				
				if (child is CompositeMetadata)
				{
					child.removeEventListener
						( CompositeMetadataEvent.FACET_GROUP_CHANGE
						, onChildFacetGroupChange
						);
				}
				
				for each (var url:String in child.namespaceURLs)
				{
					processChildFacetRemove(child, child.getFacet(new URL(url)));
				}
				
				dispatchEvent
					( new CompositeMetadataEvent
						( CompositeMetadataEvent.CHILD_REMOVE
						, false, false
						, child
						)
					);
			}
		}
		
		/**
		 * Defines the number of metadata children.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get numChildren():uint
		{
			return childrenLength;
		}
		
		/**
		 * Fetches the child at the indicated index. 
		 * 
		 * @param index The index of the child metadata to fetch.
		 * @return The requested metadata.
		 * @throws RangeError Thrown when the specified index is out of
		 * bounds.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function childAt(index:uint):Metadata
		{
			if (index >= childrenLength)
			{
				throw new RangeError();	
			}
			
			return children[index];
		}
		
		/**
		 * Defines the composition mode that will be forwarded to facet
		 * synthesizers when synthesizing a merged facet is required.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function set mode(value:CompositionMode):void
		{
			if (_mode != value)
			{
				_mode = value;
				
				processSynthesisDepencyChanged();
			}
		}
		public function get mode():CompositionMode
		{
			return _mode;
		}
		
		/**
		 * Defines the active piece of metadata that will be forwarded
		 * to facet synthesizers when synthesizing a merged facet is
		 * required.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function set activeChild(value:Metadata):void
		{
			if (_activeChild != value)
			{
				_activeChild = value;
				
				processSynthesisDepencyChanged();
			}
		}
		public function get activeChild():Metadata
		{
			return _activeChild;
		}
		
		/**
		 * Adds a facet synthesizer.
		 * 
		 * A facet synthesizer can synthesize a facet from a given FacetGroup,
		 * composition mode, and active metadata child (if any).
		 * 
		 * Only one synthesizer can be registered for a given namespace URL.
		 * 
		 * @param synthesizer The facet synthesizer to add.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function addFacetSynthesizer(synthesizer:FacetSynthesizer):void
		{
			if (synthesizer == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (getFacetSynthesizer(synthesizer.namespaceURL) != null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NAMESPACE_MUST_BE_UNIQUE));
			}
			
			facetSynthesizers[synthesizer.namespaceURL.rawUrl] = synthesizer;
		}
		
		/**
		 * Removes a facet synthesizer.
		 * 
		 * @param synthesizer The facet synthesizer to remove.
		 * @throws ArgumentError If synthesizer is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function removeFacetSynthesizer(synthesizer:FacetSynthesizer):void
		{
			if (synthesizer == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (getFacetSynthesizer(synthesizer.namespaceURL) != null)
			{
				delete facetSynthesizers[synthesizer.namespaceURL.rawUrl];
			}
		}
		
		/**
		 * Fetches the facet synthesizer (if any) for the given namespace URL.
		 * 
		 * @param namespaceURL The namespace to retreive the set synthesizer for.
		 * @return The requested syntesizer, if it was set, null otherwise.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function getFacetSynthesizer(namespaceURL:URL):FacetSynthesizer
		{
			var result:FacetSynthesizer;
			
			if (namespaceURL)
			{
				var namespaceString:String = namespaceURL.toString();
				for (var rawUrl:String in facetSynthesizers)
				{
					if (rawUrl == namespaceString)
					{
						result = facetSynthesizers[rawUrl];
						break;
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Collects the namespaces of the facet groups that are currently in existence.
		 *  
		 * @return The collected namespaces.
		 */		
		public function getFacetGroupNamespaceURLs():Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			
			for (var url:String in childFacetGroups)
			{
				result.push(url);
			}
			
			return result;
		}
		
		/**
		 * Fetches the facet group for the given namenspace.
		 *  
		 * @param namespaceURL The namespace to fetch the facet group for.
		 * @return The requested facet group, or null if there is no such group.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function getFacetGroup(namespaceURL:String):FacetGroup
		{
			if (namespaceURL == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			return childFacetGroups[namespaceURL];
		}
		
		// Internals
		//
		
		private function processChildFacetAdd(child:Metadata, facet:IFacet):void
		{
			var groupAddEvent:CompositeMetadataEvent;
			
			if (facet)
			{
				var childrenNamespace:URL = facet.namespaceURL;
				
				var facetGroup:FacetGroup = childFacetGroups[childrenNamespace.rawUrl];
				if (facetGroup == null)
				{
					childFacetGroups[childrenNamespace.rawUrl]
						= facetGroup
						= new FacetGroup(childrenNamespace);
						
					facetGroup.addEventListener(Event.CHANGE, onFacetGroupChange);
						
					groupAddEvent
						= new CompositeMetadataEvent
							( CompositeMetadataEvent.FACET_GROUP_ADD
							, false, false
							, child, facet, facetGroup
							);
				}
				
				facetGroup.addFacet(child, facet);
			}
				
			dispatchEvent
				( new CompositeMetadataEvent
					( CompositeMetadataEvent.CHILD_FACET_ADD
					, false, false
					, child
					, facet
					)
				);
				
			if (groupAddEvent)
			{
				dispatchEvent(groupAddEvent);
			}
		}
		
		private function processChildFacetRemove(child:Metadata, facet:IFacet):void
		{
			var groupRemoveEvent:CompositeMetadataEvent;
			
			if (facet)
			{
				var childrenNamespace:URL = facet.namespaceURL;
				var facetGroup:FacetGroup = childFacetGroups[childrenNamespace.rawUrl];
				facetGroup.removeFacet(child, facet);
				
				if (facetGroup.length == 0)
				{
					facetGroup.removeEventListener(Event.CHANGE, onFacetGroupChange);
					
					groupRemoveEvent
						= new CompositeMetadataEvent
							( CompositeMetadataEvent.FACET_GROUP_REMOVE
							, false, false
							, child, facet, facetGroup
							);
							
					delete childFacetGroups[childrenNamespace.rawUrl];
					
				}
			}
			
			dispatchEvent
				( new CompositeMetadataEvent
					( CompositeMetadataEvent.CHILD_FACET_REMOVE
					, false, false
					, child
					, facet
					)
				);
			
			if (groupRemoveEvent)
			{
				dispatchEvent(groupRemoveEvent);
			}
		}
		
		private function processSynthesisDepencyChanged():void
		{
			for each (var facetGroup:FacetGroup in childFacetGroups)
			{
				onFacetGroupChange(null, facetGroup);
			}
		}
		
		// Event Handlers
		//
		
		private function onChildFacetAdd(event:MetadataEvent):void
		{
			processChildFacetAdd(event.target as Metadata, event.facet);	
		}
		
		private function onChildFacetRemove(event:MetadataEvent):void
		{
			processChildFacetRemove(event.target as Metadata, event.facet);
		}
		
		private function onChildFacetGroupChange(event:CompositeMetadataEvent):void
		{
			// If no one before us was able to deliver a facet synthesizer, then perhaps we can:
			event.facetSynthesizer ||= facetSynthesizers[event.facetGroup.namespaceURL.rawUrl];
			
			var clonedEvent:CompositeMetadataEvent 
				=	event.clone()
				as	CompositeMetadataEvent;
				
			// Re-dispatch the event:
			dispatchEvent(clonedEvent);
			
			// If we didn't assign a facet synthesizer, then perhaps another handler did:
			event.facetSynthesizer ||= clonedEvent.facetSynthesizer;
		}
		
		private function onFacetGroupChange(event:Event, facetGroup:FacetGroup = null):void
		{
			facetGroup ||= event ? (event.target as FacetGroup) : null;
			
			var synthesizedFacet:IFacet;
			var facetSynthesizer:FacetSynthesizer = facetSynthesizers[facetGroup.namespaceURL.rawUrl];
			
			var localEvent:CompositeMetadataEvent
				= new CompositeMetadataEvent
					( CompositeMetadataEvent.FACET_GROUP_CHANGE
					, false, false
					, null, null
					, facetGroup
					, facetSynthesizer
					)
			
			dispatchEvent(localEvent);
			
			// If no facet synthesizer is set yet, then first see if any of the
			// event handlers provided us with one. If not, then use the facet's
			// default synthesizer (if it provides for one):
			facetSynthesizer
				||= localEvent.facetSynthesizer
				||	(	(facetGroup.length > 0)
							? facetGroup.getFacetAt(0).synthesizer
							: null
					); 
				
			if (facetSynthesizer != null)
			{
				// Run the facet synthesizer:
				synthesizedFacet
					= facetSynthesizer.synthesize
						( this
						, facetGroup
						, _mode
						, _activeChild
						);
			}
			
			if (synthesizedFacet == null)
			{
				var currentFacet:IFacet = getFacet(facetGroup.namespaceURL);
				if (currentFacet)
				{
					removeFacet(currentFacet);
				}
			}
			else
			{
				addFacet(synthesizedFacet);
			}
		}
		
		private var _mode:CompositionMode;
		private var _activeChild:Metadata;
		
		private var children:Vector.<Metadata>;
		private var childrenLength:uint = 0;
		
		private var childFacetGroups:Dictionary; 
		
		private var facetSynthesizers:Dictionary;
	}
}