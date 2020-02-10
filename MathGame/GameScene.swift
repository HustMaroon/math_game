//
//  GameScene.swift
//  MathGame
//
//  Created by Do Xuan Thanh on 1/1/19.
//  Copyright © 2019 monstar-lab. All rights reserved.
//

import SpriteKit
import GameplayKit

@available(iOS 11.0, *)
class GameScene: SKScene {
    var resultArea = SKSpriteNode()
    var correctResult : Int = 0
    var currentBalloon = SKSpriteNode()
    let arrows = SKSpriteNode(imageNamed: "arrows")
    var score : Int = 0
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    var moveTime = 5.0
    
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        setBackground()
        showArrows()
        showScore()
        addResultButtons()
        addBalloon(time: moveTime)
    }
    
    func addBalloon(time: Double){
        let balloon = SKSpriteNode(imageNamed: "balloon")
        NodeHelper.scaledToWidth(node: balloon, width: size.width * 1/3)
        balloon.physicsBody = SKPhysicsBody(circleOfRadius: (balloon.size.width) * 0.5)
        balloon.physicsBody?.isDynamic = true
        balloon.physicsBody?.categoryBitMask = PhysicsCategory.balloon
        balloon.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        balloon.physicsBody?.collisionBitMask = PhysicsCategory.none
        balloon.position = CGPoint(x: size.width * 0.5, y: balloon.size.height / 2 + resultArea.size.height)
        balloon.zPosition = 1
        
        let label = SKSpriteNode(imageNamed: "label")
        label.zPosition = 1
        NodeHelper.scaledToWidth(node: label, width: balloon.size.width)
        label.position = CGPoint(x: 0, y: -balloon.size.height / 2)
        
        let question = SKLabelNode(fontNamed: "AvenirNext-Bold")
        question.text = genOperator()
        question.verticalAlignmentMode = .center
        question.horizontalAlignmentMode = .center
        question.fontSize = 20
        question.zPosition = 1
        label.addChild(question)
        
        balloon.addChild(label)
        addChild(balloon)
        
        let actionMove = SKAction.move(to: CGPoint(x: balloon.position.x, y: size.height - arrows.size.height), duration: TimeInterval(time))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            self.moveToLoseScene()
        }
        balloon.run(SKAction.sequence([actionMove, actionMoveDone, loseAction]))
        
        //update result area
        var results : [Int]
        if correctResult == 0 {
            results = [0,1,2]
        } else {
            results = [Int.random(in: 0..<correctResult), Int.random(in: correctResult + 1...correctResult * 2), correctResult]
        }
        for node in resultArea.children {
            let resultLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
            let randomizedIndex = Int.random(in: 0..<results.count)
            resultLabel.text = "\(results[randomizedIndex])"
            resultLabel.fontSize = 25
            resultLabel.zPosition = 1
            resultLabel.name = "result"
            node.removeAllChildren()
            node.addChild(resultLabel)
            results.remove(at: randomizedIndex)
        }
        
        currentBalloon = balloon
    }
    
    func addResultButtons(){
        resultArea = SKSpriteNode(color: backgroundColor, size: CGSize(width: size.width, height: 100))
        resultArea.position = CGPoint(x: size.width / 2, y: resultArea.size.height / 2)

        let result2 = SKSpriteNode(imageNamed: "result")
        NodeHelper.scaledToWidth(node: result2, width: size.width * 0.25)
        result2.zPosition = 1
        result2.position = CGPoint(x: 0, y: 0)
        resultArea.addChild(result2)
        
        let result1 = SKSpriteNode(imageNamed: "result")
        NodeHelper.scaledToWidth(node: result1, width: size.width * 0.25)
        result1.zPosition = 1
        result1.position = CGPoint(x: -result2.size.width - 20, y: 0)
        resultArea.addChild(result1)
        
        let result3 = SKSpriteNode(imageNamed: "result")
        NodeHelper.scaledToWidth(node: result3, width: size.width * 0.25)
        result3.zPosition = 1
        result3.position = CGPoint(x: result2.size.width + 20, y: 0)
        resultArea.addChild(result3)
        
        addChild(resultArea)
    }
    
    func genOperator() -> String{
        let operatorsSet = OperationScope.shared.operatorsSet()
        let randomizedOperator = operatorsSet[Int.random(in: 0..<operatorsSet.count)]
        var firstNumber = Int.random(in: 0..<OperationScope.shared.numberScope())
        var secondNumber : Int
        if randomizedOperator == Constants.div {
            secondNumber = Int.random(in: 1...firstNumber)
            firstNumber = firstNumber - firstNumber%secondNumber
            correctResult = firstNumber / secondNumber
        } else {
            secondNumber = Int.random(in: 0...firstNumber)
            switch randomizedOperator {
            case Constants.plus:
                correctResult = firstNumber + secondNumber
            case Constants.sub:
                correctResult = firstNumber - secondNumber
            case Constants.multi:
                correctResult = firstNumber * secondNumber
            default:
                return ""
            }
        }
        return "\(firstNumber) \(randomizedOperator) \(secondNumber) = ?"
        
    }
    //helpers
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: resultArea)
        let touchedNode = resultArea.atPoint(location!)
        if !(touchedNode.parent == resultArea || touchedNode.name == "result" ) { return }
        var selectedResult : Int
        if touchedNode.name == "result" {
            let label = touchedNode as! SKLabelNode
            selectedResult = Int(label.text!)!
        } else {
            let label = touchedNode.childNode(withName: "result") as! SKLabelNode
            selectedResult = Int(label.text!)!
        }
        if selectedResult == correctResult {
            score += 1
            updateScore()
            currentBalloon.removeFromParent()
            
            // speedup
            if score%5 == 0 {
                moveTime += -0.5
            }
            addBalloon(time: moveTime)
        } else {
            moveToLoseScene()
        }
    }
    
    //lose scene
    func moveToLoseScene(){
        let reveal = SKTransition.flipVertical(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: score)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    //backgound
    func setBackground(){
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 0
        background.scale(to: size)
        addChild(background)
    }
    
    //show score
    func showScore(){
        scoreLabel.text = "SCORE: \(score)"
        scoreLabel.position = CGPoint(x: size.width - scoreLabel.frame.width / 2 - 10, y: size.height - arrows.size.height - scoreLabel.frame.height / 2 - 10)
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = UIColor.blue
        addChild(scoreLabel)
    }
    
    func updateScore(){
        scoreLabel.text = "SCORE: \(score)"
    }
    
    //arrows
    func showArrows(){
        NodeHelper.scaledToWidth(node: arrows, width: size.width)
        arrows.position = CGPoint(x: size.width / 2, y: size.height - arrows.size.height / 2)
        arrows.zPosition = 1
        addChild(arrows)
    }
}
