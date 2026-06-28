//
//  SplashScreen.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//
import SwiftUI
import SpriteKit

// MARK: - Main Splash View
struct SplashView: View {
    @State private var isActive = false
    
    // Initialize the scene once natively; SpriteKit and SwiftUI will auto-scale it
    @State private var scene = SplashPhysicsScene()

    var body: some View {
        if isActive {
            ContentView()
        } else {
            GeometryReader { geometry in
                ZStack {
                    // White background on SwiftUI layer
                    Color(red: 0.96, green: 0.96, blue: 0.96)
                        .ignoresSafeArea()

                    SpriteView(scene: scene, options: [.allowsTransparency])
                        .ignoresSafeArea()
                        .onAppear {
                            // Forward safe area offsets.
                            // We don't need to pass the size here; scaleMode = .resizeFill handles it.
                            scene.safeAreaInsets = geometry.safeAreaInsets
                        }
                }
            }
            .onAppear {
                // Overall timer to move to ContentView
                DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - SpriteKit Physics Scene
class SplashPhysicsScene: SKScene {

    let itemImages = [
        "splash_shoe_1", "splash_shoe_2", "splash_shoe_3",
        "splash_shoe_4", "splash_shoe_5"
    ]

    private var cleanupTimer: Timer?
    private var didRunSequence = false

    // Update boundaries safely if safe area insets arrive late
    var safeAreaInsets: EdgeInsets = .init() {
        didSet {
            if size.width > 0 && size.height > 0 {
                setupBoundaries()
            }
        }
    }

    // MARK: - Init
    override init() {
        super.init(size: .zero) // Will be resized dynamically by the SpriteView
        self.scaleMode         = .resizeFill
        self.anchorPoint       = .zero
        self.backgroundColor   = .clear // Crucial: must be clear to see SwiftUI background
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
        self.physicsWorld.speed   = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Scene Size Changes
    // This is much safer than didMove because it guarantees we have a non-zero screen size
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        // Wait until SwiftUI gives us a real view frame instead of (0,0)
        guard size.width > 0 && size.height > 0 else { return }

        setupBoundaries()

        if !didRunSequence {
            didRunSequence = true
            runSequence()

            cleanupTimer = Timer.scheduledTimer(
                withTimeInterval: 0.5, repeats: true
            ) { [weak self] _ in self?.clampEscapedItems() }
        }
    }

    // MARK: - Sequence
    private func runSequence() {

        // Phase 1 — bottom items drop from top, pile at bottom
        let spawnBottom = SKAction.run { [weak self] in
            self?.spawnItem(zone: .bottom)
        }
        let phase1 = SKAction.repeat(
            SKAction.sequence([spawnBottom, SKAction.wait(forDuration: 0.20)]),
            count: 5
        )

        // Phase 2 — logo drops
        let dropLogo = SKAction.run { [weak self] in self?.spawnLogo() }

        // Phase 3 — top items rain down over logo
        let spawnTop = SKAction.run { [weak self] in
            self?.spawnItem(zone: .top)
        }
        let phase3 = SKAction.repeat(
            SKAction.sequence([spawnTop, SKAction.wait(forDuration: 0.18)]),
            count: 7
        )

        run(SKAction.sequence([
            phase1,
            SKAction.wait(forDuration: 0.8),
            dropLogo,
            SKAction.wait(forDuration: 1.2),
            phase3
        ]))
    }

    // MARK: - Spawn Logo
    private func spawnLogo() {
        guard let logoImage = UIImage(named: "app_logo") else {
            // Fallback — text label if image missing
            let label = SKLabelNode(text: "Carto")
            label.fontSize   = 48
            label.fontColor  = .black
            label.fontName   = "AvenirNext-Bold"
            label.name       = "logo"
            label.zPosition  = 10
            label.position   = CGPoint(x: size.width / 2, y: size.height + 60)
            
            if label.frame.size.width > 0 {
                label.physicsBody = SKPhysicsBody(
                    rectangleOf: CGSize(width: 200, height: 60)
                )
                label.physicsBody?.isDynamic      = true
                label.physicsBody?.mass           = 8.0
                label.physicsBody?.allowsRotation = false
                label.physicsBody?.linearDamping  = 0.6
                label.physicsBody?.restitution    = 0.1
                addChild(label)
            }
            return
        }

        let texture = SKTexture(image: logoImage)
        let sprite  = SKSpriteNode(texture: texture)

        let targetWidth: CGFloat = 220
        let scale = targetWidth / sprite.size.width
        sprite.size = CGSize(
            width:  sprite.size.width  * scale,
            height: sprite.size.height * scale
        )

        sprite.position  = CGPoint(x: size.width / 2, y: size.height + sprite.size.height + 20)
        sprite.name      = "logo"
        sprite.zPosition = 10

        if sprite.size.width > 0 && sprite.size.height > 0 {
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.restitution    = 0.1
            sprite.physicsBody?.friction       = 0.95
            sprite.physicsBody?.mass           = 8.0
            sprite.physicsBody?.linearDamping  = 0.6
            sprite.physicsBody?.angularDamping = 1.0
            sprite.physicsBody?.allowsRotation = false

            addChild(sprite)
        }
    }

    // MARK: - Spawn Item
    enum SpawnZone { case top, bottom }

    private func spawnItem(zone: SpawnZone) {
        guard let name = itemImages.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: name)
        
        // Use a safe fallback size for previews if the asset takes a moment to load
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
        
        // Crash prevention if screen is too narrow
        let randomX = minX < maxX ? CGFloat.random(in: minX...maxX) : size.width / 2

        let extraY: CGFloat = zone == .bottom
            ? CGFloat.random(in: 0...40)
            : CGFloat.random(in: 20...120)

        sprite.position  = CGPoint(x: randomX, y: size.height + halfH + extraY)
        sprite.zRotation = CGFloat.random(in: -0.5...0.5)
        sprite.name      = "item"

        if sprite.size.width > 0 && sprite.size.height > 0 {
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.restitution    = 0.20
            sprite.physicsBody?.friction       = 0.70
            sprite.physicsBody?.mass           = 1.0
            sprite.physicsBody?.linearDamping  = 0.25
            sprite.physicsBody?.angularDamping = 0.40
            sprite.physicsBody?.allowsRotation = true

            addChild(sprite)
        }
    }

    // MARK: - Boundaries
    func setupBoundaries() {
        ["floor", "leftWall", "rightWall"].forEach { childNode(withName: $0)?.removeFromParent() }

        let t: CGFloat = 50.0
        let floorY = safeAreaInsets.bottom + t / 2

        // Removed the "ceiling" node entirely so items can freely fall down onto the screen!
        
        addBoundary(
            name: "floor",
            size: CGSize(width: size.width * 3, height: t),
            pos:  CGPoint(x: size.width / 2, y: floorY),
            friction: 0.9, restitution: 0.15
        )
        addBoundary(
            name: "leftWall",
            size: CGSize(width: t, height: size.height * 3),
            pos:  CGPoint(x: -t / 2, y: size.height / 2)
        )
        addBoundary(
            name: "rightWall",
            size: CGSize(width: t, height: size.height * 3),
            pos:  CGPoint(x: size.width + t / 2, y: size.height / 2)
        )
    }

    private func addBoundary(
        name: String,
        size: CGSize,
        pos: CGPoint,
        friction: CGFloat = 0.6,
        restitution: CGFloat = 0.1
    ) {
        guard size.width > 0 && size.height > 0 else { return }
        
        let node = SKSpriteNode(color: .clear, size: size)
        node.name     = name
        node.position = pos
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic   = false
        node.physicsBody?.friction    = friction
        node.physicsBody?.restitution = restitution
        addChild(node)
    }

    // MARK: - Safety Net
    private func clampEscapedItems() {
        let floorY = safeAreaInsets.bottom + 50

        children.forEach { node in
            guard
                let sprite = node as? SKSpriteNode,
                sprite.name == "item" || sprite.name == "logo",
                sprite.position.y < floorY
            else { return }

            sprite.position.y               = floorY + sprite.size.height / 2 + 2
            sprite.physicsBody?.velocity    = .zero
            sprite.physicsBody?.angularVelocity = 0
        }
    }

    deinit { cleanupTimer?.invalidate() }
}

// MARK: - Preview
#Preview {
    GeometryReader { geometry in
        SpriteView(
            scene: {
                let scene = SplashPhysicsScene()
                scene.safeAreaInsets = geometry.safeAreaInsets
                return scene
            }(),
            options: [.allowsTransparency]
        )
        .ignoresSafeArea()
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
    }
}
