
//Copy and Paste this file for a "Screen Template". Just change GameScene into the appropriate class name. Copy and paste the GameViewController file and replace your current GameViewController file with.

import SpriteKit

class Screen: SKScene, SKPhysicsContactDelegate {
    //Declare and blank initialize all of your variables and SKNodes here
    
    
    override func didMove(to view: SKView) {
        //Set up environment
        self.anchorPoint = CGPoint(x:0,y:0)
        self.physicsWorld.gravity = CGVector(dx:0,dy:-9.8)
        self.physicsWorld.contactDelegate = self
        
        //Set up gesture recognizers
        let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action:#selector(self.pinch))
        view.addGestureRecognizer(pinchGesture)
        
        let rotateGesture:UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.rotate))
        view.addGestureRecognizer(rotateGesture)
        
        let edgeGesture:UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.edge))
        edgeGesture.edges = .all //Which edges to detect. You can also do .left, .right, .top, .bottom
        view.addGestureRecognizer(edgeGesture)
        
        let leftGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        leftGesture.direction = .left
        leftGesture.numberOfTouchesRequired = 1 //You can edit this - how many fingers need to do the swipe.
        view.addGestureRecognizer(leftGesture)
        
        let rightGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        rightGesture.direction = .right
        rightGesture.numberOfTouchesRequired = 1 //You can edit this - how many fingers need to do the swipe.
        view.addGestureRecognizer(rightGesture)
        
        let upGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        upGesture.direction = .up
        upGesture.numberOfTouchesRequired = 1 //You can edit this - how many fingers need to do the swipe.
        view.addGestureRecognizer(upGesture)
        
        let downGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        downGesture.direction = .down
        downGesture.numberOfTouchesRequired = 1 //You can edit this - how many fingers need to do the swipe.
        view.addGestureRecognizer(downGesture)
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.pan))
        panGesture.maximumNumberOfTouches = 1 //You can edit this - max number of fingers needed to pan
        panGesture.minimumNumberOfTouches = 1 //You can edit this - min number of fingers needed to pan
        panGesture.require(toFail: leftGesture) //Only put the following four lines here if you want to heavily prioritize swiping over panning
        panGesture.require(toFail: rightGesture) //This is because pan and swipe have conflicts.
        panGesture.require(toFail: upGesture)
        panGesture.require(toFail: downGesture)
        view.addGestureRecognizer(panGesture)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self, action:#selector(self.longPress))
        longPressGesture.allowableMovement = 10 //Some CGFloat - how much finger can move
        longPressGesture.minimumPressDuration = 2 //Min time needed in press to activate
        longPressGesture.numberOfTouchesRequired = 1 //How many fingered needed to press
        view.addGestureRecognizer(longPressGesture)
        
        //Start to Code Here. This is where your computer begins to run your screen
        
    }
    
    //Gesture Functions
    func pinch(gesture:UIPinchGestureRecognizer){
        let scale:CGFloat = gesture.scale           //how far apart the fingers were
        let velocity:CGFloat = gesture.velocity     //how fast the pinch gesture happened
        //What to do if user pinches the screen
        print("pinched")
    }
    func rotate(gesture:UIRotationGestureRecognizer){
        let rotateAngle:CGFloat = gesture.rotation  //what angle of rotation was detected
        let velocity:CGFloat = gesture.velocity     //how fast the rotation gesture happened
        //What to do if user makes a rotation gesture
        print("rotated")
    }
    func pan(gesture:UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        let translationX = translation.x            //The amount panned in x direction
        let translationY = translation.y             //The amount panned in y direction
        let velocity = gesture.velocity(in: self.view) //How fast the swipe was
        //What to do if user pans on the screen
        print("panned")
        
        //
        gesture.setTranslation(CGPoint(x:0,y:0), in: self.view)
    }
    func edge(gesture:UIScreenEdgePanGestureRecognizer){
        //What to do if user swipes at edge
        print("edge")
    }
    func swipe(gesture:UISwipeGestureRecognizer){
        print("swipe")
        if gesture.direction == .left{
            //What to do if user swipes left
            print("swiped left")
        }
        if gesture.direction == .right{
            //What to do if user swipes right
            print("swiped right")
        }
        if gesture.direction == .down{
            //What to do if user swipes down
            print("swiped down")
        }
        if gesture.direction == .up{
            //What to do if user swipes up
            print("swiped up")
        }
    }
    func longPress(gesture:UILongPressGestureRecognizer){
        //What to do if user presses screen a long time
        print("long Press")
    }
    
    //Contact Function
    func didBegin(_ contact:SKPhysicsContact){  //This function is called when contacttestbitmasks collide
        let body1 = contact.bodyA   //body1 is the PhysicsBody of one of the colliding objects
        let body2 = contact.bodyB   //body2 is the PhysicsBody of the other colliding object
        let node1 = body1.node      //This is the SKSpriteNode of one of the colliding objects
        let node2 = body2.node      //This is the SKSpriteNode of the other colliding object
        
        
    }
    
    //Touch Recognition Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//What to do if a user touches to screen
        for touch in touches{ //There is a for loop because you can have multiple touches on the screen at a time.
            //You can access all of the properties of touch with touch.someProperty. Pretty awesome how much you can figure out.
            let location = touch.location(in:self)
            print("touched")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {//What to do if a user drags his finger across the screen
        for touch in touches{
            //You can access all of the properties of touch with touch.someProperty. Pretty awesome how much you can figure out.
            let location = touch.location(in:self)
            print("touch moved")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {//What to do if a user lifted his finger from the screen
        for touch in touches{
            //You can access all of the properties of touch with touch.someProperty. Pretty awesome how much you can figure out.
            let location = touch.location(in:self)
            print("touch ended")
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {//What to do if the touch invalidates
        for touch in touches{
            //You can access all of the properties of touch with touch.someProperty. Pretty awesome how much you can figure out.
            let location = touch.location(in:self)
            print("touch invalidated")
        }
    }
    
    //Update Function
    override func update(_ currentTime: TimeInterval) {//This function is called everytime the frame reloads (so it is called constantly, hundreds of times a second)
        
    }
}
