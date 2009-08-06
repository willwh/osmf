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
package org.openvideoplayer.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	
	 
	/**
	 *  The MetadataCollection interface is the default implementation for metadata carrying media.
	 */ 
	public class Metadata implements IMetadata
	{
		/**
		 * @inheritDoc
		 */ 
		public function getFacetTypes(nameSpace:URL):Vector.<FacetType>
		{
			var typeList:Vector.<FacetType> = new Vector.<FacetType>();
			if(nameSpace && _list[nameSpace.rawUrl])
			{						
				for each(var facet:IFacet in _list[nameSpace.rawUrl])
				{
					typeList.push(facet.facetType);
				}
			}
			return typeList;
		}
		 
		/**
		 * @inheritDoc
		 */ 
		public function getFacet(nameSpace:URL, facetType:FacetType):IFacet
		{				
			var exists:Boolean = nameSpace ? _list[nameSpace.rawUrl] != null : false;
						
			if(exists)
			{
				return _list[nameSpace.rawUrl][facetType] as IFacet;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function addFacet(data:IFacet):void
		{
			if(data == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			else if(data.nameSpace == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
			}			
			else if(_list[data.nameSpace.rawUrl] == null)
			{
				_list[data.nameSpace.rawUrl] = new Dictionary();
			}
			_list[data.nameSpace.rawUrl][data.facetType] = data;						
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function removeFacet(data:IFacet):IFacet
		{		
			if(data == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			else if(data.nameSpace == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
			}	
			if(_list[data.nameSpace.rawUrl])
			{			
				delete _list[data.nameSpace.rawUrl][data.facetType];				
			}					
			return data;		
		}
				
					
		private var _list:Dictionary = new Dictionary();	
	}
}