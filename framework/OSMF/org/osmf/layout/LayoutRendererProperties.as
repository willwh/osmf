/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.layout
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.metadata.IMetadataProvider;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.utils.OSMFStrings;
	
	public class LayoutRendererProperties
	{
		public function LayoutRendererProperties(target:IMetadataProvider)
		{
			if (target == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			metadata = target.metadata;
		}
		
		// LayoutAttributes
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired position of the target in the display list
		 * of its context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get order():Number
		{
			return lazyAttributes ? lazyAttributes.order : NaN;
		}
		public function set order(value:Number):void
		{
			eagerAttributes.order = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired scale mode to be applied to the target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get scaleMode():String
		{
			return lazyAttributes ? lazyAttributes.scaleMode : null;
		}
		public function set scaleMode(value:String):void
		{
			eagerAttributes.scaleMode = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired horizontal alignment mode to be applied to the
		 * target when layout of the target leaves surplus horizontal blank
		 * space.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get horizontalAlignment():String
		{
			return lazyAttributes ? lazyAttributes.horizontalAlignment : null;
		}
		public function set horizontalAlignment(value:String):void
		{
			eagerAttributes.horizontalAlignment = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired vertical alignment mode to be applied to the
		 * target when layout of the target leaves surplus vertical blank
		 * space.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get verticalAlignment():String
		{
			return lazyAttributes ? lazyAttributes.verticalAlignment : null;
		}
		public function set verticalAlignment(value:String):void
		{
			eagerAttributes.verticalAlignment = value;
		}

		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * If set to true, the target's calculated position and size will
		 * be rounded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get snapToPixel():Boolean
		{
			return lazyAttributes ? lazyAttributes.snapToPixel : true;
		}
		public function set snapToPixel(value:Boolean):void
		{
			eagerAttributes.snapToPixel = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * If set to null or DefaultRendererMode.CANVAS, the renderer will operate in
		 * canvase mode. When set to DefaultRendererMode.HBOX or DefaultRendererMode.VBOX,
		 * then the renderer will ignore its targets positioning settings (either
		 * influencing X or Y, depending on the mode chosen), laying out its elements
		 * adjecent in the order specified by the 'order' property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get mode():String
		{
			return lazyAttributes ? lazyAttributes.mode : LayoutMode.NONE;
		}
		public function set mode(value:String):void
		{
			eagerAttributes.mode = value;
		}

		// AbsoluteLayoutFacet
		//

		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired horizontal offset of a target expressed in
		 * pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get x():Number
		{
			return lazyAbsolute ? lazyAbsolute.x : NaN;		
		}
		public function set x(value:Number):void
		{
			eagerAbsolute.x = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired vertical offset of a target expressed in
		 * pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get y():Number
		{
			return lazyAbsolute ? lazyAbsolute.y : NaN;		
		}
		public function set y(value:Number):void
		{
			eagerAbsolute.y = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired horizontal size of a target expressed in
		 * pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get width():Number
		{
			return lazyAbsolute ? lazyAbsolute.width : NaN;
		}
		public function set width(value:Number):void
		{
			eagerAbsolute.width = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired vertical offset of a target expressed in
		 * pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get height():Number
		{
			return lazyAbsolute ? lazyAbsolute.height : NaN;
		}
		public function set height(value:Number):void
		{
			eagerAbsolute.height = value;
		}
		
		// RelativeLayoutFacet
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired horizontal offset of a target expressed as
		 * a percentage of its context's width.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get percentX():Number
		{
			return lazyRelative ? lazyRelative.x : NaN;		
		}
		public function set percentX(value:Number):void
		{
			eagerRelative.x = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired vertical offset of a target expressed as
		 * a percentage of its context's height.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get percentY():Number
		{
			return lazyRelative ? lazyRelative.y : NaN;		
		}
		public function set percentY(value:Number):void
		{
			eagerRelative.y = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired width of a target expressed as
		 * a percentage of its context's width.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get percentWidth():Number
		{
			return lazyRelative ? lazyRelative.width : NaN;
		}
		public function set percentWidth(value:Number):void
		{
			eagerRelative.width = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired height of a target expressed as
		 * a percentage of its context's height.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get percentHeight():Number
		{
			return lazyRelative ? lazyRelative.height : NaN;
		}
		public function set percentHeight(value:Number):void
		{
			eagerRelative.height = value;
		}
		
		// AnchorLayoutFacet
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired horizontal offset of the target in pixels. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get left():Number
		{
			return lazyAnchor ? lazyAnchor.left : NaN;		
		}
		public function set left(value:Number):void
		{
			eagerAnchor.left = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the desired vertical offset of the target in pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function get top():Number
		{
			return lazyAnchor ? lazyAnchor.top : NaN;		
		}
		public function set top(value:Number):void
		{
			eagerAnchor.top = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines how many pixels should be present between the right-hand 
		 * side border of the target's bounding box, and the right-hand side
		 * border of its context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function get right():Number
		{
			return lazyAnchor ? lazyAnchor.right : NaN;
		}
		public function set right(value:Number):void
		{
			eagerAnchor.right = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines how many pixels should be present between the bottom
		 * side border of the target's bounding box, and the bottom side
		 * border of its context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get bottom():Number
		{
			return lazyAnchor ? lazyAnchor.bottom : NaN;
		}
		public function set bottom(value:Number):void
		{
			eagerAnchor.bottom = value;
		}
		
		// PaddingLayoutFacet
		//
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's left-hand side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get paddingLeft():Number
		{
			return lazyPadding ? lazyPadding.left : NaN;		
		}
		public function set paddingLeft(value:Number):void
		{
			eagerPadding.left = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's top side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get paddingTop():Number
		{
			return lazyPadding ? lazyPadding.top : NaN;		
		}
		public function set paddingTop(value:Number):void
		{
			eagerPadding.top = value
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's right-hand side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get paddingRight():Number
		{
			return lazyPadding ? lazyPadding.right : NaN;
		}
		public function set paddingRight(value:Number):void
		{
			eagerPadding.right = value;
		}
		
		/**
		 * The default layout renderer interprets this value as follows:
		 * 
		 * Defines the thickness of the blank space that is to be placed
		 * at the target's bottom side.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get paddingBottom():Number
		{
			return lazyPadding ? lazyPadding.bottom : NaN;
		}
		public function set paddingBottom(value:Number):void
		{
			eagerPadding.bottom = value;
		}
		
		/**
		 * @inherit
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function toString():String
		{
			return "mode: " + mode + " "
				 + "abs ["
				 + x + ", "
				 + y + ", "
				 + width + ", "
				 + height + "] "
				 + "rel ["
				 + percentX + ", "
				 + percentY + ", "
				 + percentWidth + ", "
				 + percentHeight + "] "
				 + "anch ("
				 + left + ", "
				 + top + ")("
				 + right + ", "
				 + bottom + ") "
				 + "pad [" 
				 + paddingLeft + ", "
				 + paddingTop + ", "
				 + paddingRight + ", "
				 + paddingBottom + "] "
				 + "order: " + order + " "
				 + "scale: " + scaleMode + " "
				 + "valign: " + verticalAlignment + " "
				 + "halign: " + horizontalAlignment + " "
				 + "snap: " + snapToPixel;
		}
		
		
		// Internals
		//
		
		private var metadata:Metadata;
		
		private function get lazyAttributes():LayoutAttributesFacet
		{
			return metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesFacet;
		}
		
		private function get eagerAttributes():LayoutAttributesFacet
		{
			var result:LayoutAttributesFacet = lazyAttributes;
			if (result == null)
			{
				result = new LayoutAttributesFacet();
				metadata.addFacet(result);
			}
			return result;
		}
		
		private function get lazyAbsolute():AbsoluteLayoutFacet
		{
			return metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS) as AbsoluteLayoutFacet;
		}
		
		private function get eagerAbsolute():AbsoluteLayoutFacet
		{
			var result:AbsoluteLayoutFacet = lazyAbsolute;
			if (result == null)
			{
				result = new AbsoluteLayoutFacet();
				metadata.addFacet(result);
			}
			return result;
		}
		
		private function get lazyRelative():RelativeLayoutFacet
		{
			return metadata.getFacet(MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS) as RelativeLayoutFacet;
		}
		
		private function get eagerRelative():RelativeLayoutFacet
		{
			var result:RelativeLayoutFacet = lazyRelative;
			if (result == null)
			{
				result = new RelativeLayoutFacet();
				metadata.addFacet(result);
			}
			return result;
		}
		
		private function get lazyAnchor():AnchorLayoutFacet
		{
			return metadata.getFacet(MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS) as AnchorLayoutFacet;
		}
		
		private function get eagerAnchor():AnchorLayoutFacet
		{
			var result:AnchorLayoutFacet = lazyAnchor;
			if (result == null)
			{
				result = new AnchorLayoutFacet();
				metadata.addFacet(result);
			}
			return result;
		}
		
		private function get lazyPadding():PaddingLayoutFacet
		{
			return metadata.getFacet(MetadataNamespaces.PADDING_LAYOUT_PARAMETERS) as PaddingLayoutFacet;
		}
		
		private function get eagerPadding():PaddingLayoutFacet
		{
			var result:PaddingLayoutFacet = lazyPadding;
			if (result == null)
			{
				result = new PaddingLayoutFacet();
				metadata.addFacet(result);
			}
			return result;
		}
	}
}