package
{
	import flash.display.MovieClip;
	
	public class ItemRepair extends MovieClip
	{
		public var types:String = "Repair";
		public var xv:Number = 0;
		public var yv:Number = 0;
		
		public function ItemRepair(xvv:Number = 0,yvv:Number = 0):void
		{
			xv = xvv;
			yv = yvv;
		}
	}
}