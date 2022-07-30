//
//  GameScene.swift
//  SunGun
//
//  Created by Sergii Miroshnichenko on 03.07.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var possibleEnemies = [String]()
    var gameTimer: Timer?
    var enemiesCount = 0
    
    
    override func didMove(to view: SKView) {
        
        readContent()
        
        let background = SKSpriteNode(imageNamed: ["sunBeach", "sunGreenGrass"].shuffled().first!)
        background.position = CGPoint(x: 512, y: 384)
        background.size.height = 786
        background.size.width = 1024
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 12, y: 15)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        for obj in objects {
            if let name = obj.name {
                let explosion = SKEmitterNode(fileNamed: "Explosion")!
                explosion.position = obj.position
                addChild(explosion)
                if name == "70699" || name == "337448" {
                    score += 1
                    obj.removeFromParent()
                } else if name == "172075" || name == "337408" {
                    score += 5
                    obj.removeFromParent()
                } else {
                    score -= 1
                    obj.removeFromParent()
                }
            } else {
                score -= 2
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -500 || node.position.x > 1500 {
                node.removeFromParent()
            }
        }
    }
    
    @objc func createEnemy() {
        let direction = [-1, 1, -1]
        let xPosition = [1200, -100, 1200]
        let yPosition = [121, 393, 665]
        let multipl = Double.random(in: 0.5...1.2)
        
        var xScale = 0.35
        var yScale = 0.35
        
        for i in 0...2 {
            enemiesCount += 1
            guard let enemy = possibleEnemies.randomElement() else { return }

            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.name = enemy
            sprite.xScale = xScale
            sprite.yScale = yScale
            sprite.position = CGPoint(x: xPosition[i], y: yPosition[i])
            addChild(sprite)
            
            if sprite.size.height < 100 {
                sprite.run(SKAction.moveBy(x: CGFloat(1500*direction[i]), y: 0, duration: 2))
            } else {
                sprite.run(SKAction.moveBy(x: CGFloat(1500*direction[i]), y: 0, duration: 5))
            }
            
            xScale *= multipl
            yScale *= multipl
            
//            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
//            sprite.physicsBody?.categoryBitMask = 1
//
//            if sprite.size.height < 100 {
//                sprite.physicsBody?.velocity = CGVector(dx: 600*direction[i], dy: 0)
//            } else {
//                sprite.physicsBody?.velocity = CGVector(dx: 100*direction[i], dy: 0)
//            }
//
//            sprite.physicsBody?.linearDamping = 0
//            sprite.physicsBody?.angularDamping = 0
            
        }
    }
    
    func readContent() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            let name = item.filter { $0.isNumber }
            if !name.isEmpty {
                possibleEnemies.append(name)
            }
        }
        print(possibleEnemies)
    }
}


