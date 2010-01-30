package org.osmf.composition
{
	import org.osmf.drm.DRMState;
	import org.osmf.events.DRMEvent;
	import org.osmf.media.MediaElement;
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
		}		
		
		/**
		 * @private
		 */
		public function attach():void
		{
			traitAggregationHelper.attach();
		}
		
		/**
		 * @private
		 */
		public function detach():void
		{
			traitAggregationHelper.detach();
		}
		
		/**
		 * @private 
		 */ 
		override public function get authenticationMethod():String
		{
			var authMethod:String = null;
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
			
			return authMethod;
		}

		/**
		 * @private 
		 */ 
		override public function get endDate():Date
		{
			var end:Date = null;
			traitAggregator.forEachChildTrait(
			function(trait:DRMTrait):void
			{
				end = end ? (end.time < trait.endDate.time ? end : trait.endDate ) : trait.endDate;			
			},MediaTraitType.DRM);
			
			return end;
		}
		
		/**
		 * @private 
		 */ 
		override public function get startDate():Date
		{
			var start:Date = null;
			traitAggregator.forEachChildTrait(
			function(trait:DRMTrait):void
			{
				start = start ? (start.time < trait.startDate.time ? start : trait.startDate ) : trait.startDate;			
			},MediaTraitType.DRM);
			
			return start;
		}
		
		/**
		 * @private 
		 */ 
		override public function get period():Number
		{
			var smallestPeriod:Number = NaN;
			traitAggregator.forEachChildTrait(
			function(trait:DRMTrait):void
			{
				smallestPeriod = (smallestPeriod < trait.period) ? smallestPeriod : trait.period;			
			},MediaTraitType.DRM);
			
			return smallestPeriod;
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
			traitAggregator.forEachChildTrait(
			function(trait:DRMTrait):void
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
						calculatedDrmState = trait.drmState;
						break;
					case DRMState.AUTHENTICATING:
						if (calculatedDrmState != DRMState.INITIALIZING)
						{
							calculatedDrmState = trait.drmState;
						}
						break;						
					case DRMState.AUTHENTICATED:
						if (calculatedDrmState != DRMState.INITIALIZING &&
							calculatedDrmState != DRMState.AUTHENTICATING)
						{
							calculatedDrmState = trait.drmState;
						}
						break;
				}			
			},MediaTraitType.DRM);
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
				child = traitAggregator.getNextChildWithTrait(null, MediaTraitType.DRM);
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
			traitAggregationHelper.detach();
			traitAggregationHelper = null;
			
			super.dispose();
		}
		
		private function processAggregatedChild(childTrait:MediaTraitBase, child:MediaElement):void
		{
			DRMTrait(childTrait).addEventListener(DRMEvent.DRM_STATE_CHANGE, onDRMStateChange);							
			onDRMStateChange(new DRMEvent(DRMEvent.DRM_STATE_CHANGE, calculatedDrmState));
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
			if (oldState != calculatedDrmState)
			{
				drmStateChange(calculatedDrmState, event.token, event.error, startDate, endDate, period, event.serverURL);
			}
		}
		
		private var mode:CompositionMode;
		private var calculatedDrmState:String = "";
		private var traitAggregationHelper:TraitAggregationHelper
		private var owner:MediaElement;
		private var traitAggregator:TraitAggregator;
		
	}
}