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
	 * Interface for objects that are capable of referencing MediaElements.
	 **/
	public interface IMediaReferrer
	{
		/**
		 * Returns true if this object can reference the given MediaElement,
		 * false otherwise.
		 *
		 * @throws ArgumentError If the parameter is <code>null</code>.
		 **/
		function canReferenceMedia(target:MediaElement):Boolean;

		/**
		 * Adds a reference from this object to the given MediaElement.
		 * 
		 * <p>Note that the act of adding a reference to another MediaElement
		 * may result in an object reference which prevents the referenced
		 * MediaElement from being garbage collected.  As such, the
		 * implementing class should endeavor to release any such object
		 * references when it no longer needs to reference them.</p>
		 *
		 * @throws ArgumentError If the parameter is <code>null</code>.
		 **/
		function addReference(target:MediaElement):void;
	}
}
