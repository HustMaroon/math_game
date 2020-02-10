import SpriteKit

@available(iOS 11.0, *)
class GameOverScene: SKScene {
    let grade1 = SKSpriteNode(imageNamed: "play_button")
    let grade2 = SKSpriteNode(imageNamed: "play_button")
    let grade3 = SKSpriteNode(imageNamed: "play_button")

    init(size: CGSize, score: Int, initScreen:Bool = false) {
        super.init(size: size)
        
        let highScore = UserDefaults.standard.integer(forKey: Constants.highScore)
        var message = ""
        if score <= highScore {
            message = initScreen ? "" : "Game Over!\nScore: \(score)"
            message += "\nHigh Score: \(highScore)"
        } else {
            let fireWork = SKSpriteNode(fileNamed: "GameOverScene")
            fireWork?.position = CGPoint(x: size.width / 2, y: size.height * 4/5)
            addChild(fireWork!)
            message = "congrats!\nyou broke the record"
            message += "\nHigh Score: \(score)"
            UserDefaults.standard.set(score, forKey: Constants.highScore)
        }
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 30
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.numberOfLines = 0
        label.horizontalAlignmentMode = .center
        addChild(label)
        
        //add play button
        grade1.position = CGPoint(x: size.width / 2, y: size.height / 3)
        NodeHelper.scaledToWidth(node: grade1, width: size.width / 3)
        let grade1Label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        grade1Label.text = "Grade 1"
        grade1Label.fontSize = 25
        grade1Label.zPosition = 1
        grade1Label.position = CGPoint(x: 0, y: 0)
        grade1.addChild(grade1Label)
        grade1.name = "grade1"
        grade1Label.name = "grade1"
        addChild(grade1)
        
        grade2.position = CGPoint(x: size.width / 2, y: grade1.position.y - grade1.size.height - 10)
        NodeHelper.scaledToWidth(node: grade2, width: size.width / 3)
        let grade2Label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        grade2Label.text = "Grade 2"
        grade2Label.fontSize = 25
        grade2Label.zPosition = 1
        grade2Label.position = CGPoint(x: 0, y: 0)
        grade2.addChild(grade2Label)
        grade2.name = "grade2"
        grade2Label.name = "grade2"
        addChild(grade2)
        
        grade3.position = CGPoint(x: size.width / 2, y: grade2.position.y - grade1.size.height - 10)
        NodeHelper.scaledToWidth(node: grade3, width: size.width / 3)
        let grade3Label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        grade3Label.text = "Grade 3"
        grade3Label.fontSize = 25
        grade3Label.zPosition = 1
        grade3Label.position = CGPoint(x: 0, y: 0)
        grade3.addChild(grade3Label)
        grade3.name = "grade3"
        grade3Label.name = "grade3"
        addChild(grade3)
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let node = self.atPoint(location!)
        if !["grade1", "grade2", "grade3"].contains(node.name) { return }

        switch node.name {
        case "grade1":
            OperationScope.shared.setGrade(grade: 1)
        case "grade2":
            OperationScope.shared.setGrade(grade: 2)
        case "grade3":
            OperationScope.shared.setGrade(grade: 3)
        default:
            return
        }
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: reveal)
    }
    
}
