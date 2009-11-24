package org.osmf.composition
{
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.IDownloadable;
	import org.osmf.traits.MediaTraitType;
	
	
	/**
	 * Dispatched when total size in bytes of data being loaded has changed.
	 * 
	 * @eventType org.osmf.events.LoadEvent
	 */	
	[Event(name="bytesTotalChange",type="org.osmf.events.LoadEvent")]


	/**
	 * Implementation of IBufferable which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite bufferable trait
	 * keeps all bufferable properties in sync for the composite element and its
	 * children.
	 **/
	public class CompositeDownloadableTrait extends CompositeMediaTraitBase implements IDownloadable
	{
		public function CompositeDownloadableTrait(mode:CompositionMode, traitAggregator:TraitAggregator)
		{
			super(MediaTraitType.DOWNLOADABLE, traitAggregator);
			this.mode = mode;
		}
		
		/**
		 * The number of bytes of data that have been loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bytesLoaded():Number
		{
			var computedLoaded:Number = 0;
			if (mode == CompositionMode.SERIAL)
			{
				var emptyUnitSeen:Boolean = false;
				traitAggregator.forEachChildTrait(
					function (trait:IDownloadable):void
					{			
						if (!emptyUnitSeen)
						{	
							emptyUnitSeen = emptyUnitSeen || trait.bytesLoaded <= 0; 		
							computedLoaded += trait.bytesLoaded;						
						}
					},
					MediaTraitType.DOWNLOADABLE);
			}
			else // Parallel
			{						
				traitAggregator.forEachChildTrait(
					function (trait:IDownloadable):void
					{											
						computedLoaded += trait.bytesLoaded;						
					},
					MediaTraitType.DOWNLOADABLE);
			}
			return computedLoaded;
		}
		
		/**
		 * The total size in bytes of the data being loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bytesTotal():Number
		{
			var computedTotal:Number = 0;
			if (mode == CompositionMode.SERIAL)
			{
				traitAggregator.forEachChildTrait(
					function (trait:IDownloadable):void
					{						
						computedTotal += trait.bytesTotal;						
					},
					MediaTraitType.DOWNLOADABLE);
			}
			else // Parallel
			{						
				traitAggregator.forEachChildTrait(
					function (trait:IDownloadable):void
					{											
						computedTotal += trait.bytesTotal;						
					},
					MediaTraitType.DOWNLOADABLE);
			}
			return computedTotal;
		}
		
		
		override protected function processAggregatedChild(trait:IMediaTrait):void
		{
			var downloadable:IDownloadable = trait as IDownloadable;
			downloadable.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, onBytesLoaded);
			downloadable.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE, onBytesTotal);	
		}
					
		override protected function processUnaggregatedChild(trait:IMediaTrait):void
		{
			var downloadable:IDownloadable = trait as IDownloadable;
			downloadable.removeEventListener(LoadEvent.BYTES_LOADED_CHANGE, onBytesLoaded);
			downloadable.removeEventListener(LoadEvent.BYTES_TOTAL_CHANGE, onBytesTotal);
		}
		
		private function onBytesTotal(event:LoadEvent):void
		{
			dispatchEvent(new LoadEvent(event.type, false, false, event.loadState, bytesTotal));
		}
		
		private function onBytesLoaded(event:LoadEvent):void
		{
			dispatchEvent(new LoadEvent(event.type, false, false, event.loadState, bytesLoaded));
		}	
		
		private var mode:CompositionMode;

	}
}