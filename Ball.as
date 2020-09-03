package
{
	import flash.display.MovieClip;
	
	public class Ball extends MovieClip
	{
		public var xv:Number = 0;
		public var yv:Number = 0;
		
		public function Ball(xvv:Number = 0, yvv:Number = 0)
		{
			xv = xvv;
			yv = yvv;
		}
	}
}