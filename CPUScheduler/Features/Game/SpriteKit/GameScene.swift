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
  let cellWidth: CGFloat = 175
  let cellHeight: CGFloat = 120
  let cellSpacing: CGFloat = 10
  
  private let gameViewModel: GameViewModel
  
  init(gameViewModel: GameViewModel, size: CGSize)
  {
    self.gameViewModel = gameViewModel
    super.init(size: size)
  }
  
  // @info: Compiler asked me to implement this
  // because SKScene conforms to NSCoding
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let nodeList = HorizontalNodeList(size: CGSize(width: 320, height: 125))

  private func drawIncomingTasks(position: CGPoint)
  {
    nodeList.position = position
    addChild(nodeList)
    
    let items: Array<SKNode> = (1...10).map { number in
      let node = SKShapeNode(
        rectOf: CGSize(width: 175, height: 120),
        cornerRadius: 8
      )
      
      node.strokeColor = .appBlue
      node.lineWidth = 3

      let label = SKLabelNode(text: "\(number)")
      label.fontSize = 24
      label.verticalAlignmentMode = .center
      node.addChild(label)

      return node
    }

    nodeList.setItems(items, spacing: 10)
  }
   
  private func drawCPUCores()
  {
    // @todo: add labels inside CPU cores
    let stepX = cellWidth + cellSpacing
    let stepY = cellHeight + cellSpacing
    
    let gridWidth = CGFloat(columns) * stepX - cellSpacing
    let gridHeight = CGFloat(rows) * stepY - cellSpacing
    let origin = CGPoint(
      x: (size.width - gridWidth) / 2,
      y: (size.height - gridHeight) / 2,
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
          y: origin.y + (CGFloat(row) + 0.5) * stepY,
        )
        node.strokeColor = .appGreen
        node.lineWidth = 3
        node.name = "cell_\(row)_\(col)"
        addChild(node)
      }
    }
  }

  override func didMove(to view: SKView)
  {
    self.backgroundColor = .backgroundColor

    drawCPUCores()
    
    let incomingTasksTitleLabel = SKLabelNode(text: "Incoming Tasks")
    incomingTasksTitleLabel.fontName = "JetBrainsMonoRoman-Bold"
    incomingTasksTitleLabel.fontSize = 16
    incomingTasksTitleLabel.fontColor = .white
    let incomingTasksTitleLabelWidth = incomingTasksTitleLabel.calculateAccumulatedFrame().size.width
    incomingTasksTitleLabel.position = CGPoint(
      x:  incomingTasksTitleLabelWidth / 2 + 20,
      y: (size.height / 2) - (cellWidth + 30)
    )
    addChild(incomingTasksTitleLabel)

    drawIncomingTasks(position: CGPoint(
      x: incomingTasksTitleLabel.position.x,
      y: incomingTasksTitleLabel.position.y - 10,
    ))
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

// @todo: Add pause button
// @todo: Add pause menu
// @todo: render timer
