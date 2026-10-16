//
//  GameScene.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SpriteKit

// @todo: Create game view model
// @todo: add level details to game view model
// @todo: add the timers in game view model
final class GameScene : SKScene
{
  let rows = 2
  let columns = 2
  let cellWidth: CGFloat = 175
  let cellHeight: CGFloat = 120
  let cellSpacing: CGFloat = 10

  private let nodeList = HorizontalNodeList(
    size: CGSize(width: 320, height: 100)
  )

  func addIncomingTasks()
  {
    nodeList.position = CGPoint(x: frame.midX, y: frame.midY)    
    addChild(nodeList)
    
    let items: [SKNode] = (1...10).map { number in
      let node = SKShapeNode(
        rectOf: CGSize(width: 175, height: 120),
        cornerRadius: 8
      )
      
      node.strokeColor = .appBlue
      // @todo: figure out why there are no top and bottom borders
      node.lineWidth = 3

      let label = SKLabelNode(text: "\(number)")
      label.fontSize = 24
      //label.verticalAlignmentMode = .center
      node.addChild(label)
      // @todo: change the position of the incoming tasks
      // @todo: add labels inside CPU cores

      return node
    }

    nodeList.setItems(items, spacing: 10)
  }
    

  override func didMove(to view: SKView)
  {
    self.backgroundColor = .backgroundColor

    let stepX = cellWidth + cellSpacing
    let stepY = cellHeight + cellSpacing
    
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
        let square = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellHeight), cornerRadius: 8)
        let pattern: [CGFloat] = [8.0, 8.0]
        let dashed = square.path?.copy(dashingWithPhase: 1, lengths: pattern)
        
        let node = SKShapeNode(path: dashed!)
        
        node.position = CGPoint(
          x: origin.x + (CGFloat(col) + 0.5) * stepX,
          y: origin.y + (CGFloat(row) + 0.5) * stepY
        )
        node.strokeColor = .appGreen
        node.lineWidth = 3
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
      y: (size.height / 2) - (cellWidth + 30)
    )
    addChild(label)

    addIncomingTasks()
  }
  
  // @todo: Add functionality to drag and drop tasks into CPU cores
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    nodeList.handleTouchesBegan(touches)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    nodeList.handleTouchesMoved(touches)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    nodeList.handleTouchesEnded()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    nodeList.handleTouchesEnded()
  }
}
