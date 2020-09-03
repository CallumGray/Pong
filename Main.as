package
{
        //Libraries
               
                //Display Objects
                import flash.display.MovieClip;
               
                //Events
                import flash.events.Event;
                import flash.events.KeyboardEvent;
                import flash.events.TimerEvent;
               
                //Timers
                import flash.utils.Timer;
               
                //UI
                import flash.ui.Keyboard;
       
        public class Main extends MovieClip
        {
                //Barriers
                public var barrierOne:BarrierOne;
                public var barrierTwo:BarrierTwo;
               
                //Bat and Balls
                public var ball:Ball;
                public var batOne:BatOne;
                public var batTwo:BatTwo;
               
                //Visual effect behind each ball
                public var trail:Trail;
                public var trailOne:TrailOne;
                public var trailTwo:TrailTwo;
               
                //Win messages
                public var playerOneWin:PlayerOneWin;
                public var playerTwoWin:PlayerTwoWin;
 
                //Powerups
                public var itemRepair:ItemRepair;
                public var itemPathChanger:ItemPathChanger;
                public var itemShrink:ItemShrink;
                public var itemBall:ItemBall;
                public var itemRandom:ItemRandom;
               
                //Visual effect when barrier is damaged
                public var flashy:Flash;
                //Item Explosion
                public var explosion:Explosion;
               
                //Array of ball objects
                public var ballArray:Array = new Array(); //Array for balls
               
                //Array of items
                public var itemArray:Array = new Array(); //Array for items
               
                //Keyboard             
                        //P1
                        public var upOne:uint = 87;
                        public var downOne:uint = 83;
                        public var upOneDown:Boolean = false;
                        public var downOneDown:Boolean = false;
               
                        //P2
                        public var upTwo:uint = 38;
                        public var downTwo:uint = 40;
                        public var upTwoDown:Boolean = false;
                        public var downTwoDown:Boolean = false;
               
                //Game
                       
                        //Timer for the main game events
                        public var gameTimer:Timer;
                       
                        //The amount of friction to slow each bat down when it is moving (0 is an instant stop, 1 is no friction)
                        public var frictionOne:Number = 0.5;
                        public var frictionTwo:Number = 0.5;
                       
                        //Speeds of each bat
                        public var speedOne:Number = 12;
                        public var speedTwo:Number = 12;
                       
                        //Speed Caps for the ball
                        public var xBallCap:Number = 15;
                        public var yBallCap:Number = 15;
               
                //Constructor checking whether the stage has become active, and if not, cause a delay until the stage has become                                active
                public function Main():void
                {
                        if(stage)init();
                        else addEventListener(Event.ADDED_TO_STAGE,onAdd);
                }
               
                private function onAdd(e:Event):void
                {
                        init();
                        removeEventListener(Event.ADDED_TO_STAGE,onAdd);
                }
               
                //Once the game has started
                private function init():void
                {
                        //Spawn the ball
                        spawnBall(1280*0.5,720*0.5,xvBall(),yvBall(),1);
                       
                        //Spawn the bats
                        spawnBats();
                       
                        //Spawn the barriers
                        spawnBarriers();
                       
                        //Spawn the items
                        for(var t:int = 0; t < 3; t++)
                        {
                                spawnItem();
                        }
                       
                        //Adds the game timer, and events
                        gameTimer = new Timer(16.666,0);
                        gameTimer.addEventListener(TimerEvent.TIMER,collisionBallBat);
                        gameTimer.addEventListener(TimerEvent.TIMER,collisionBallStage);
                        gameTimer.addEventListener(TimerEvent.TIMER,collisionBallItem);
                        gameTimer.addEventListener(TimerEvent.TIMER,collisionBallBarrier);
                        gameTimer.addEventListener(TimerEvent.TIMER,batMovement);
                        gameTimer.addEventListener(TimerEvent.TIMER,ballMovement);
                        gameTimer.addEventListener(TimerEvent.TIMER,itemMovement);
                        gameTimer.start();
                       
                        //Adds the keyboard events
                        stage.addEventListener(KeyboardEvent.KEY_DOWN,keyboardDown);
                        stage.addEventListener(KeyboardEvent.KEY_UP,keyboardUp);
                }
               
                //Collision between the balls and the bat
                private function collisionBallBat(e:TimerEvent):void
                {
                        //For each ball in ballArray
                        for (var i:int = 0; i < ballArray.length; i++)
                        {
                                //if the ball hits p1 bat, deflect the ball, and change the visuals.
                                if(ballArray[i].hitTestObject(batOne))
                                {
                                        ballArray[i].x = batOne.x + 12.5;
                                        ballArray[i].yv = ((ballArray[i].y - batOne.y) / batOne.height * 0.5) * 30;
                                        if(ballArray[i].xv < 0)ballArray[i].xv *= -1;
                                        ballArray[i].xv += 1;
                                        ballArray[i].gotoAndStop(2);
                                }
                               
                                //if the ball hits p2 bat, deflect the ball, and change the visuals.
                                if(ballArray[i].hitTestObject(batTwo))
                                {
                                        ballArray[i].x = batTwo.x - 12.5;
                                        ballArray[i].yv = ((ballArray[i].y - batTwo.y) / batTwo.height * 0.5) * 30;
                                        if(ballArray[i].xv > 0)ballArray[i].xv *= -1;
                                        ballArray[i].xv -= 1;
                                        ballArray[i].gotoAndStop(3);
                                }
                        }
                }
               
                //Collision between the balls and the barriers
                private function collisionBallBarrier(e:TimerEvent):void
                {
                        //for each ball in ballArray
                        for (var i:int = 0; i < ballArray.length; i++)
                        {
                                //if the ball hits p1 barrier, add a visual effect, change the visuals of the barrier, and                              deflect the ball
                                if(ballArray[i].hitTestObject(barrierOne))
                                {
                                        flashy = new Flash();
                                        flashy.x = 1280 * 0.5;
                                        flashy.y = 720 * 0.5;
                                        addChild(flashy);
                                       
                                        ballArray[i].x = barrierOne.x + 12.5;
                                        ballArray[i].xv *= -1;
                                        ballArray[i].xv += 1;
                                        barrierOne.gotoAndStop(barrierOne.currentFrame + 1);
                                       
                                        // if there is more than 1 ball in play, remove the ball
                                        if(ballArray.length >= 2)
                                        {
                                                removeChild(ballArray[i]);
                                                ballArray.splice(i,1);
                                        }
                                }
                                //if the ball hits p2 barrier, add a visual effect, change the visuals of the barrier, and                              deflect the ball
                                else if(ballArray[i].hitTestObject(barrierTwo))
                                {
                                        flashy = new Flash();
                                        flashy.x = 1280 * 0.5;
                                        flashy.y = 720 * 0.5;
                                        addChild(flashy);
                                       
                                        ballArray[i].x = barrierTwo.x - 12.5;
                                        ballArray[i].xv *= -1;
                                        ballArray[i].xv -= 1;
                                        barrierTwo.gotoAndStop(barrierTwo.currentFrame + 1);
 
                                        // if there is more than 1 ball in play, remove the ball
                                        if(ballArray.length >= 2)
                                        {
                                                removeChild(ballArray[i]);
                                                ballArray.splice(i,1);
                                        }
                                }
                        }
                }
               
                //Collision with the balls and the stage
                private function collisionBallStage(e:TimerEvent):void
                {
                        //for each ball in the ballArray
                        for (var i:int = 0; i < ballArray.length; i++)
                        {
                                //if the ball hits the ceiling, bounce it downwards
                                if(ballArray[i].y < 0 + 5)
                                {
                                        ballArray[i].y = 0 + 5;
                                        ballArray[i].yv *= -1;
                                }
                               
                                //if the ball hits the floor, bounce it upwards
                                if(ballArray[i].y > 720 - 5)
                                {
                                        ballArray[i].y = 720 - 5;
                                        ballArray[i].yv *= -1;
                                }
                        }
                }
               
                //Collision with the balls and the items
                private function collisionBallItem(e:TimerEvent):void
                {
                        //for each ball in ballArray
                        for (var i:int = 0; i < ballArray.length; i++)
                        {
                                //for each item in the itemArray
                                for(var j:int = 0; j < itemArray.length; j++)
                                {
                                //if the ball collides with the item, add a visual effect, and call a function based on the item
                                        if(ballArray[i].hitTestObject(itemArray[j]))
                                        {
                                                explosion = new Explosion();
                                                explosion.x = itemArray[j].x;
                                                explosion.y = itemArray[j].y;
                                                addChild(explosion);
                                               
                                                switch(itemArray[j].types)
                                                {
                                                        case "Repair":
                                                        repair(ballArray[i].currentFrame);
                                                        break;
                                                       
                                                        case "PathChanger":
                                                        pathChanger(i);
                                                        break;
                                                       
                                                        case "Ball":
                                                        balls(itemArray[j].x,itemArray[j].y,ballArray[i].currentFrame);
                                                        break;
                                                       
                                                        case "Shrink":
                                                        shrink(ballArray[i].currentFrame);
                                                        break;
                                                       
                                                        case "Random":
                                                        randoms(itemArray[j].x,itemArray[j].y,ballArray[i].currentFrame,i);
                                                        break;                                                 
                                                }
                                               
                                                //Remove the item                                      
                                                removeChild(itemArray[j]);
                                                itemArray.splice(j,1);
                                               
                                                //Spawn a new item
                                                spawnItem();
                                        }
                                }
                        }
                }
               
                //Item Movement
                private function itemMovement(e:TimerEvent):void
                {
                        //Move each item in the itemArray, and reverse their velocity if they go out of bounds
                        for (var i:int = 0; i < itemArray.length; i++)
                        {
                                if (itemArray[i].x < 280)itemArray[i].xv *= -1;
                                if (itemArray[i].x > 1000)itemArray[i].xv *= -1;
                                if (itemArray[i].y < 0)itemArray[i].yv *= -1;
                                if (itemArray[i].y > 720)itemArray[i].yv *= -1;
                                                               
                                itemArray[i].x += itemArray[i].xv;
                                itemArray[i].y += itemArray[i].yv;
                        }
                }
               
                //Bat Movement
                private function batMovement(e:TimerEvent):void
                {
                        //For p1 bat, move the bat and add friction based on key presses
                        if(upOneDown)
                        {
                                batOne.yv = -speedOne;
                        }
                        if(downOneDown)
                        {
                                batOne.yv = speedOne;
                        }
                       
                        if(!upOneDown && !downOneDown)
                        {
                                batOne.yv *= frictionOne;
                        }
                       
                        batOne.y += batOne.yv;
                       
                        if(batOne.y < 0 + batOne.height * 0.5)
                        {
                                batOne.y = 0 + batOne.height * 0.5 +1;
                                batOne.yv = 0;
                        }
                       
                        if(batOne.y > 720 - batOne.height * 0.5)
                        {
                                batOne.y = 720 - batOne.height * 0.5 -1;
                                batOne.yv = 0;
                        }
                       
                        //For p2 bat, move the bat and add friction based on key presses
                       
                        if(upTwoDown)
                        {
                                batTwo.yv = -speedTwo;
                        }
                        if(downTwoDown)
                        {
                                batTwo.yv = speedTwo;
                        }
                       
                        batTwo.y += batTwo.yv;
                       
                        if(!upTwoDown && !downTwoDown)
                        {
                                batTwo.yv *= frictionTwo;
                        }
                       
                        if(batTwo.y < 0 + batTwo.height * 0.5)
                        {
                                batTwo.y = 0 + batTwo.height * 0.5 +1;
                                batTwo.yv = 0;
                        }
                       
                        if(batTwo.y > 720 - batTwo.height * 0.5)
                        {
                                batTwo.y = 720 - batTwo.height * 0.5 -1;
                                batTwo.yv = 0;
                        }
                       
                        //If the bat has been shrunk, increase its size gradually, and return its visuals to normal once it is back to normal size
                        if(batOne.height < 140)batOne.height += 0.15;
                        if(batOne.height == 140)batOne.gotoAndStop(1);
                       
                        if(batTwo.height < 140)batTwo.height += 0.15;
                        if(batTwo.height == 140)batTwo.gotoAndStop(1);
                }
               
                //Ball movement
                private function ballMovement(e:TimerEvent):void
                {
                        for (var i:int = 0; i < ballArray.length; i++)
                        {                                                      
                                //Speed Cap
                                if(ballArray[i].xv < -xBallCap) ballArray[i].xv = -xBallCap;
                                if(ballArray[i].xv > xBallCap) ballArray[i].xv = xBallCap;
                                if(ballArray[i].yv < -yBallCap) ballArray[i].yv = -yBallCap;
                                if(ballArray[i].yv > yBallCap) ballArray[i].yv = yBallCap;
                               
                                //Create Trail behind ball
                                if (ballArray[i].currentFrame == 1)
                                {
                                        trail = new Trail();
                                        trail.x = ballArray[i].x;
                                        trail.y = ballArray[i].y;
                                        addChild(trail);
                                }
                               
                                if (ballArray[i].currentFrame == 2)
                                {
                                        trailOne = new TrailOne();
                                        trailOne.x = ballArray[i].x;
                                        trailOne.y = ballArray[i].y;
                                        addChild(trailOne);
                                }
                               
                                if (ballArray[i].currentFrame == 3)
                                {
                                        trailTwo = new TrailTwo();
                                        trailTwo.x = ballArray[i].x;
                                        trailTwo.y = ballArray[i].y;
                                        addChild(trailTwo);
                                }
                               
                                //Move Ball
                                ballArray[i].x += ballArray[i].xv;
                                ballArray[i].y += ballArray[i].yv;
                               
                                //Ball is out of bounds to the left
                                if(ballArray[i].x < 0)
                                {
                                        playerTwoWin = new PlayerTwoWin();
                                        playerTwoWin.x = 1280 * 0.5;
                                        playerTwoWin.y = 720 * 0.5;
                                        addChild(playerTwoWin);
                                        gameTimer.stop();
                                }
                                //Ball is out of bounds to the right
                                else if(ballArray[i].x > 1280)
                                {
                                        playerOneWin = new PlayerOneWin();
                                        playerOneWin.x = 1280 * 0.5;
                                        playerOneWin.y = 720 * 0.5;
                                        addChild(playerOneWin);
                                        gameTimer.stop();
                                }
                        }
                }
               
                //Keyboard Events
               
                        //Key Down
                        private function keyboardDown(e:KeyboardEvent):void
                        {
                                if(e.keyCode == downOne)downOneDown = true;
                                else if(e.keyCode == upOne)upOneDown = true;
                       
                                if(e.keyCode == downTwo)downTwoDown = true;
                                else if(e.keyCode == upTwo)upTwoDown = true;
                        }
                       
                        //Key Up
                        private function keyboardUp(e:KeyboardEvent):void
                        {
                                if(e.keyCode == upOne)upOneDown = false;
                                if(e.keyCode == downOne)downOneDown = false;
                       
                                if(e.keyCode == upTwo)upTwoDown = false;
                                if(e.keyCode == downTwo)downTwoDown = false;
                        }
               
                //Spawn initial ball
                private function spawnBall(xp:Number,yp:Number,xv:Number,yv:Number,frame:Number):void
                {
                        ball = new Ball(xv,yv);
                        ball.x = xp;
                        ball.y = yp;
                        ball.gotoAndStop(frame);
                        ballArray.push(ball);
                        addChild(ball);
                }
               
                //Spawn the barriers
                private function spawnBarriers():void
                {
                        //P1 Barrier
                        barrierOne = new BarrierOne();
                        barrierOne.x = 7.5;
                        barrierOne.y = 720 * 0.5;
                        addChild(barrierOne);
                       
                        //P2 Barrier
                        barrierTwo = new BarrierTwo();
                        barrierTwo.x = 1280 - 7.5;
                        barrierTwo.y = 720 * 0.5;
                        addChild(barrierTwo);
                }
               
                //Spawn the bats
                private function spawnBats():void
                {
                        //P1 Bat
                        batOne = new BatOne();
                        batOne.x = 15 + 7.5;
                        batOne.y = 720 * 0.5;
                        addChild(batOne);
                       
                        //P2 Bat
                        batTwo = new BatTwo();
                        batTwo.x = 1280 - 15 - 7.5;
                        batTwo.y = 720 * 0.5;
                        addChild(batTwo);
                }
               
                //Spawn the items
                private function spawnItem():void
                {
                        //Takes a random number between 0 and 100
                        var num:Number = (Math.random() * 100);
                       
                        if (num < 20)spawnItemBall();
                        else if (num < 40)spawnItemRepair();
                        else if (num < 60)spawnItemShrink();
                        else if (num < 80)spawnItemPathChanger();
                        else if (num < 100)spawnItemRandom();
                }
                       
                        private function spawnItemRepair():void
                        {
                                //Spawn a repair item
                                itemRepair = new ItemRepair(xvItem(),yvItem());
                                itemRepair.x = xItemSpawn();
                                itemRepair.y = yItemSpawn();
                                itemArray.push(itemRepair);
                                addChild(itemRepair);
                        }
                       
                        private function spawnItemPathChanger():void
                        {
                                //Spawn a pathChanger item
                                itemPathChanger = new ItemPathChanger(xvItem(),yvItem());
                                itemPathChanger.x = xItemSpawn();
                                itemPathChanger.y = yItemSpawn();
                                itemArray.push(itemPathChanger);
                                addChild(itemPathChanger);
                        }
                       
                        private function spawnItemShrink():void
                        {
                                //Spawn a shrink item
                                itemShrink = new ItemShrink(xvItem(),yvItem());
                                itemShrink.x = xItemSpawn();
                                itemShrink.y = yItemSpawn();
                                itemArray.push(itemShrink);
                                addChild(itemShrink);
                        }
               
                        private function spawnItemBall():void
                        {
                                //Spawn a ball item
                                itemBall = new ItemBall(xvItem(),yvItem());
                                itemBall.x = xItemSpawn();
                                itemBall.y = yItemSpawn();
                                itemArray.push(itemBall);
                                addChild(itemBall);
                        }
               
                        private function spawnItemRandom():void
                        {
                                //Spawn a random item (ball / shrink / repair / pathChanger)
                                itemRandom = new ItemRandom(xvItem(),yvItem());
                                itemRandom.x = xItemSpawn();
                                itemRandom.y = yItemSpawn();
                                itemArray.push(itemRandom);
                                addChild(itemRandom);
                        }
                       
                        //Ball Item (Spawns a ball in the position of the item, which favours the player who hit the item)
                        private function balls(xp:Number,yp:Number,frame:Number):void
                        {
                                //Direction of the ball
                                var dir:Number;
                               
                                //If the ball is unfavoured it goes in a random direction
                                if(frame == 1)dir = xvBall();
                                //If the ball was hit by P1, the ball goes towards P1
                                else if(frame == 2)dir = 8;
                                //If the ball was hit by P2, the ball goes towards P2
                                else if(frame == 3)dir = -8;
                               
                                //Spawn the ball
                                spawnBall(xp,yp,dir,0,frame);  
                }
               
                //Shrinks the opposing player's bat
                private function shrink(frame:Number):void
                {
                        if(frame == 2)
                        {
                                batTwo.height *= 0.5;
                                batTwo.gotoAndStop(2);
                        }
                        else if (frame == 3)
                        {
                                batOne.height *= 0.5;
                                batOne.gotoAndStop(2);
                        }
                }
               
                //Randomly chooses an item
                private function randoms(xp:Number, yp:Number,frame:Number,i:int):void
                {
                        var num:Number = (Math.random() * 100);
                       
                        if (num < 25)balls(xp,yp,frame)
                        else if (num < 50)shrink(frame);
                        else if(num < 75)repair(frame);
                        else pathChanger(i);
                }
               
                //Changes path of ball
                private function pathChanger(i:int):void
                {
                        ballArray[i].yv = -10 + (Math.random() * 20)
                }
               
                //Heals player's barrier
                private function repair(frame:Number):void
                {
                        if(frame == 3 && barrierTwo.currentFrame > 1)barrierTwo.gotoAndStop(barrierTwo.currentFrame - 1);
                        if(frame == 2 && barrierOne.currentFrame > 1)barrierOne.gotoAndStop(barrierOne.currentFrame - 1);
                }
                               
                //BallSpawnSpeed
                private function xvBall():Number
                {
                        return 8 * (((Math.round(Math.random() * 1)) * 2) - 1);
                }
       
                private function yvBall():Number
                {
                        return 0;
                }
               
                //ItemSpawnSpeed
                private function xvItem():Number
                {
                        return -4 + (Math.random() * 8);
                }
               
                private function yvItem():Number
                {
                        if(itemArray.length != 0)
                        {
                                if(itemArray[0].yv > 0) return -4;
                                else return 4;
                        }
                        else return (((Math.round(Math.random() * 1)) * 2) - 1) * 4;
                }
               
                //ItemSpawnCoordinates
                private function xItemSpawn():Number
                {
                        return (1280 * 0.25) + (Math.random()*(1280 * 0.5));
                }
               
                private function yItemSpawn():Number
                {
                        return (15 + (690 * Math.random()));
                }
        }
}