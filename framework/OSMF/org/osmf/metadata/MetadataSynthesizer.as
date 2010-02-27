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
	import org.osmf.elements.compositeClasses.CompositionMode;
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Defines an algorithm that can synthesize a metadata value
	 * from any number of metadata values of a given namespace, in
	 * the context of a target parent Metadata, MetadataGroup, CompositionMode, 
	 * and active parent Metadata context.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class MetadataSynthesizer
	{
		/**
		 * Constructor
		 * 
		 * @param namespaceURL Defines the namespace of the metadata values
		 * that the synthesizer can interpret.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function MetadataSynthesizer(namespaceURL:String)
		{
			_namespaceURL = namespaceURL;
		}
		
		
		/**
		 * Defines the namespace of the metadata values that the synthesizer
		 * can interpret.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get namespaceURL():String
		{
			return _namespaceURL;
		}
		
		/**
		 * Synthesizes a metadata value from the passed arguments.
		 * 
		 * If the specified mode is SERIAL, then the active metadata of the synthesizer's
		 * type will be returned as the synthesized metadata.
		 * 
		 * If the specified mode is PARALLEL, then the synthesized metadata value will be null,
		 * unless the metadata group contains a single child, in which case the single child is
		 * what is return as the synthesized metadata.
		 * 
		 * @param targetParentMetadata The parent metadata that will have the synthesized
		 * value appended.
		 * @param metadataGroup The group of metadata objects the synthesized value should be based
		 * on.
		 * @param mode The CompositionMode of synthesis that should be applied.
		 * @param activeParentMetadata If the targetParentMetadata value belongs to a
		 * SerialElement this value references the metadata of its currently active child.
		 * @return The synthesized value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function synthesize
							( targetParentMetadata:Metadata
							, metadataGroup:MetadataGroup
							, mode:String
							, activeParentMetadata:Metadata
							):Metadata
		{	
			var result:Metadata;
			
			if (mode == CompositionMode.SERIAL && activeParentMetadata)
			{
				// Return the currently active metadata:
				result = activeParentMetadata.getValue(_namespaceURL) as Metadata;
			}
			else // mode is PARALLEL
			{
				// If the metadata group contains a single Metadata, then
				// return that as the synthesized metadata. Otherwise
				// return null:
				result
					= (metadataGroup && metadataGroup.length == 1)
						? metadataGroup.getMetadataAt(0)
						: null;
			}
			
			return result;
		}

		// Internals
		//
		
		private var _namespaceURL:String;
	}
}