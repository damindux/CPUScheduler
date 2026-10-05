//
//  GameScene.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SpriteKit

final class GameScene : SKScene
{
  let rows = 2
  let columns = 2
  let cellSize: CGFloat = 175
  let cellSpacing: CGFloat = 10

  override func didMove(to view: SKView)
  {
    let stepX = cellSize + cellSpacing
    let stepY = cellSize + cellSpacing
    
    let gridWidth = CGFloat(columns) * stepX - cellSpacing
    let gridHeight = CGFloat(rows) * stepY - cellSpacing
    let origin = CGPoint(
      x: (size.width - gridWidth) / 2,
      y: (size.height - gridHeight) / 2
    )
    
    for row in 0..<rows
    {
      for col in 0..<columns
      {
        let node = SKShapeNode(rectOf: CGSize(width: cellSize, height: cellSize))
        node.position = CGPoint(
          x: origin.x + (CGFloat(col) + 0.5) * stepX,
          y: origin.y + (CGFloat(row) + 0.5) * stepY
        )
        node.fillColor = (row + col) % 2 == 0 ? .white : .lightGray
        node.strokeColor = .clear
        node.name = "cell_\(row)_\(col)"
        addChild(node)
      }
    }
    
    let label = SKLabelNode(text: "Incoming Tasks")
    label.fontName = "JetBrainsMonoRoman-Bold"
    label.fontSize = 16
    label.fontColor = .white
    let labelWidth = label.calculateAccumulatedFrame().size.width
    label.position = CGPoint(
      x:  labelWidth / 2 + 20,
      y: (size.height / 2) - (cellSize + 30)
    )
    addChild(label)
  }
}
