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
package org.osmf.elements.compositeClasses
{
	import org.osmf.elements.CompositionMode;
	import org.osmf.events.DRMEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DRMState;
	import org.osmf.traits.DRMTrait;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;

	/**
	 * @private
	 */
	internal class CompositeDRMTrait extends DRMTrait implements IReusable
	{
		/**
		 * @private 
		 */ 
		public function CompositeDRMTrait(traitAggregator:TraitAggregator, owner:MediaElement, mode:CompositionMode)
		{
			super();
			
			this.mode = mode;
			this.traitAggregator = traitAggregator;
			this.owner = owner;
			traitAggregationHelper = new TraitAggregationHelper
				( traitType
				, traitAggregator
				, processAggregatedChild
				, processUnaggregatedChild
				);		
			if (mode == CompositionMode.SERIAL)
			{
				traitAggregator.addEventListener(TraitAggregatorEvent.LISTENED_CHILD_CHANGE, listenedChildChange);		
			}
		}		
		
		/**
		 * @private
		 */
		public function attach():void
		{
			if (traitAggregationHelper)
			{
				traitAggregationHelper.attach();
			}
		}
		
		/**
		 * @private
		 */
		public function detach():void
		{
			if (traitAggregationHelper)
			{
				traitAggregationHelper.detach();
			}
		}
		
		/**
		 * @private 
		 */ 
		override public function get authenticationMethod():String
		{
			var authMethod:String = null;			
			if (mode == CompositionMode.SERIAL)
			{
				var listenedTrait:DRMTrait = traitAggregator.listenedChild ? traitAggregator.listenedChild.getTrait(MediaTraitType.DRM) as DRMTrait : null;
				authMethod = listenedTrait ? listenedTrait.authenticationMethod : "";		
			}
			else //Parallel
			{					
				traitAggregator.forEachChildTrait(
				function(trait:DRMTrait):void
				{
					if (authMethod == "" || trait.authenticationMethod == "")
					{
						authMethod = "";
					}
					else
					{					
						if (!authMethod)
						{
							authMethod = trait.authenticationMethod;
						} 
						else if (authMethod != trait.authenticationMethod)
						{
							authMethod = "Both";
						}
					}
					
				},MediaTraitType.DRM);
			}
			return authMethod;
		}

		/**
		 * @private 
		 */ 
		override public function get endDate():Date
		{
			var end:Date = null;
			if (mode == CompositionMode.SERIAL)
			{
				var listenedTrait:DRMTrait = traitAggregator.listenedChild ? traitAggregator.listenedChild.getTrait(MediaTraitType.DRM) as DRMTrait : null;
				end = listenedTrait ? listenedTrait.endDate : null;		
			}
			else //Parallel
			{				
				traitAggregator.forEachChildTrait(
				function(trait:DRMTrait):void
				{
					end = end && trait.endDate ? (end.time < trait.endDate.time ? end : trait.endDate ) : trait.endDate;					
				},MediaTraitType.DRM);
			}
			
			return end;			
		}
		
		/**
		 * @private 
		 */ 
		override public function get startDate():Date
		{
			var start:Date = null;
			if (mode == CompositionMode.SERIAL)
			{
				var listenedTrait:DRMTrait = traitAggregator.listenedChild ? traitAggregator.listenedChild.getTrait(MediaTraitType.DRM) as DRMTrait : null;
				start = listenedTrait ? listenedTrait.startDate : null;		
			}
			else //Parallel
			{				
				traitAggregator.forEachChildTrait(
				function(trait:DRMTrait):void
				{
					start = start && trait.startDate ? (start.time > trait.startDate.time ? start : trait.startDate) : trait.startDate;			
				},MediaTraitType.DRM);
			}
			
			return start;
		}
		
		/**
		 * @private 
		 */ 
		override public function get period():Number
		{
			var calculatedPeriod:Number = NaN;
			if (mode == CompositionMode.SERIAL)
			{
				var listenedTrait:DRMTrait = traitAggregator.listenedChild ? traitAggregator.listenedChild.getTrait(MediaTraitType.DRM) as DRMTrait : null;
				calculatedPeriod = listenedTrait ? listenedTrait.period : NaN;		
			}
			else //Parallel
			{					
				traitAggregator.forEachChildTrait(
				function(trait:DRMTrait):void
				{
					calculatedPeriod = (calculatedPeriod < trait.period) ? calculatedPeriod : trait.period;			
				},MediaTraitType.DRM);
			}
			
			return calculatedPeriod;
		}
	
		/**
		 * @private 
		 */ 
		override public function get drmState():String
		{
			return calculatedDrmState;			
		}
		
		private function recalculateDRMState():void
		{
			calculatedDrmState = "";
			if (mode == CompositionMode.SERIAL)
			{
				var listenedTrait:DRMTrait = traitAggregator.listenedChild ? traitAggregator.listenedChild.getTrait(MediaTraitType.DRM) as DRMTrait : null;
				calculatedDrmState = listenedTrait ? listenedTrait.drmState : DRMState.INITIALIZING;		
			}
			else //Parallel
			{			
				function nextChildTrait(trait:DRMTrait):void
				{												
					switch(trait.drmState)
					{
						
						case DRMState.AUTHENTICATE_FAILED:
							calculatedDrmState = trait.drmState;
							break;
						case DRMState.AUTHENTICATION_NEEDED:
							if (calculatedDrmState != DRMState.AUTHENTICATE_FAILED)
							{
								calculatedDrmState = trait.drmState;
							}
							break;
						case DRMState.INITIALIZING:
							if (calculatedDrmState != DRMState.AUTHENTICATE_FAILED &&
								calculatedDrmState != DRMState.AUTHENTICATION_NEEDED)
							{
								calculatedDrmState = trait.drmState;
							}
							break;
						case DRMState.AUTHENTICATING:
							if (calculatedDrmState != DRMState.AUTHENTICATE_FAILED &&
								calculatedDrmState != DRMState.AUTHENTICATION_NEEDED &&
								calculatedDrmState != DRMState.INITIALIZING)
							{
								calculatedDrmState = trait.drmState;
							}
							break;						
						case DRMState.AUTHENTICATED:
							if (calculatedDrmState != DRMState.AUTHENTICATE_FAILED &&
								calculatedDrmState != DRMState.AUTHENTICATION_NEEDED &&
								calculatedDrmState != DRMState.INITIALIZING &&
								calculatedDrmState != DRMState.AUTHENTICATING)
							{
								calculatedDrmState = trait.drmState;
							}
							break;
					}			
				}					
				traitAggregator.forEachChildTrait(nextChildTrait, MediaTraitType.DRM);
			}
		}
		
		/**
		 * @private 
		 */ 
		override public function get serverURL():String
		{
			var child:MediaElement = traitAggregator.getNextChildWithTrait(null, MediaTraitType.DRM);
			var drmTrait:DRMTrait;
			while (child != null)
			{
				drmTrait = child.getTrait(MediaTraitType.DRM) as DRMTrait;
				if (drmTrait.drmState == DRMState.AUTHENTICATE_FAILED || 
					drmTrait.drmState == DRMState.AUTHENTICATION_NEEDED )
				{
					return drmTrait.serverURL;
				}			
				child = traitAggregator.getNextChildWithTrait(child, MediaTraitType.DRM);
			}			
			return drmTrait.serverURL;
		}
		
		/**
		 * @private 
		 */ 
		override public function authenticate(username:String=null, password:String=null):void
		{			
			var child:MediaElement = null;
			child = traitAggregator.getNextChildWithTrait(child, MediaTraitType.DRM);
			while (child != null)
			{		
				var trait:DRMTrait = child.getTrait(MediaTraitType.DRM) as DRMTrait;							
				if (trait.drmState == DRMState.AUTHENTICATION_NEEDED)
				{
					trait.authenticate(username, password);					
					return;
				}
				child = traitAggregator.getNextChildWithTrait(child, MediaTraitType.DRM);
			}
		}
		
		/**
		 * @private 
		 */ 		
		override public function authenticateWithToken(token:Object):void
		{		
			var child:MediaElement = null;
			child = traitAggregator.getNextChildWithTrait(child, MediaTraitType.DRM);
			while (child != null)
			{		
				var trait:DRMTrait = child.getTrait(MediaTraitType.DRM) as DRMTrait;							
				if (trait.drmState == DRMState.AUTHENTICATION_NEEDED)
				{
					trait.authenticateWithToken(token);
					return;
				}
				child = traitAggregator.getNextChildWithTrait(child, MediaTraitType.DRM);
			}
		}
		
		/**
		 * @private 
		 */ 		
		override public function dispose():void
		{
			if (traitAggregationHelper != null)
			{
				traitAggregationHelper.detach();
				traitAggregationHelper = null;
			}
			super.dispose();
		}
		
		private function processAggregatedChild(childTrait:MediaTraitBase, child:MediaElement):void
		{			
			DRMTrait(childTrait).addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);						
			onDRMStateChange(new DRMEvent(DRMEvent.DRM_STATE_CHANGE, DRMTrait(childTrait).drmState));
		}
		
		private function processUnaggregatedChild(childTrait:MediaTraitBase, child:MediaElement):void
		{			
			DRMTrait(childTrait).removeEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);	
			onDRMStateChange(new DRMEvent(DRMEvent.DRM_STATE_CHANGE, calculatedDrmState));
		}
		
		private function onDRMStateChange(event:DRMEvent):void
		{			
			var oldState:String = calculatedDrmState;
			recalculateDRMState();		
			if (oldState != calculatedDrmState ||
					(calculatedDrmState == DRMState.AUTHENTICATION_NEEDED &&  //If we authenticated once piece of content, and there are still others, disptatch another auth needed.
					 event.drmState	== DRMState.AUTHENTICATED))
			{				
				drmStateChange(calculatedDrmState, event.token, event.error, startDate, endDate, period, event.serverURL);
			}
		}
		
		private function listenedChildChange(event:TraitAggregatorEvent):void
		{			
			var oldState:String = calculatedDrmState;
			onDRMStateChange(new DRMEvent(DRMEvent.DRM_STATE_CHANGE, null));			
		}
		
		private var mode:CompositionMode;
		private var calculatedDrmState:String = "";
		private var traitAggregationHelper:TraitAggregationHelper
		private var owner:MediaElement;
		private var traitAggregator:TraitAggregator;
		
	}
}