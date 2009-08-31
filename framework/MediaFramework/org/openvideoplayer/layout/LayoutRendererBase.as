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
package org.openvideoplayer.layout
{
	import __AS3__.vec.Vector;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.Metadata;
	import org.openvideoplayer.metadata.MetadataUtils;
	import org.openvideoplayer.metadata.MetadataWatcher;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	
	/**
	 * Use LayoutRendererBase as the base class for custom layout renders. The class
	 * provides a number of facilities:
	 * 
	 *  * A base implementation for collecting and managing layout targets.
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
	 *  * get usedMetadataFacets, used when targets get added or removed, to add
	 *    change watchers that will trigger invalidation of the renderer.
	 *  * compareTargets, which is used to put the targets in a particular display
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
		
		/**
		 * @inheritDoc
		 */
		final public function addTarget(target:ILayoutTarget):void
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (targets.indexOf(target) == -1)
			{
				// Add the target to our listing:
				targets.push(target);	
				
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
			}
		}
		
		/**
		 * @inheritDoc
		 */
		final public function removeTarget(target:ILayoutTarget):void
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var index:Number = targets.indexOf(target);
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
				var target:ILayoutTarget = targets.splice(index,1)[0];
				
				// Un-watch the target's view and dimenions change:
				target.removeEventListener(ViewChangeEvent.VIEW_CHANGE, invalidatingEventHandler);
				target.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, invalidatingEventHandler);
								
				// Remove the metadata change watchers that we added:
				for each (var watcher:MetadataWatcher in metaDataWatchers[target])
				{
					watcher.unwatch();
				}
				
				delete metaDataWatchers[target];
				
				invalidate();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		final public function invalidate():void
		{
			if (dirty == false)
			{
				dirty = true;
				container.addEventListener(Event.EXIT_FRAME, onExitFrame);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		final public function validateNow():void
		{
			if (dirty == true)
			{
				preRender();
			}
		}
		
		// Subclass stubs
		//
		
		/**
		 * Subclasses <b>must</b> override this method, providing the algorithm
		 * by which the targets of the renderer get layed out.
		 * 
		 * @throws IllegalOperationError If not overridden.
		 */
		protected function render(targets:Vector.<ILayoutTarget>):void
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);
		}
		
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
		protected function processContextChange(oldContext:ILayoutContext, newContext:ILayoutContext):void
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
		}
		
		/**
		 * Subclasses may override this method should they require special
		 * processing on the view of a target being unstaged.
		 *  
		 * @param target The target that has been unstaged
		 */
		protected function processUnstagedTarget(target:ILayoutTarget):void
		{	
		}
		
		// Internals
		//
		
		private function reset():void
		{
			for each (var target:ILayoutTarget in targets)
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
		
		private function onExitFrame(event:Event):void
		{
			preRender();
		}
		
		private function targetMetadataChangeCallback(facet:IFacet):void
		{
			invalidate();
		}
		
		private function invalidatingEventHandler(event:Event):void
		{
			invalidate();
		}
		
		private function preRender():void
		{
			if (_context == null || container == null)
			{
				// no-op:
				return;	
			}
			
			container.removeEventListener(Event.EXIT_FRAME, onExitFrame);
			
			// Make sure that our children are in their correct order:
			targets.sort(compareTargets);
		
			// Setup a view counter:
			var displayListCounter:int = _context.firstChildIndex;
			
			for each (var target:ILayoutTarget in targets)
			{
				var view:DisplayObject = target.view;
				if (view)
				{
					// If the target's view is not on our container, then place it. If
					// it is already present, then make sure it is at the right index
					// of the display list:
					if (container.contains(view))
					{
						container.setChildIndex
							( view
							// Make sure that the display index that we pass, is within
							// bounds:
							, Math.min(Math.max(0,container.numChildren-1),displayListCounter)
							);
					}
					else
					{
						container.addChildAt
							( view
							// Make sure that the display index that we pass, is within
							// bounds:
							, Math.min(Math.max(0,container.numChildren),displayListCounter)
							);
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
				}
			}
		
			// Invoke subclass render function:
			render(targets);
			
			// We're no longer dirty:
			dirty = false;
		}
		
		private var _context:ILayoutContext;		
		private var container:DisplayObjectContainer;
		private var metadata:Metadata;
		
		private var targets:Vector.<ILayoutTarget> = new Vector.<ILayoutTarget>;
		private var staged:Dictionary = new Dictionary(true);
		
		private var dirty:Boolean;
		private var metaDataWatchers:Dictionary = new Dictionary();
	}
}