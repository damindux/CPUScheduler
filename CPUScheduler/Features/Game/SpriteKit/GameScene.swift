//
//  GameScene.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SpriteKit

final class GameScene: SKScene {
  override func didMove(to view: SKView)
  {
    backgroundColor = .black
    
    let player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
    player.position = CGPoint(
      x: size.width / 2,
      y: size.height / 2
    )
    
    addChild(player)
  }
}
