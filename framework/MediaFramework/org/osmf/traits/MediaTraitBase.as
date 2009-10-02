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
package org.osmf.traits
{
	import flash.events.EventDispatcher;
	
	import org.osmf.media.IMediaTrait;

	/**
	 * The MediaTraitBase class is the base class for all traits.
	 * Trait implementing classes should derive from this class. 
	 * <p>Currently it is a place holder class
	 * that extends EventDispatcher and
	 * implements IMediaTrait.</p> 
	 */	
	public class MediaTraitBase extends EventDispatcher implements IMediaTrait
	{
	}
}