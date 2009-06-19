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
	import flash.events.IEventDispatcher;
	
	/**
	 * An IMediaTrait is the encapsulation of a trait or capability that's
	 * inherent to a MediaElement.  The sum of all traits on a media element
	 * define the overall capabilities of the media element.
	 * 
	 * <p>Media traits are first-class members of the object model for a
	 * number of reasons:</p>
	 * <ul>
	 * <li>
	 * Traits allow us to isolate common aspects of different media types into
	 * reusable building blocks.  For example, music and video may share a
	 * common implementation for audio.  An "audible" trait can encapsulate
	 * that common implementation in such a way that it can be used for both
	 * media types, while still providing a uniform interface to these
	 * different media types.
	 * </li>
	 * <li>
	 * Different media elements may have their capabilities change dynamically
	 * over time, and traits allow us to isolate these capabilities in such
	 * a way that we can clearly express that dynamism.  For example, a video
	 * player might not initially be "viewable", due to its need to be loaded
	 * before playback can begin.  Rather than express this dynamism through
	 * changes to a set of methods on a monolithic media class, we can express
	 * it through the presence or absence of a trait instance on a lighter
	 * weight media class.
	 * </li>
	 * <li>Traits make compositioning scalable.  (Compositioning is the ability
	 * to temporally and spatially composite collections of media.)  If traits
	 * represent the overall vocabulary of the media framework, then we can
	 * implement compositioning primarily in terms of the traits, rather than
	 * in terms of the media that aggregate those traits.  This approach allows
	 * developers to create new media implementations that can easily integrate
	 * with the compositioning parts of the framework without requiring changes
	 * to that framework.  Our working assumption, of course, is that most (if
	 * not all) media will generally share the same vocabulary, which can be
	 * expressed through a core set of media traits.
	 * </li>
	 * <li>Traits allow for uniform, media-agnostic <i>client</i> classes.  For
	 * example, if a client class is capable of rendering the "viewable" trait,
	 * then it's capable of rendering any and all media that host that trait. </li>
	 * </ul>
	 * 
	 * <p>It's important to be aware of the relationship between a media trait
	 * and a media element.  Some media trait implementations will be tightly
	 * coupled to a specific type of media element, while others will be
	 * generic enough to work with any media element.  For example, an
	 * implementation of an IPlayable trait that works with video is typically
	 * going to be specific to one class of media elements, namely the class
	 * that plays video, since the playback operations will be specific to the
	 * underlying implementation of video (i.e. NetStream).  On the other hand,
	 * an implementation of IViewable might be able to work with any media
	 * element, since IViewable will use the same underlying media
	 * implementation (DisplayObject) for any media element.  Each trait
	 * implementation should clearly document in which of these two categories
	 * it resides.</p> 
	 **/	
	public interface IMediaTrait extends IEventDispatcher
	{
	}
}