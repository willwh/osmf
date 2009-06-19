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
	 * An IMediaInfo is an encapsulation of the information needed to
	 * dynamically create a MediaElement.  It extends IMediaResourceHandler
	 * because it needs to indicate for which IMediaResources it can
	 * create corresponding MediaElements.
	 */	
	public interface IMediaInfo extends IMediaResourceHandler
	{
		/**
		 * An identifier that represents this IMediaInfo.
		 **/
		function get id():String;
				
		/**
		 * Returns a MediaElement that can render the given IMediaResource,
		 * null if this IMediaInfo object is not capable of creating such
		 * a MediaElement (as indicated by canHandleResource).
		 * 
		 * @param resource The IMediaResource for which a corresponding
		 * MediaElement should be created.
		 * 
		 * @throws IllegalOperationError If this IMediaInfo object handles
		 * the given resource, but is unable to create a corresponding
		 * MediaElement.
		 **/
		function createMediaElement(resource:IMediaResource):MediaElement;
	}
}