//
//  HorizontalNodeList.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-16.
//

import SpriteKit

// Need to add mouse support for macOS
final class HorizontalNodeList : SKNode
{  
  private let viewportSize: CGSize
  private let cropNode = SKCropNode()
  private let contentNode = SKNode()

  private var lastTouchX: CGFloat = 0
  private var isDragging = false

  private var minOffsetX: CGFloat = 0

  init(size: CGSize)
  {
    self.viewportSize = size
    super.init()

    let mask = SKSpriteNode(color: .white, size: size)
    cropNode.maskNode = mask

    mask.position = .zero
    cropNode.addChild(contentNode)
    addChild(cropNode)
  }

  required init?(coder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }

  func setItems(_ items: [SKNode], spacing: CGFloat)
  {
    contentNode.removeAllChildren()

    var x: CGFloat = 0

    for item in items
    {
      item.position = CGPoint(x: x, y: 0)
      contentNode.addChild(item)

      x += item.frame.width + spacing
    }

    let contentWidth = max(0, x - spacing)
    minOffsetX = min(0, viewportSize.width / 2 - contentWidth)

    contentNode.position.x = max(
      min(0, contentNode.position.x),
      minOffsetX
    )
  }

  func handleTouchesBegan(_ touches: Set<UITouch>)
  {
    guard let touch = touches.first else { return }
    lastTouchX - touch.location(in: self).x
    isDragging = true
  }

  func handleTouchesMoved(_ touches: Set<UITouch>)
  {
    guard isDragging, let touch = touches.first else { return }

    let currentX = touch.location(in: self).x
    let deltaX = currentX - lastTouchX
    lastTouchX = currentX

    contentNode.position.x = min(
      0,
      max(minOffsetX, contentNode.position.x + deltaX)
    )
  }

  func handleTouchesEnded()
  {
    isDragging = false
  }
}
