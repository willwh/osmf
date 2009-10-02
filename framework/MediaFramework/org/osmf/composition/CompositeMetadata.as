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
package org.osmf.composition
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;

	/**
	 * CompositeMetadata takes additional Metadata classes and makes them appear
	 * as one metadata collection.  Any facet conflicts are solved using the merge()
	 * operation on the IFacet.  
	 */ 
	internal class CompositeMetadata extends Metadata
	{		
		/**
		 * Merges the metadata into this composite collection.  Any changes to the 
		 * child metadata will be reflected in this metadata, until it is removed.
		 */ 
		public function addChildMetadata(value:Metadata):void
		{
			_childrenMetadata.push(value);
			var namespaces:Vector.<String> = value.namespaceURLs;
			for each ( var space:String in namespaces)
			{				
				onFacetAdded(new MetadataEvent(value.getFacet(new URL(space)),MetadataEvent.FACET_ADD));										
			}
			value.addEventListener(MetadataEvent.FACET_ADD, onFacetAdded);
			value.addEventListener(MetadataEvent.FACET_REMOVE, onFacetRemoved);
		}
		
		/**
		 * Unmerges the child metadata from this composite collection.  
		 */ 
		public function removeChildMetadata(value:Metadata):void
		{
			_childrenMetadata.splice(_childrenMetadata.indexOf(value), 1);
			var namespaces:Vector.<String> = value.namespaceURLs;			
			for each (var space:String in namespaces)
			{			
				onFacetRemoved(new MetadataEvent(value.getFacet(new URL(space)),MetadataEvent.FACET_REMOVE));										
			}
			value.removeEventListener(MetadataEvent.FACET_ADD, onFacetAdded);
			value.removeEventListener(MetadataEvent.FACET_REMOVE, onFacetRemoved);			
		}
		
		/**
		 * @inheritDoc
		 */ 		
		override public function getFacet(nameSpace:URL):IFacet
		{
			return _mergedFacets[nameSpace.rawUrl];
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function get namespaceURLs():Vector.<String>
		{
			var namespaces:Vector.<String> = new Vector.<String>;			
			for each (var facet:IFacet in _mergedFacets)
			{
				namespaces.push(facet.namespaceURL);										
			}			
			return namespaces;	
		}
		
		/**
		 * @inheritDoc
		 * Adds the facet to this composite element, but not any of it's children.
		 */ 	
		override public function addFacet(value:IFacet):void
		{	
			if (value == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
				return;
			}
			else if (value.namespaceURL == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
				return;
			}	
			var oldFacet:* = _mergedFacets[value.namespaceURL.rawUrl];
									
			if (oldFacet != undefined)
			{
				signalRemove(oldFacet);
			}
			ownFacets[value.namespaceURL.rawUrl]  = value;
			//Recompute the merged facet.		
			remergeAll(value.namespaceURL);	
			
			signalAdd(value);
		}
		
		/**
		 * @inheritDoc
		 * Remove's the facet to this composite element, but not any of it's children.
		 */ 		
		override public function removeFacet(value:IFacet):IFacet
		{	
			if (value == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
				return;
			}
			else if (value.namespaceURL == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
				return;
			}
			if(ownFacets[value.namespaceURL.rawUrl] != undefined)
			{
				delete ownFacets[value.namespaceURL.rawUrl];
				
				signalRemove(_mergedFacets[value.namespaceURL.rawUrl]);				
				//Recompute the merged facet.
				remergeAll(value.namespaceURL);			
									
				if (_mergedFacets[value.namespaceURL.rawUrl] != undefined)
				{
					signalAdd(_mergedFacets[value.namespaceURL.rawUrl]);			
				}
			}							
			return value;
		}
				
		private function onFacetAdded(event:MetadataEvent):void
		{			
			if (_mergedFacets[event.facet.namespaceURL.rawUrl] == undefined)
			{
				_mergedFacets[event.facet.namespaceURL.rawUrl] = event.facet;
				signalAdd(event.facet);
			}
			else
			{
				signalRemove(_mergedFacets[event.facet.namespaceURL.rawUrl]);
				var merged:IFacet = _mergedFacets[event.facet.namespaceURL.rawUrl].merge(event.facet);
				if(merged != null)
				{
					_mergedFacets[event.facet.namespaceURL.rawUrl] = merged;
					signalAdd(_mergedFacets[event.facet.namespaceURL.rawUrl]);	
				}			
			}			
		}
		
		private function onFacetRemoved(event:MetadataEvent):void
		{	
			var removed:* = _mergedFacets[event.facet.namespaceURL.rawUrl];
					
			if (removed != undefined)
			{
				signalRemove(_mergedFacets[event.facet.namespaceURL.rawUrl]);
			}
			remergeAll(event.facet.namespaceURL);
			if (_mergedFacets[event.facet.namespaceURL.rawUrl] != undefined)
			{
				signalAdd(_mergedFacets[event.facet.namespaceURL.rawUrl]);		
			}	 								
		}
				
		private function remergeAll(namespaceURL:URL):void
		{		
			var startFacet:* = undefined;
			if (ownFacets[namespaceURL.rawUrl] != undefined)
			{	
				startFacet = ownFacets[namespaceURL.rawUrl];
			}				
			for each (var data:Metadata in _childrenMetadata)
			{
				if (startFacet == undefined)
				{
					startFacet = data.getFacet(namespaceURL);					
				}
				else
				{
					var childFacet:IFacet = data.getFacet(namespaceURL);
					if(childFacet)
					{
						var merged:IFacet = startFacet.merge(childFacet);
						if(merged != null)
						{
							startFacet = merged;
						}
					}
				}				
			}	
			if(startFacet != undefined)
			{
				_mergedFacets[namespaceURL.rawUrl] = startFacet;		
			}
			else
			{
				delete _mergedFacets[namespaceURL.rawUrl];
			}		
		}
		
		private function signalRemove(facet:IFacet):void
		{
			dispatchEvent(new MetadataEvent(facet, MetadataEvent.FACET_REMOVE));
		}
		
		private function signalAdd(facet:IFacet):void
		{
			dispatchEvent(new MetadataEvent(facet, MetadataEvent.FACET_ADD));
		}
				
		private var _childrenMetadata:Vector.<Metadata> = new Vector.<Metadata>();
		private var ownFacets:Dictionary = new Dictionary();			
		private var _mergedFacets:Dictionary = new Dictionary();				
				
	}
}