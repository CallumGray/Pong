package
{
	import flash.display.MovieClip;
	
	public class ItemPathChanger extends MovieClip
	{
		public var types:String = "PathChanger";
		public var xv:Number = 0;
		public var yv:Number = 0;
		
		public function ItemPathChanger(xvv:Number = 0,yvv:Number = 0):void
		{
			xv = xvv;
			yv = yvv;
		}
	}
}