package org.osmf.utils
{
	import __AS3__.vec.Vector;
	
	public class BinarySearch
	{
		/**
		 * Method for searching an item in a sorted list.
		 *  
		 * @param list The vector to search.
		 * @param compare The method used to compare item with items in collection:
		 * function(item:*, listItem:*):int. Expected to return:
		 * -1 when item < listItem,
		 * 0 when item == listItem, and
		 * 1 when item > listItem.
		 * @param item The item to search for.
		 * @param firstIndex The left hand-side bound to limit the search to.
		 * @param lastIndex The right hand-side bound to limit the search to.
		 * @return The index of the item searched for. If no match is found, returns
		 * the index (1 based) where the item should be inserted as a negative number.
		 * @throws ArgumentError
		 * 
		 */		
		public static function search(list:Object, compare:Function, item: *, firstIndex:int = 0, lastIndex:int = int.MIN_VALUE):int
		{
			if 	(	list == null
				||	compare == null
				)
			{
				throw new ArgumentError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var result:int = -firstIndex;
			
			lastIndex 
				= lastIndex == int.MIN_VALUE
					? list.length - 1
					: lastIndex;
			
			if	(	list.length > 0
				&&	firstIndex <= lastIndex
				)
			{
				var middle:int = (firstIndex + lastIndex) / 2;
				var listItem:* = list[middle];
				
				switch (compare(item, listItem))
				{
					case -1	:
						result = search(list, compare, item, firstIndex, middle - 1);
						break;
					case 0	:
						result = middle;
						break;
					case 1	:
						result = search(list, compare, item, middle + 1, lastIndex);
						break;
				}
			}
			
			return result;
		}
		
	}
}