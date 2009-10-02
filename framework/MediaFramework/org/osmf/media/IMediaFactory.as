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
	/**
	 * An IMediaFactory represents a factory class for media elements.
	 * 
     * <p>The factory operation takes an IMediaResource as input and produces a MediaElement
     * as output.</p>
     * <p>The IMediaFactory maintains a list of IMediaInfo objects,
     * each of which encapsulates all the information necessary to create 
     * a specific MediaElement. The IMediaFactory relies on
     * the <code>IMediaResourceHandler.canHandleResource()</code> method to find an IMediaInfo
     * object than can handle the specified IMediaResource.</p>
     *
     * <p>The factory interface also exposes methods for querying for specific IMediaInfo 
     * objects.</p>
     * @see IMediaInfo
     * @see IMediaResource
     * @see IMediaResourceHandler    
     * @see MediaElement
     * 
	 */	
	public interface IMediaFactory
	{
		/**
		 * Adds the specified IMediaInfo to the factory.
         * After the IMediaInfo has been added, for any IMediaResource
		 * that this IMediaInfo can handle, the factory will be able to create
		 * the corresponding media element.
		 * 
		 * If an IMediaInfo with the same ID already exists in this
         * factory, the new IMediaInfo object replaces it.
		 * 
		 * @param info The IMediaInfo to add.
		 * 
         * @throws ArgumentError If the argument is <code>null</code> or if the argument
         * has a <code>null</code> ID field.
		 **/
		function addMediaInfo(info:IMediaInfo):void;

		/**
		 * Removes the specified IMediaInfo from the factory.
		 * 
		 * If no such IMediaInfo exists in this factory, does nothing.
		 * 
		 * @param info The IMediaInfo to remove.
		 * 
         * @throws ArgumentError If the argument is <code>null</code> or if the argument
         * has a <code>null</code> ID field.
		 **/
		function removeMediaInfo(info:IMediaInfo):void

		/**
		 * The number of IMediaInfos managed by the factory.
		 **/
		function get numMediaInfos():int;
		
		/**
		 * Gets the IMediaInfo at the specified index.
		 * 
		 * @param index The index in the list from which to retrieve the IMediaInfo.
		 * 
		 * @return The IMediaInfo at that index or <code>null</code> if there is none.
		 **/
		function getMediaInfoAt(index:int):IMediaInfo;
		
		/**
         * Returns the IMediaInfo with the specified ID or <code>null</code> if the
         * specified IMediaInfo does not exist in this factory.
		 * 
		 * @param The ID of the IMediaInfo to retrieve.
		 * 
         * @return The IMediaInfo with the specified ID or <code>null</code> if the specified
		 * IMediaInfo does not exist in this factory. 
		 **/
		function getMediaInfoById(id:String):IMediaInfo;
		
		/**
		 * Returns a MediaElement that can be created based on the specified
		 * IMediaResource.
         * <p>Returns <code>null</code> if the
         * <code>IMediaResourceHandler.canHandleResource()</code> method cannot         
         * find an IMediaInfo object
         * capable of creating such a MediaElement in this factory.</p>
		 * 
         * @see IMediaResourceHandler#canHandleResource()
         *
		 * @param resource The IMediaResource for which a corresponding
		 * MediaElement should be created.
		 * 
         * @return The MediaElement that was created or <code>null</code> if no such
		 * MediaElement could be created from the IMediaResource.
		 * 
		 **/
		function createMediaElement(resource:IMediaResource):MediaElement;
	}
}