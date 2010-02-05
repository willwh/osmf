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
package org.osmf.layout
{
	import __AS3__.vec.Vector;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MetadataWatcher;
	import org.osmf.utils.BinarySearch;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.utils.URL;
	
	/**
	 * Use LayoutRendererBase as the base class for custom layout renders. The class
	 * provides a number of facilities:
	 * 
	 *  * A base implementation for collecting and managing layout layoutTargets.
	 *  * A base implementation for metadata watching: override usedMetadataFacets to
	 *    return the set of metadata facet namespaces that	your renderer reads from its
	 *    target on rendering them. All specified facets will be watched for change, at
	 *    which the invalidate methods gets invoked.
	 *  * A base invalidation scheme that postpones rendering until after all other frame
	 *    scripts have finished executing, by means of managing a dirty flag an a listener
	 *    to Flash's EXIT_FRAME event. The invokation of validateNow will always result
	 *    in the 'render' method being invoked right away.
	 * 
	 * On doing a subclass, the render method must be overridden.
	 * 
	 * Optionally, the following protected methods may be overridden:
	 * 
	 *  * get usedMetadataFacets, used when layoutTargets get added or removed, to add
	 *    change watchers that will trigger invalidation of the renderer.
	 *  * compareTargets, which is used to put the layoutTargets in a particular display
	 *    list index order.
	 * 
	 *  * processContainerChange, invoked when the renderer's container changed.
	 *  * processStagedTarget, invoked when a target is put on the stage of the
	 *    container's displayObjectContainer.
	 *  * processUnstagedTarget, invoked when a target is removed from the stage
	 *    of the container's displayObjectContainer.  
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class LayoutRenderer extends EventDispatcher
	{
		// LayoutRenderer
		//
		
		/**
		 * Defines the renderer that this renderer is a child of.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		final public function get parent():LayoutRenderer
		{
			return _parent;	
		}
		final protected function setParent(value:LayoutRenderer):void
		{
			CONFIG::LOGGING { logger.debug("set {0}'s parent to {1}", metadata.getFacet(MetadataNamespaces.ELEMENT_ID), value ? value.metadata.getFacet(MetadataNamespaces.ELEMENT_ID) : "null");}
			_parent = value;
		}
		
		/**
		 * Defines the container against which the renderer will calculate the size
		 * and position values of its targets. The renderer additionally manages
		 * targets being added and removed as children of the set container's
		 * display list.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		final public function get container():ILayoutTarget
		{
			return _container;
		}
		final public function set container(value:ILayoutTarget):void
		{
			if (value != _container)
			{
				if (_container != null)
				{
					reset();
					
					if (_container.layoutRenderer == this)
					{
						_container.dispatchEvent
							( new LayoutRendererChangeEvent
								( LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE
								, false, false
								, this
								, null
								)
							);
							
						_container.addEventListener
							( DisplayObjectEvent.MEDIA_SIZE_CHANGE
							, invalidatingEventHandler
							, false, 0, true
							);
					}
				}
			
				var oldContainer:ILayoutTarget = _container;	
				_container = value;
					
				if (_container)
				{
					displayObjectContainer = _container.displayObject as DisplayObjectContainer;
					metadata = _container.metadata;
					
					_container.addEventListener
						( DisplayObjectEvent.MEDIA_SIZE_CHANGE
						, invalidatingEventHandler
						, false, 0, true
						);

					_container.dispatchEvent
						( new LayoutRendererChangeEvent
							( LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE
							, false, false
							, _container.layoutRenderer
							, this
							)
						);
						
					invalidate();
				}
				
				processContainerChange(oldContainer, value);
			}
		}
		
		/**
		 * Method for adding a target to the layout renderer's list of objects
		 * that it calculates the size and position for. Adding a target will
		 * result the associated display object to be placed on the display
		 * list of the renderer's container.
		 * 
		 * @param target The target to add.
		 * @throws IllegalOperationError when the specified target is null, or 
		 * already a target of the renderer.
		 * @returns The added target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		final public function addTarget(target:ILayoutTarget):ILayoutTarget
		{
			if (target == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (layoutTargets.indexOf(target) != -1)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			// Dispatch a parentLayoutRendererChange event on the target. This is the cue for
			// the currently owning renderer to remove the target from its listing:
			target.dispatchEvent
				( new LayoutRendererChangeEvent
					( LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE
					, false, false
					, target.parentLayoutRenderer, this
					)
				);
			
			CONFIG::LOGGING { logger.debug("Adding target {0} to {1}", target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); } 
			
			// Get the index where the target should be inserted:
			var index:int = Math.abs(BinarySearch.search(layoutTargets, compareTargets, target));
			
			// Add the target to our listing:
			layoutTargets.splice(index, 0, target);	
			
			// Parent the added layout renderer (if available):
			if (target.layoutRenderer)
			{
				target.layoutRenderer.setParent(this);
			}
			
			// Watch the facets on the target's metadata that we're interested in:
			var watchers:Array = metaDataWatchers[target] = new Array();
			for each (var namespaceURL:URL in usedMetadataFacets)
			{
				watchers.push
					( MetadataUtils.watchFacet
						( target.metadata
						, namespaceURL
						, targetMetadataChangeCallback
						)
					);
			}
			
			// Watch the target's displayObject, dimenions, and layoutRenderer change:
			target.addEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, invalidatingEventHandler);
			target.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, invalidatingEventHandler);
			target.addEventListener(LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE, onTargetChildRendererChange);
			target.addEventListener(LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE, onTargetParentRendererChange);
			
			invalidate();
			
			processTargetAdded(target);
			
			return target;
		}
		
		/**
		 * Method for removing a target from the layout render's list of objects
		 * that it will render. See addTarget for more information.
		 * 
		 * @param target The target to remove.
		 * @throws IllegalOperationErrror when the specified target is null, or
		 * not a target of the renderer.
		 * @returns The removed target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		final public function removeTarget(target:ILayoutTarget):ILayoutTarget
		{
			if (target == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			CONFIG::LOGGING { logger.debug("Removing target {0} from {1}", target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
			
			var removedTarget:ILayoutTarget;
			var index:Number = layoutTargets.indexOf(target);
			if (index != -1)
			{
				// Remove the target from the container stage:
				removeFromStage(target);
				
				// Remove the target from our listing:
				removedTarget = layoutTargets.splice(index,1)[0];
				
				// Un-parent the target if it is a layout renderer:
				if (target.layoutRenderer && target.layoutRenderer.parent == this)
				{
					target.layoutRenderer.setParent(null);
				}
				
				// Un-watch the target's displayObject and dimenions change:
				target.removeEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, invalidatingEventHandler);
				target.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, invalidatingEventHandler);
				target.removeEventListener(LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE, onTargetChildRendererChange);
				target.removeEventListener(LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE, onTargetParentRendererChange);
								
				// Remove the metadata change watchers that we added:
				for each (var watcher:MetadataWatcher in metaDataWatchers[target])
				{
					watcher.unwatch();
				}
				
				delete metaDataWatchers[target];
				
				processTargetRemoved(target);
				
				target.dispatchEvent
					( new LayoutRendererChangeEvent
						( LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE
						, false, false
						, target.parentLayoutRenderer
						, null
						)
					);
					
				invalidate();
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return removedTarget;
		}
		
		/**
		 * Method for querying if a layout target is currently a target of this
		 * layout renderer.
		 *  
		 * @return True if the specified target is a target of this renderer.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		final public function targets(target:ILayoutTarget):Boolean
		{
			return layoutTargets.indexOf(target) != -1;
		}
		
		final public function get mediaWidth():Number
		{
			return _mediaWidth;
		}
		
		final public function get mediaHeight():Number
		{
			return _mediaHeight;
		}
		
		/**
		 * Method that will mark the renderer's last rendering pass invalid. At
		 * the descretion of the implementing instance, the renderer may either
		 * directly re-render, or do so at a later time.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		final public function invalidate():void
		{
			// If we're either cleaning or dirty already, then invalidation
			// is a no-op:
			if (cleaning == false && dirty == false)
			{
				// Raise the 'dirty' flag, signalling that layout need recalculation:
				dirty = true;
				
				if (_parent != null)
				{
					// Forward further processing to our parent:
					_parent.invalidate();
				}
				else
				{
					// Since we don't have a parent, put us in the queue
					// to be recalculated when the next frame exits:
					flagDirty(this);
				}
			}
		}
		
		/**
		 * Method ordering the direct recalculation of the position and size
		 * of all of the renderer's assigned targets. The implementing class
		 * may still skip recalculation if the renderer has not been invalidated
		 * since the last rendering pass. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		final public function validateNow():void
		{
			if (_container == null || displayObjectContainer == null || cleaning == true)
			{
				// no-op:
				return;	
			}
			
			if (_parent)
			{
				// Have validation triggered from the root-node down:
				_parent.validateNow();
				return;
			}
			
			// This is a root-node. Flag that we're cleaning up:
			cleaning = true;
			
			measureMedia();
			updateMediaDisplay(_mediaWidth, _mediaHeight);
			
			cleaning = false;
		}
		
		/**
		 * @private
		 */
		protected function measureMedia():void
		{
			// Take care of all targets being staged correctly:
			prepareTargets();
			
			// Traverse, execute bottom-up:
			for each (var target:ILayoutTarget in layoutTargets)
			{
				if (target.layoutRenderer)
				{
					target.layoutRenderer.measureMedia();
				}
				
				target.measureMedia();
			}
			
			// Calculate our own size:
			var size:Point = calculateContainerSize(layoutTargets);
			
			_mediaWidth = size.x;
			_mediaHeight = size.y;
			
			_container.measureMedia();
		}
		
		/**
		 * @private
		 */
		protected function updateMediaDisplay(availableWidth:Number, availableHeight:Number):void
		{
			processUpdateMediaDisplayBegin(layoutTargets);
			
			_container.updateMediaDisplay(availableWidth, availableHeight);
			
			// Traverse, execute top-down:
			for each (var target:ILayoutTarget in layoutTargets)
			{
				var bounds:Rectangle = calculateTargetBounds(target, availableWidth, availableHeight);
				
				target.updateMediaDisplay(bounds.width, bounds.height);
				
				var displayObject:DisplayObject = target.displayObject;
				if (displayObject)
				{
					displayObject.x = bounds.x;
					displayObject.y = bounds.y;
				}
				if (target.layoutRenderer)
				{
					target.layoutRenderer.updateMediaDisplay(bounds.width, bounds.height);
				}
			}
			
			dirty = false;
			
			processUpdateMediaDisplayEnd();
		}
		
		// Subclass stubs
		//
		
		/**
		 * @private
		 * 
		 * Subclasses may override this method to have it return the list
		 * of URL namespaces that identify the metadata facets that the
		 * renderer uses on its calculations.
		 * 
		 * The base class will make sure that the renderer gets invalidated
		 * when any of the specified facets change value.
		 * 
		 * @return The list of URL namespaces that identify the metadata facets
		 * that the renderer uses on its calculations. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function get usedMetadataFacets():Vector.<URL>
		{
			return new Vector.<URL>;
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method, providing the algorithm
		 * by which the list of targets gets sorted.
		 * 
		 * @returns -1 if x comes before y, 0 if equal, and 1 if x comes
		 * after y.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function compareTargets(x:ILayoutTarget, y:ILayoutTarget):Number
		{
			// The base comparision function assumes all targets are equal:
			return 0;
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method to process the renderer's container
		 * changing.
		 * 
		 * @param oldContainer The old container.
		 * @param newContainer The new container.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processContainerChange(oldContainer:ILayoutTarget, newContainer:ILayoutTarget):void
		{	
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method to do processing on a target
		 * item being added.
		 *   
		 * @param target The target that has been added.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processTargetAdded(target:ILayoutTarget):void
		{	
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method to do processing on a target
		 * item being removed.
		 *   
		 * @param target The target that has been removed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processTargetRemoved(target:ILayoutTarget):void
		{	
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method should they require special
		 * processing on the displayObject of a target being staged.
		 *  
		 * @param target The target that is being staged
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function processStagedTarget(target:ILayoutTarget):void
		{	
			// CONFIG::LOGGING { logger.debug("staged: {0}", target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method should they require special
		 * processing on the displayObject of a target being unstaged.
		 *  
		 * @param target The target that has been unstaged
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function processUnstagedTarget(target:ILayoutTarget):void
		{	
			// CONFIG::LOGGING { logger.debug("unstaged: {0}", target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method should they require special
		 * processing on the updateMediaDisplay routine starting it execution.
		 *  
		 * @param targets The targets that are about to be measured.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function processUpdateMediaDisplayBegin(targets:Vector.<ILayoutTarget>):void
		{	
		}
		
		/**
		 * @private
		 *
		 * Subclasses may override this method should they require special
		 * processing on the updateMediaDisplay routine completing its execution.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function processUpdateMediaDisplayEnd():void
		{
		}	
		
		/**
		 * @private
		 *
		 * Subclasses should override this method to implement the algorithm by
		 * which the targets of the renderer get sorted.
		 * 
		 * @param target The element to order.
		 */		
		protected function updateTargetOrder(target:ILayoutTarget):void
		{
			var index:int = layoutTargets.indexOf(target);
			if (index != -1)
			{
				layoutTargets.splice(index, 1);
				
				index = Math.abs(BinarySearch.search(layoutTargets, compareTargets, target));
				layoutTargets.splice(index, 0, target);
			}
		}
		
		/**
		 * @private
		 *
		 * Subclasses should override this method to implement the algorithm by which
		 * the position and size of a target gets calculated.
		 * 
		 * @param target The target to calculate the bounds for.
		 * @param availableWidth The width available to the target.
		 * @param availableHeight The height available to the target.
		 * @return The calculated bounds for the specified target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		protected function calculateTargetBounds(target:ILayoutTarget, availableWidth:Number, availableHeight:Number):Rectangle
		{
			return new Rectangle();
		}
		
		/**
		 * @private
		 *
		 * Subclasses should override this method to implement the algorithm by which
		 * the size of the renderer's container is calculated:
		 * 
		 * @return The calculated size of the renderer's container.
		 */		
		protected function calculateContainerSize(targets:Vector.<ILayoutTarget>):Point
		{
			return new Point();
		}
		
		// Internals
		//
		
		private function reset():void
		{
			for each (var target:ILayoutTarget in layoutTargets)
			{
				removeTarget(target);
			}
			
			if (_container)
			{
				_container.removeEventListener
					( DisplayObjectEvent.MEDIA_SIZE_CHANGE
					, invalidatingEventHandler
					);
						
				// Make sure to update the existing container
				// before we loose it:
				validateNow();
			}
			
			_container = null;
			this.displayObjectContainer = null;
			this.metadata = null;
		}
		
		private function targetMetadataChangeCallback(facet:Facet):void
		{
			invalidate();
		}
		
		private function invalidatingEventHandler(event:Event):void
		{
			/*
			CONFIG::LOGGING 
			{
				var targetMetadata:Metadata
					= event.target is ILayoutTarget
						? ILayoutTarget(event.target).metadata
						: null;
						
				logger.debug
					( "invalidated: {0} eventType: {1}, target: {2} sender ID: {3}"
					, metadata.getFacet(MetadataNamespaces.ELEMENT_ID)
					, event.type, event.target
					, targetMetadata ? targetMetadata.getFacet(MetadataNamespaces.ELEMENT_ID) : "?" 
					); 
			}
			*/
			invalidate();
		}
		
		private function onTargetChildRendererChange(event:LayoutRendererChangeEvent = null):void
		{
			var target:ILayoutTarget = event ? event.target as ILayoutTarget : null;
			if (target && target.layoutRenderer)
			{
				target.layoutRenderer.setParent(this);
			}
		}
		
		private function onTargetParentRendererChange(event:LayoutRendererChangeEvent = null):void
		{
			CONFIG::LOGGING { logger.debug("onTargetParentRendererChange: {0}, {1}", event.oldValue == this, event.newValue != this); }
			if (event.oldValue == this && event.newValue != this)
			{
				removeTarget(event.target as ILayoutTarget);
			}
		}
		
		private function prepareTargets():void
		{
			// Setup a displayObject counter:
			var displayListCounter:int = 0;
			
			for each (var target:ILayoutTarget in layoutTargets)
			{
				var displayObject:DisplayObject = target.displayObject;
				if (displayObject)
				{
					addToStage(target, target.displayObject, displayListCounter);
					displayListCounter++;
				}
				else
				{
					removeFromStage(target);
				}
			}
		}
		
		private function addToStage(target:ILayoutTarget, object:DisplayObject, index:Number):void
		{
			var currentObject:DisplayObject = stagedDisplayObjects[target];
			if (currentObject == object)
			{
				// Make sure that the object is at the right position in the display list:
				displayObjectContainer.setChildIndex(object, Math.min(Math.max(0,displayObjectContainer.numChildren-1), index));
				CONFIG::LOGGING { logger.debug("[.] setChildIndex, {0} on {1}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
			}
			else
			{
				if (currentObject != null)
				{
					// Remove the current object:
					displayObjectContainer.removeChild(currentObject);
					CONFIG::LOGGING { logger.debug("[-] removeChild, {0} from {1}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
				}
				
				// Add the new object:
				displayObjectContainer.addChildAt(object, index);
				stagedDisplayObjects[target] = object;
				CONFIG::LOGGING { logger.debug("[+] addChild, {0} to {1}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
				
				// If there wasn't an old object, then trigger the staging processor:
				if (currentObject == null)
				{
					processStagedTarget(target);
				}
			}
		}
		
		private function removeFromStage(target:ILayoutTarget):void
		{
			var currentObject:DisplayObject = stagedDisplayObjects[target];
			if (currentObject != null)
			{
				delete stagedDisplayObjects[target];
				displayObjectContainer.removeChild(currentObject);
				
				CONFIG::LOGGING { logger.debug("[-] removeChild, {0}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
			}
		}
		
		private var _parent:LayoutRenderer;
		private var _container:ILayoutTarget;		
		private var displayObjectContainer:DisplayObjectContainer;
		private var metadata:Metadata;
		
		private var layoutTargets:Vector.<ILayoutTarget> = new Vector.<ILayoutTarget>;
		private var stagedDisplayObjects:Dictionary = new Dictionary(true);
		
		private var _mediaWidth:Number;
		private var _mediaHeight:Number;
		
		private var dirty:Boolean;
		private var cleaning:Boolean;
		
		private var metaDataWatchers:Dictionary = new Dictionary();
		
		// Private Static
		//
		
		private static function flagDirty(renderer:LayoutRenderer):void
		{
			if (renderer == null || dirtyRenderers.indexOf(renderer) != -1)
			{
				// no-op;
				return;
			}
			
			dirtyRenderers.push(renderer);
			
			if (cleaningRenderers == false)
			{
				dispatcher.addEventListener(Event.EXIT_FRAME, onExitFrame);
			}
		}
		
		private static function flagClean(renderer:LayoutRenderer):void
		{
			var index:Number = dirtyRenderers.indexOf(renderer);
			if (index != -1)
			{
				dirtyRenderers.splice(index,1);
			}
		}
		
		private static function onExitFrame(event:Event):void
		{
			dispatcher.removeEventListener(Event.EXIT_FRAME, onExitFrame);
			
			cleaningRenderers = true;
			
			CONFIG::LOGGING { logger.debug("------------ ON EXIT FRAME ------------"); }
			
			while (dirtyRenderers.length != 0)
			{
				var renderer:LayoutRenderer = dirtyRenderers.shift();
				if (renderer.parent == null)
				{
					CONFIG::LOGGING { logger.debug("---------- VALIDATING LAYOUT ---------- {0}", renderer.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
					renderer.validateNow();
					CONFIG::LOGGING { logger.debug("---------- LAYOUT VALIDATED -----------"); }
				}
				else
				{
					renderer.dirty = false;
				}
			}
			CONFIG::LOGGING { logger.debug("--------------------------------------"); }
			
			cleaningRenderers = false;
		}
		
		private static var dispatcher:DisplayObject = new Sprite();
		private static var cleaningRenderers:Boolean;
		private static var dirtyRenderers:Vector.<LayoutRenderer> = new Vector.<LayoutRenderer>;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("LayoutRenderer");
	}
}