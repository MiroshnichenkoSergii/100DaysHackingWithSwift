//
//  GameScene.swift
//  Project29
//
//  Created by Sergii Miroshnichenko on 10.08.2022.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewController: GameViewController!
    
    var buildings = [BuildingNode]()
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!

    var currentPlayer = 1
    
    var isEndGame = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)

        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        wind(Double.random(in: -10...10), -9.8)
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }

        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }

        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
            viewController.score2 += 1
        }

        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
            viewController.score1 += 1
        }
        
        print("check scores", viewController.score1, viewController.score2)
        if viewController.score1 == 3 || viewController.score2 == 3 {
            endGame()
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)

        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }

        banana.name = ""
        banana.removeFromParent()
        banana = nil

        changePlayer()
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }

        player.removeFromParent()
        banana.removeFromParent()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController.currentGame = newGame

            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer

            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }

        viewController.activatePlayer(number: currentPlayer)
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15

        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2

            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)

            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        // 1 Figure out how hard to throw the banana. We accept a velocity parameter, but I'll be dividing that by 10. You can adjust this based on your own play testing.
        let speed = Double(velocity) / 10.0

        // 2 Convert the input angle to radians. Most people don't think in radians, so the input will come in as degrees that we will convert to radians.
        let radians = deg2rad(degrees: angle)

        // 3 If somehow there's a banana already, we'll remove it then create a new one using circle physics.
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }

        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)

        if currentPlayer == 1 {
            // 4 If player 1 was throwing the banana, we position it up and to the left of the player and give it some spin.
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20

            // 5 Animate player 1 throwing their arm up then putting it down again.
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)

            // 6 Make the banana move in the correct direction.
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            // 7 If player 2 was throwing the banana, we position it up and to the right, apply the opposite spin, then make it move in the correct direction.
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20

            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)

            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayers() {
        guard isEndGame == false else { return }
        
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false

        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)

        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false

        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func endGame() {
        isEndGame = true
        
        var winner = 1
        if viewController.score2 > viewController.score1 {
            winner = 2
        }
        
        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "Player\(winner) WIN'S"
        gameOverLabel.fontName = "Chalkduster"
        gameOverLabel.fontSize = 40
        gameOverLabel.position = CGPoint(x: 512, y: 620)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
        
        viewController.score1 = 0
        viewController.score2 = 0
    }
    
    func wind(_ dx: Double, _ dy: Double) {
        switch dx {
        case -10 ... -7:
            physicsWorld.gravity = CGVector(dx: dx, dy: dy)
            viewController.windLabel.text = "<<<"
        case -6 ... -3:
            physicsWorld.gravity = CGVector(dx: dx, dy: dy)
            viewController.windLabel.text = "<<"
        case -2 ... -1:
            physicsWorld.gravity = CGVector(dx: dx, dy: dy)
            viewController.windLabel.text = "<"
        case 1 ... 3:
            physicsWorld.gravity = CGVector(dx: dx, dy: dy)
            viewController.windLabel.text = ">"
        case 4 ... 7:
            physicsWorld.gravity = CGVector(dx: dx, dy: dy)
            viewController.windLabel.text = ">>"
        case 8 ... 10:
            physicsWorld.gravity = CGVector(dx: dx, dy: dy)
            viewController.windLabel.text = ">>>"
        default:
            physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            viewController.windLabel.text = "|"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }

            if abs(banana.position.y) > 1000 {
                banana.removeFromParent()
                banana = nil
                changePlayer()
            }
    }
}
