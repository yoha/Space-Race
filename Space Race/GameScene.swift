//
//  GameScene.swift
//  Space Race
//
//  Created by Yohannes Wijaya on 10/4/15.
//  Copyright (c) 2015 Yohannes Wijaya. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Stored Properties
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var gameTimer: NSTimer!
    
    var gameOver = false
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    
    // MARK: - Property Observers
    
    var score: Int = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: - Methods Override
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: "createEnemy", userInfo: nil, repeats: true)
        
        self.backgroundColor = UIColor.blackColor()
        
        self.starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        self.starfield.position = CGPoint(x: 1024, y: 384)
        self.starfield.advanceSimulationTime(10)
        self.starfield.zPosition = -1
        self.addChild(self.starfield)
        
        self.player = SKSpriteNode(imageNamed: "player")
        self.player.position = CGPoint(x: 100, y: 384)
        self.player.physicsBody = SKPhysicsBody(texture: self.player.texture!, size: self.player.size)
        self.player.physicsBody!.contactTestBitMask = 1
        self.addChild(self.player)
        
        self.scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        self.scoreLabel.position = CGPoint(x: 16, y: 16)
        self.scoreLabel.horizontalAlignmentMode = .Left
        self.addChild(self.scoreLabel)
        
        self.score = 0
     
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        var touchLocation = touch.locationInNode(self)
        
        if touchLocation.y < 100 { touchLocation.y = 100 }
        else if touchLocation.y > 668 { touchLocation.y = 668 }
        
        self.player.position = touchLocation
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        for node in self.children {
            if node.position.x < -300 { node.removeFromParent() }
        }
        
        if !gameOver { ++self.score }
    }
    
    // MARK: - Local Methods
    
    func didBeginContact(contact: SKPhysicsContact) {
        let explosionEmitterNode = SKEmitterNode(fileNamed: "explosion.sks")!
        explosionEmitterNode.position = self.player.position
        self.addChild(explosionEmitterNode)
        
        self.player.removeFromParent()

        self.gameOver = true
    }
    
    func createEnemy() {
        self.possibleEnemies.shuffle()
        
        let spriteNode = SKSpriteNode(imageNamed: self.possibleEnemies.first!)
        spriteNode.position = CGPoint(x: 1200, y: RandomInt(50, max: 736))
        self.addChild(spriteNode)
        
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture!, size: spriteNode.size)
        spriteNode.physicsBody?.categoryBitMask = 1
        spriteNode.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        spriteNode.physicsBody?.angularVelocity = 5
        spriteNode.physicsBody?.angularDamping = 0
        spriteNode.physicsBody?.linearDamping = 0
    }
}
