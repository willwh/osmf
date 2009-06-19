/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.media
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
		 * Returns the IMediaInfo that is capable of handling the specified
		 * IMediaResource. 
		 * 
		 * @param resource The IMediaResource to match against an added
		 * IMediaInfo.
		 * 
		 * @return The IMediaInfo that can handle the specified IMediaResource or
         * <code>null</code> if no such IMediaInfo exists in this factory.
		 **/
		function getMediaInfoByResource(resource:IMediaResource):IMediaInfo;

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