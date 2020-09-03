package
{
	import flash.display.MovieClip;
	
	public class ItemShrink extends MovieClip
	{
		public var types:String = "Shrink";
		public var xv:Number = 0;
		public var yv:Number = 0;
		
		public function ItemShrink(xvv:Number = 0,yvv:Number = 0):void
		{
			xv = xvv;
			yv = yvv;
		}
	}
}