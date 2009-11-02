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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.events.ViewChangeEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MetadataWatcher;
	import org.osmf.utils.BinarySearch;
	import org.osmf.utils.MediaFrameworkStrings;
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
	 *  * processContextChange, invoked when the renderer's context changed.
	 *  * processStagedTarget, invoked when a target is put on the stage of the
	 *    context's container.
	 *  * processUnstagedTarget, invoked when a target is removed from the stage
	 *    of the context's container.  
	 * 
	 */	
	public class LayoutRendererBase extends EventDispatcher implements ILayoutRenderer
	{
		// ILayoutRenderer
		//
		
		final public function set parent(value:ILayoutRenderer):void
		{
			_parent = value;
		}
		
		final public function get parent():ILayoutRenderer
		{
			return _parent;	
		}
		
		/**
		 * @inheritDoc
		 */
		final public function set context(value:ILayoutContext):void
		{
			if (value != _context)
			{
				if (_context != null)
				{
					reset();
				}
			
				var oldContext:ILayoutContext = _context;	
				_context = value;
				
				if (_context)
				{
					container = _context.container;
					metadata = _context.metadata;
					
					absoluteLayoutWatcher
						= MetadataUtils.watchFacet
							( metadata
							, MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS
							, absoluteLayoutChangeCallback
							);
					
					_context.addEventListener
						( DimensionChangeEvent.DIMENSION_CHANGE
						, invalidatingEventHandler
						, false, 0, true
						);
						
					invalidate();
				}
				
				processContextChange(oldContext, value);
			}
		}
		
		final public function get context():ILayoutContext
		{
			return _context;
		}
		
		/**
		 * @inheritDoc
		 */
		final public function addTarget(target:ILayoutTarget):ILayoutTarget
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (layoutTargets.indexOf(target) != -1)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			// Get the index where the target should be inserted:
			var index:int = Math.abs(BinarySearch.search(layoutTargets, compareTargets, target));
			
			// Add the target to our listing:
			layoutTargets.splice(index, 0, target);	
			
			// Parent the added layout renderer (if available):
			var targetContext:ILayoutContext = target as ILayoutContext;
			if (targetContext && targetContext.layoutRenderer)
			{
				targetContext.layoutRenderer.parent = this;
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
			
			// Watch the target's view and dimenions change:
			target.addEventListener(ViewChangeEvent.VIEW_CHANGE, invalidatingEventHandler);
			target.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, invalidatingEventHandler);
			
			invalidate();
			
			processTargetAdded(target);
			
			return target;
		}
		
		/**
		 * @inheritDoc
		 */
		final public function removeTarget(target:ILayoutTarget):ILayoutTarget
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var removedTarget:ILayoutTarget;
			var index:Number = layoutTargets.indexOf(target);
			if (index != -1)
			{
				// Remove the target from the context stage:
				var targetView:DisplayObject = staged[target]; 
				if (targetView != null)
				{
					if (container.contains(targetView))
					{
						container.removeChild(targetView);
					}
					
					delete staged[target];
				}
				
				// Remove the target from our listing:
				removedTarget = layoutTargets.splice(index,1)[0];
				
				// Un-parent the target if it is a layout renderer:
				var targetContext:ILayoutContext = target as ILayoutContext;
				if (targetContext && targetContext.layoutRenderer)
				{
					targetContext.layoutRenderer.parent = null;
				}
				
				// Un-watch the target's view and dimenions change:
				target.removeEventListener(ViewChangeEvent.VIEW_CHANGE, invalidatingEventHandler);
				target.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, invalidatingEventHandler);
								
				// Remove the metadata change watchers that we added:
				for each (var watcher:MetadataWatcher in metaDataWatchers[target])
				{
					watcher.unwatch();
				}
				
				delete metaDataWatchers[target];
				
				processTargetRemoved(target);
				
				invalidate();
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			return removedTarget;
		}
		
		/**
		 * @inheritDoc
		 */
		final public function targets(target:ILayoutTarget):Boolean
		{
			return layoutTargets.indexOf(target) != -1;
		}
		
		/**
		 * @inheritDoc
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
					flagDirty(this, _context.container);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		final public function validateNow():void
		{
			if (_context == null || container == null || cleaning == true)
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
			
			updateCalculatedBounds();
			updateLayout();
			
			cleaning = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateCalculatedBounds():Rectangle
		{
			var bounds:Rectangle = calculateTargetBounds(_context);
			var counter:int = 0;
			
			var targetContext:ILayoutContext
			var targetRenderer:ILayoutRenderer;
			var targetBounds:Rectangle;
			var unifiedTargetBounds:Rectangle;
			
			// Traverse, execute bottom-up:
			for each (var target:ILayoutTarget in layoutTargets)
			{
				targetContext = target as ILayoutContext;
				targetRenderer = null;
				targetBounds = null;
				
				if (targetContext != null)
				{
					// Reset the last calculations:
					targetContext.calculatedWidth = NaN;
					targetContext.calculatedHeight = NaN;
					targetContext.projectedWidth = NaN;
					targetContext.projectedHeight = NaN;
					
					targetRenderer = targetContext.layoutRenderer;
				}
						
				if (targetRenderer != null) 
				{
					// Process another node (going in, top to bottom):
					targetBounds = targetRenderer.updateCalculatedBounds();
					flagClean(targetRenderer as LayoutRendererBase);
				}
				else
				{
					// This is a leaf:
					targetBounds = calculateTargetBounds(target);
				}
				
				if (targetBounds != null)
				{
					if (targetContext)
					{
						targetContext.calculatedWidth = targetBounds.width;
						targetContext.calculatedHeight = targetBounds.height;
					}
					
					// Set X and Y to zero: if they're NaN, then the union with the
					// previously calculated bounds fails:
					targetBounds.x ||= 0;
					targetBounds.y ||= 0;
				
					unifiedTargetBounds
						= unifiedTargetBounds
							? unifiedTargetBounds.union(targetBounds)
							: targetBounds;
				}
			}
			
			_context.calculatedWidth
				= (bounds && bounds.width)
					? bounds.width
					: unifiedTargetBounds
						? unifiedTargetBounds.width
						: NaN;
						
			_context.calculatedHeight
				= (bounds && bounds.height)
					? bounds.height
					: unifiedTargetBounds
						? unifiedTargetBounds.height
						: NaN;
			
			bounds 
				= (_context.calculatedWidth || _context.calculatedHeight)
					? new Rectangle(0, 0, _context.calculatedWidth, _context.calculatedHeight) 
					: null;
					
			return bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateLayout():void
		{
			// Take care of all targets being staged correctly:
			prepareTargets();
			
			// Traverse, execute top-down:
			for each (var target:ILayoutTarget in layoutTargets)
			{
				var targetContext:ILayoutContext = target as ILayoutContext;
				var targetRenderer:ILayoutRenderer = targetContext ? targetContext.layoutRenderer : null;
				var targetBounds:Rectangle 
					= applyTargetLayout
						( target
						, _context.projectedWidth || _context.calculatedWidth
						, _context.projectedHeight || _context.calculatedHeight
						);
				
				if (targetContext)
				{
					targetContext.projectedWidth = targetBounds.width;
					targetContext.projectedHeight = targetBounds.height;
				}
				
				if (targetRenderer)
				{
					targetRenderer.updateLayout();
				}
			}
			
			_context.updateIntrinsicDimensions();
			
			dirty = false;
		}
		
		// Subclass stubs
		//
		
		/**
		 * Subclasses may override this method to have it return the list
		 * of URL namespaces that identify the metadata facets that the
		 * renderer uses on its calculations.
		 * 
		 * The base class will make sure that the renderer gets invalidated
		 * when any of the specified facets change value.
		 * 
		 * @return The list of URL namespaces that identify the metadata facets
		 * that the renderer uses on its calculations. 
		 */		
		protected function get usedMetadataFacets():Vector.<URL>
		{
			return new Vector.<URL>;
		}
		
		/**
		 * Subclasses may override this method, providing the algorithm
		 * by which the list of targets gets sorted.
		 * 
		 * @returns -1 if x comes before y, 0 if equal, and 1 if x comes
		 * after y.
		 */
		protected function compareTargets(x:ILayoutTarget, y:ILayoutTarget):Number
		{
			// The base comparision function assumes all targets are equal:
			return 0;
		}
		
		/**
		 * Subclasses may override this method to process the renderer's context
		 * changing.
		 * 
		 * @param oldContext The old context.
		 * @param newContext The new context.
		 * 
		 */		
		protected function processContextChange(oldContext:ILayoutTarget, newContext:ILayoutTarget):void
		{	
		}
		
		/**
		 * Subclasses may override this method to do processing on a target
		 * item being added.
		 *   
		 * @param target The target that has been added.
		 */		
		protected function processTargetAdded(target:ILayoutTarget):void
		{	
		}
		
		/**
		 * Subclasses may override this method to do processing on a target
		 * item being removed.
		 *   
		 * @param target The target that has been removed.
		 */		
		protected function processTargetRemoved(target:ILayoutTarget):void
		{	
		}
		
		/**
		 * Subclasses may override this method should they require special
		 * processing on the view of a target being staged.
		 *  
		 * @param target The target that is being staged
		 */		
		protected function processStagedTarget(target:ILayoutTarget):void
		{	
			CONFIG::LOGGING { logger.debug("staged: {0}", target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
		}
		
		/**
		 * Subclasses may override this method should they require special
		 * processing on the view of a target being unstaged.
		 *  
		 * @param target The target that has been unstaged
		 */
		protected function processUnstagedTarget(target:ILayoutTarget):void
		{	
			CONFIG::LOGGING { logger.debug("unstaged: {0}", target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
		}
		
		protected function calculateTargetBounds(target:ILayoutTarget):Rectangle
		{
			return target.view.getBounds(target.view);
		}
		
		protected function applyTargetLayout(target:ILayoutTarget, availableWidth:Number, availableHeight:Number):Rectangle
		{
			var view:DisplayObject;
			
			return new Rectangle(0, 0, target.intrinsicWidth, target.intrinsicHeight);
		}
		
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
		
		// Internals
		//
		
		private function reset():void
		{
			if (absoluteLayoutWatcher)
			{
				absoluteLayoutWatcher.unwatch();
				absoluteLayoutWatcher = null;
			}
			
			for each (var target:ILayoutTarget in layoutTargets)
			{
				removeTarget(target);
			}
			
			if (_context)
			{
				_context.removeEventListener
					( DimensionChangeEvent.DIMENSION_CHANGE
					, invalidatingEventHandler
					);
						
				// Make sure to update the existing context
				// before we loose it:
				validateNow();
			}
			
			_context = null;
			this.container = null;
			this.metadata = null;
		}
		
		private function targetMetadataChangeCallback(facet:IFacet):void
		{
			invalidate();
		}
		
		private function invalidatingEventHandler(event:Event):void
		{
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
			invalidate();
		}
		
		private function absoluteLayoutChangeCallback(absoluteLayout:AbsoluteLayoutFacet):void
		{
			if (_parent == null && absoluteLayout != null)
			{
				_context.projectedWidth = absoluteLayout.width;
				_context.projectedHeight = absoluteLayout.height;
				
				_context.container.width = absoluteLayout.width;
				_context.container.height = absoluteLayout.height;
				
				invalidate();
			}
		}
		
		private function prepareTargets():void
		{
			// Setup a view counter:
			var displayListCounter:int = _context.firstChildIndex;
			
			for each (var target:ILayoutTarget in layoutTargets)
			{
				var view:DisplayObject = target.view;
				if (view)
				{
					// If the target's view is not on our container, then stage it. If
					// it is already present, then make sure it is at the right index
					// of the display list:
					if (container.contains(view))
					{
						container.setChildIndex
							( view
							// Make sure that the display index that we pass, is within
							// dimensions:
							, Math.min(Math.max(0,container.numChildren-1),displayListCounter)
							);
							
						CONFIG::LOGGING { logger.debug("prepareTarget: setChildIndex, {0}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
					}
					else
					{
						container.addChildAt
							( view
							// Make sure that the display index that we pass, is within
							// dimensions:
							, Math.min(Math.max(0,container.numChildren),displayListCounter)
							);
						
						CONFIG::LOGGING { logger.debug("addChildAt: setChildIndex, {0}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
					}
					
					// Only invoke 'processStagedTarget' if the view
					// is not on our list of staged items yet:
					if (staged[target] == undefined)
					{
						staged[target] = view;
						
						processStagedTarget(target);
					}
					else
					{
						staged[target] = view;
						
						CONFIG::LOGGING { logger.debug("prepareTarget:updated staged view, {0}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
					}
					
					displayListCounter++;
				}
				else if (view == null)
				{
					// If this target does not (currently) have a view, then check if
					// we have a view for it that is still on stage. If so, then 
					// remove it:
					var oldView:DisplayObject = staged[target];
					if (oldView)
					{
						if (container.contains(oldView))
						{
							container.removeChild(oldView);
						}
						
						delete staged[target];
						
						processUnstagedTarget(target);
					}
					else
					{
						CONFIG::LOGGING { logger.debug("prepareTarget: no view for, {0}",target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
					}
				}
			}
		}
		
		private var _parent:ILayoutRenderer;
		private var _context:ILayoutContext;		
		private var container:DisplayObjectContainer;
		private var metadata:Metadata;
		private var absoluteLayoutWatcher:MetadataWatcher;
		
		private var layoutTargets:Vector.<ILayoutTarget> = new Vector.<ILayoutTarget>;
		private var staged:Dictionary = new Dictionary(true);
		
		private var dirty:Boolean;
		private var cleaning:Boolean;
		
		private var metaDataWatchers:Dictionary = new Dictionary();
		
		// Private Static
		//
		
		private static function flagDirty(renderer:LayoutRendererBase, displayObject:DisplayObject):void
		{
			if (renderer == null || dirtyRenderers.indexOf(renderer) != -1)
			{
				// no-op;
				return;
			}
			
			if (displayObject == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			dirtyRenderers.push(renderer);
			
			if	(	cleaningRenderers == false
				&&	dispatcher == null
				)
			{
				dispatcher = displayObject;
				dispatcher.addEventListener(Event.EXIT_FRAME, onExitFrame);
			}
		}
		
		private static function flagClean(renderer:LayoutRendererBase):void
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
			dispatcher = null;
			
			cleaningRenderers = true;
			
			while (dirtyRenderers.length != 0)
			{
				var renderer:LayoutRendererBase = dirtyRenderers.shift();
				if 	(	renderer.parent == null
					||	dirtyRenderers.indexOf(renderer.parent) == -1
					)
				{
					renderer.validateNow();
				}
			}
			
			cleaningRenderers = false;
		}
		
		private static var dispatcher:DisplayObject;
		private static var cleaningRenderers:Boolean;
		private static var dirtyRenderers:Vector.<LayoutRendererBase> = new Vector.<LayoutRendererBase>;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("LayoutRendererBase");
	}
}