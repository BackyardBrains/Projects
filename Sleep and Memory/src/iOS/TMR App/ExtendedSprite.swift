
import SpriteKit

class ExtendedSprite:SKSpriteNode{
    var myScene:SKScene
    
    init(scene:SKScene){
        //Establish Scene property
        self.myScene = scene
        //Set SKSpriteNode Positional and Visual Properties
        let texture:SKTexture = SKTexture(imageNamed:"SomeDefaultImage")
        super.init(texture:texture,color:.clear,size:texture.size())
        self.zPosition = 0
        self.name = "someSpriteName"
        self.setScale(0.3)
        self.position = CGPoint(x:0,y:0)
    }
    
    init(){
        self.myScene = SKScene()
        let texture = SKTexture(imageNamed: "SomeDefaultImage")
        super.init(texture:texture,color:.clear,size:texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    
}
