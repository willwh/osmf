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
package org.osmf.tracking
{
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * A MediaElement which maps the IPlayable trait to the triggering of a
	 * Beacon.
	 **/
	public class BeaconElement extends MediaElement
	{
		/**
		 * Constructor.
		 * 
		 * @param url The Beacon to ping when this BeaconElement is played.
		 **/
		public function BeaconElement(beacon:Beacon)
		{
			this.beacon = beacon;

			super();
		}
		
		/**
		 * @private
		 **/
		override protected function setupTraits():void
		{
			addTrait(MediaTraitType.PLAYABLE, new BeaconPlayableTrait(this, beacon));
		}

		private var beacon:Beacon;
	}
}