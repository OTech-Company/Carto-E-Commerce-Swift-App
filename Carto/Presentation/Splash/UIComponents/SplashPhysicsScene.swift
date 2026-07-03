//
//  SplashPhysicsScene.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//
import SpriteKit
import SwiftUI

class SplashPhysicsScene: SKScene {

    let itemImages = [
        "splash_shoe_1", "splash_shoe_2", "splash_shoe_3",
        "splash_shoe_4", "splash_shoe_5"
    ]

    private var cleanupTimer: Timer?
    private var didRunSequence = false

    var safeAreaInsets: EdgeInsets = .init() {
        didSet {
            if size.width > 0 && size.height > 0 {
                setupBoundaries()
            }
        }
    }

    override init() {
        super.init(size: .zero)
        self.scaleMode         = .resizeFill
        self.anchorPoint       = .zero
        self.backgroundColor   = .clear
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        self.physicsWorld.speed   = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        guard size.width > 0 && size.height > 0 else { return }

        setupBoundaries()

        if !didRunSequence {
            didRunSequence = true
            runSequence()

            // Memory management: clean up nodes that have fallen completely off the bottom
            cleanupTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0, repeats: true
            ) { [weak self] _ in self?.removeOffscreenItems() }
        }
    }
    
    deinit {
        cleanupTimer?.invalidate()
    }

    private func runSequence() {
        // Continuously rain items from the top
        let spawnTop = SKAction.run { [weak self] in self?.spawnItem() }
        
        // Drop items steadily over the splash screen duration
        let rainSequence = SKAction.repeat(
            SKAction.sequence([spawnTop, SKAction.wait(forDuration: 0.25)]),
            count: 30
        )

        run(rainSequence)
    }

    private func spawnItem() {
        guard let name = itemImages.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: name)
        
        if sprite.size.width == 0 || sprite.size.height == 0 {
            sprite.size = CGSize(width: 80, height: 80)
        }

        let maxDimension: CGFloat = 120.0
        let biggest = max(sprite.size.width, sprite.size.height)
        if biggest > 0 {
            sprite.setScale(min(maxDimension / biggest, 1.0))
        }

        let halfW   = sprite.size.width  / 2
        let halfH   = sprite.size.height / 2
        let minX    = halfW + 16
        let maxX    = size.width - halfW - 16
        let randomX = minX < maxX ? CGFloat.random(in: minX...maxX) : size.width / 2

        // Start items well above the visible screen so they fall into view naturally
        let startY = size.height + halfH + CGFloat.random(in: 20...150)

        sprite.position  = CGPoint(x: randomX, y: startY)
        sprite.zRotation = CGFloat.random(in: -0.5...0.5)
        sprite.name      = "item"

        if sprite.size.width > 0 && sprite.size.height > 0 {
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.restitution    = 0.20
            sprite.physicsBody?.friction       = 0.70
            sprite.physicsBody?.mass           = 1.0
            sprite.physicsBody?.allowsRotation = true
            addChild(sprite)
        }
    }

    private func setupBoundaries() {
        ["leftWall", "rightWall"].forEach { childNode(withName: $0)?.removeFromParent() }

        let t: CGFloat = 50.0
        
        // ⚠️ THE FLOOR BOUNDARY HAS BEEN REMOVED HERE ⚠️
        // Items will now fall freely out of the bottom of the screen.

        // We keep the side walls so items don't fly out the left/right sides
        addBoundary(name: "leftWall", size: CGSize(width: t, height: size.height * 3), pos: CGPoint(x: -t / 2, y: size.height / 2))
        addBoundary(name: "rightWall", size: CGSize(width: t, height: size.height * 3), pos: CGPoint(x: size.width + t / 2, y: size.height / 2))
    }

    private func addBoundary(name: String, size: CGSize, pos: CGPoint) {
        guard size.width > 0 && size.height > 0 else { return }
        
        let node = SKSpriteNode(color: .clear, size: size)
        node.name     = name
        node.position = pos
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic   = false
        node.physicsBody?.friction    = 0.6
        node.physicsBody?.restitution = 0.1
        addChild(node)
    }

    private func removeOffscreenItems() {
        // Find nodes that have fallen completely out of view (y < -200) and destroy them
        children.forEach { node in
            if node.position.y < -200 {
                node.removeFromParent()
            }
        }
    }
}
