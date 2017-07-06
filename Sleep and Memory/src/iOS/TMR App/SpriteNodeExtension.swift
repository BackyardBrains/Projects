
//COPY THIS

import SpriteKit

extension SKSpriteNode{
    convenience init(imageName image:String,width:CGFloat,height:CGFloat,anchorPoint:CGPoint,position:CGPoint,zPosition:CGFloat,alpha:CGFloat){
        let texture = SKTexture(imageNamed: image)
        self.init(texture:texture,color:.clear,size:texture.size())
        self.size = CGSize(width:width,height:height)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.alpha = alpha
    }
    
    convenience init(imageName image:String,scale:CGFloat,anchorPoint:CGPoint,position:CGPoint,zPosition:CGFloat,alpha:CGFloat){
        let texture = SKTexture(imageNamed: image)
        self.init(texture:texture,color:.clear,size:texture.size())
        self.setScale(scale)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.alpha = alpha
    }
    
    convenience init(imageName image:String,xSize:CGFloat,anchorPoint:CGPoint,position:CGPoint,zPosition:CGFloat,alpha:CGFloat){
        let texture = SKTexture(imageNamed: image)
        self.init(texture:texture,color:.clear,size:texture.size())
        let scale = xSize/self.size.width
        self.setScale(scale)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.alpha = alpha
    }
    
    convenience init(imageName image:String,ySize:CGFloat,anchorPoint:CGPoint,position:CGPoint,zPosition:CGFloat,alpha:CGFloat){
        let texture = SKTexture(imageNamed: image)
        self.init(texture:texture,color:.clear,size:texture.size())
        let scale = ySize/self.size.height
        self.setScale(scale)
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.alpha = alpha
    }
    
    convenience init(color:UIColor,width:CGFloat,height:CGFloat,anchorPoint:CGPoint,position:CGPoint,zPosition:CGFloat,alpha:CGFloat){
        let texture = SKTexture()
        self.init(texture:texture,color:color,size:CGSize(width:width,height:height))
        self.colorBlendFactor = 1
        self.anchorPoint = anchorPoint
        self.position = position
        self.zPosition = zPosition
        self.alpha = alpha
    }
    
    
    
    
}
