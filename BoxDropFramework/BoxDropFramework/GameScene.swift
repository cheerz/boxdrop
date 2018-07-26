//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    private struct GameSettings {
        static let verticalPipeGap = 170.0
        static let delayBetweenPipes: TimeInterval = 2.0
    }

    private enum BoxTextureName: String {
        case first = "cheerzbox-1"
        case second = "cheerzbox-2"
        case third = "cheerzbox-3"
        case fourth = "cheerzbox-4"

        var toSKTexture: SKTexture {
            return SKTexture(image: UIImage(named: rawValue,
                                            in: Bundle(for: BoxDropLauncher.self),
                                            compatibleWith: nil)!)
        }
    }

    private struct Texture {
        static let sky = textureFrom(name: "sky")
        static let pipeUp = textureFrom(name: "pipe")
        static let pipeDown = textureFrom(name: "pipe")
        static let land = textureFrom(name: "land")

        static func textureFrom(name: String) -> SKTexture {
            return SKTexture(image: UIImage(named: name,
                                            in: Bundle(for: BoxDropLauncher.self),
                                            compatibleWith: nil)!)
        }
    }

    let boxTextureNames = [BoxTextureName.first.rawValue,
                           BoxTextureName.second.rawValue,
                           BoxTextureName.third.rawValue,
                           BoxTextureName.fourth.rawValue]

    var repeatActionBox = SKAction()
    var boxSprites: [SKTexture] = []
    var cheerzbox = SKSpriteNode()

    let skyColor = SKColor(red: 81.0 / 255.0,
                           green: 192.0 / 255.0,
                           blue: 201.0 / 255.0,
                           alpha: 1.0)
    var pipeTextureUp = SKTexture()
    var pipeTextureDown = SKTexture()
    var movePipesAndRemove = SKAction()
    var movingNode = SKNode()
    var pipes = SKNode()
    var canRestart = false
    var scoreLabelNode = SKLabelNode()
    var score = 0

    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if movingNode.speed > 0 {
            for _ in touches { // do we need all touches?
                cheerzbox.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                cheerzbox.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
            }
        } else if canRestart {
            resetScene()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        let value = cheerzbox.physicsBody!.velocity.dy * ( cheerzbox.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 )
        cheerzbox.zRotation = min(max(-1, value), 0.5)
    }

    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
    }

    private func setupBackgroundColor() {
        backgroundColor = skyColor
    }

    private func createGroundTexture() -> SKTexture {
        let groundTexture = Texture.land
        groundTexture.filteringMode = .nearest // shorter form for SKTextureFilteringMode.Nearest
        return groundTexture
    }

    private func createMoveGroundSpritesForever(groundTexture: SKTexture) -> SKAction {
        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        return SKAction.repeatForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
    }

    private func setPipeTextures() {
        pipeTextureUp = Texture.pipeUp
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = Texture.pipeDown
        pipeTextureDown.filteringMode = .nearest
    }

    private func setBirdsSprites() {
        boxSprites = boxTextureNames.map {
            SKTexture(image: UIImage(named: $0, in: Bundle(for: BoxDropLauncher.self), compatibleWith: nil)!)
        }
    }

    private func createBird() -> SKSpriteNode {
        let anim = SKAction.animate(with: boxSprites, timePerFrame: 0.2)
        repeatActionBox = SKAction.repeatForever(anim)

        cheerzbox = SKSpriteNode(texture: BoxTextureName.first.toSKTexture)

        cheerzbox.setScale(2.0)
        cheerzbox.position = CGPoint(x: frame.width * 0.35, y: frame.height * 0.6)

        cheerzbox.physicsBody = SKPhysicsBody(circleOfRadius: cheerzbox.size.height / 2.0)
        cheerzbox.physicsBody?.isDynamic = true
        cheerzbox.physicsBody?.allowsRotation = false

        cheerzbox.physicsBody?.categoryBitMask = birdCategory
        cheerzbox.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        cheerzbox.physicsBody?.contactTestBitMask = worldCategory | pipeCategory

        return cheerzbox
    }

    override func didMove(to view: SKView) {
        createScene()
    }

    private func add(_ groundTexture: SKTexture, to node: SKNode) {
        let moveGroundSpritesForever = createMoveGroundSpritesForever(groundTexture: groundTexture)

        for i in 0 ..< 2 + Int(frame.width / (groundTexture.size().width * 2)) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width,
                                      y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            node.addChild(sprite)
        }
    }

    private func add(_ skyTexture: SKTexture, groundTexture: SKTexture, to node: SKNode) {
        skyTexture.filteringMode = .nearest

        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite, resetSkySprite]))

        for i in 0 ..< 2 + Int(self.frame.width / ( skyTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            node.addChild(sprite)
        }
    }

    private func createPipesMovementAction() -> SKAction {
        let distanceToMove = CGFloat(self.frame.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        return SKAction.sequence([movePipes, removePipes])
    }

    private func createScene() {
        canRestart = true

        setupPhysics()
        setupBackgroundColor()

        addChild(movingNode)
        movingNode.addChild(pipes)

        let groundTexture = createGroundTexture()
        add(groundTexture, to: movingNode)

        let skyTexture = Texture.sky
        add(skyTexture, groundTexture: groundTexture, to: movingNode)

        setPipeTextures()

        movePipesAndRemove = createPipesMovementAction()

        // spawn the pipes
        let spawn = SKAction.run(spawnPipes)
        let delay = SKAction.wait(forDuration: GameSettings.delayBetweenPipes)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        run(spawnThenDelayForever)

        setBirdsSprites()
        cheerzbox = createBird()
        addChild(cheerzbox)
        cheerzbox.run(repeatActionBox)

        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.size.width,
                                                               height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        addChild(ground)

        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        addChild(scoreLabelNode)
    }

    private func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        pipePair.zPosition = -10

        let height = UInt32( self.frame.size.height / 4)
        let y = Double(arc4random_uniform(height) + height)

        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + GameSettings.verticalPipeGap)

        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)

        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: y)

        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)

        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + cheerzbox.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)

        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)

    }

    private func resetScene () {
        // Move bird to original position and reset velocity
        cheerzbox.position = CGPoint(x: frame.width / 2.5, y: frame.midY)
        cheerzbox.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        cheerzbox.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        cheerzbox.speed = 1.0
        cheerzbox.zRotation = 0.0

        // Remove all existing pipes
        pipes.removeAllChildren()

        // Reset _canRestart
        canRestart = false

        // Reset score
        score = 0
        scoreLabelNode.text = String(score)

        // Restart animation
        movingNode.speed = 1
    }
}
extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        if movingNode.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                onObstaclePassed()
            } else {
                stopCheerzbox()
                flashBackground()
            }
        }
    }

    private func onObstaclePassed() {
        score += 1
        scoreLabelNode.text = String(score)
        scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: TimeInterval(0.1)), SKAction.scale(to: 1.0, duration: TimeInterval(0.1))]))
    }

    private func stopCheerzbox() {
        movingNode.speed = 0

        cheerzbox.physicsBody?.collisionBitMask = worldCategory
        cheerzbox.run(SKAction.rotate(byAngle: CGFloat.pi * CGFloat(cheerzbox.position.y) * 0.01, duration: 0),
                 completion: {
                    self.cheerzbox.speed = 0
        })
    }

    func flashBackground() {
        self.removeAction(forKey: "flash")
        self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
            self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            }), SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                self.backgroundColor = self.skyColor
                }), SKAction.wait(forDuration: TimeInterval(0.05))]), count: 4), SKAction.run({
                    self.canRestart = true
                    })]), withKey: "flash")
    }
}
