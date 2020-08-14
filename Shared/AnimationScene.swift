//
//  AnimationScene.swift
//  Mod7 Generator
//
//  Created by Jon Alaniz on 8/13/20.
//

import SpriteKit

class AnimationScene: SKScene {
    override func didMove(to view: SKView) {
        #if os(macOS)
        backgroundColor = .controlBackgroundColor
        #else
        backgroundColor = .systemBackground
        #endif
        
        let background = SKEmitterNode(fileNamed: "bokeh")!
        background.zPosition = -1
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let label = SKLabelNode(text: "Win95/Office97")
        let label2 = SKLabelNode(text: "Key Generator")
        
        
        label.fontSize = 64
        label2.fontSize = 64
        label.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        label2.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        
        addChild(background)
        addChild(label)
        addChild(label2)
    }
}
