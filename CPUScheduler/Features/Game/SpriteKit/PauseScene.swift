//
//  PauseScene.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-27.
//

import SpriteKit

final
class PauseScene : SKNode
{
  private let sceneSize: CGSize
  
  var onResume: (() -> Void)?
  var onRestart: (() -> Void)?
  var onMainMenu: (() -> Void)?
  
  init(size: CGSize)
  {
    self.sceneSize = size
    super.init()

    name = "pause_menu"
    zPosition = 1000

    buildMenu()
  }
  
  // NOTE(dsd): compiler asked me to implement this because SKScene conforms to NSCoding
  required
  init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  private
  func buildMenu()
  {
    let center = CGPoint(
      x: sceneSize.width / 2,
      y: sceneSize.height / 2
    )
    
    //- dsd: dim background
    //
    let overlay = SKShapeNode(rect: CGRect(origin: .zero, size: sceneSize))
    
    overlay.fillColor = SKColor.gameOverlay
    overlay.strokeColor = .clear
    overlay.zPosition = 0
    
    addChild(overlay)
    
    //- dsd: main panel
    //
    let panelWidth = min(sceneSize.width - 48, 340)
    let panelHeight: CGFloat = 370
    
    let mainPanel = makeRect(
      size: CGSize(
        width: panelWidth,
        height: panelHeight
      ),
      fill: SKColor.gameBackground,
      border: SKColor.gameCyan,
      borderWidth: 2
    )
    
    mainPanel.position = center
    mainPanel.zPosition = 1
    
    addChild(mainPanel)
    
    //- dsd: header
    //
    addLabel(
      "SYSTEM PAUSED",
      position: CGPoint(
        x: center.x,
        y: center.y + 143
      ),
      size: 23,
      color: SKColor.gameText,
      alignment: .center
    )
    
    addDivider(
      x: center.x,
      y: center.y + 91,
      width: panelWidth - 40
    )
    
    //- dsd: status panel
    //
    let statusWidth = panelWidth - 40
    let statusHeight: CGFloat = 58
    
    let statusPanel = makeRect(
      size: CGSize(
        width: statusWidth,
        height: statusHeight
      ),
      fill: SKColor.gamePanel,
      border: SKColor.gameBorder
    )
    
    statusPanel.position = CGPoint(
      x: center.x,
      y: center.y + 48
    )
    
    statusPanel.zPosition = 2
    
    addChild(statusPanel)
    
    addLabel(
      "CPU STATUS",
      position: CGPoint(
        x: center.x - statusWidth / 2 + 12,
        y: center.y + 57
      ),
      size: 11,
      color: SKColor.gameSecondaryText
    )

    addLabel(
      "PAUSED",
      position: CGPoint(
        x: center.x + statusWidth / 2 - 12,
        y: center.y + 57
      ),
      size: 12,
      color: SKColor.gameCyan,
      alignment: .right
    )

    addLabel(
      "SIMULATION HALTED",
      position: CGPoint(
        x: center.x - statusWidth / 2 + 12,
        y: center.y + 35
      ),
      size: 10,
      color: SKColor.gameText
    )
    
    //- dsd: action buttons
    //
    let buttonWidth = panelWidth - 40
    let buttonHeight: CGFloat = 46
    
    makeButton(
      title: "▶  RESUME",
      position: CGPoint(
        x: center.x,
        y: center.y - 22
      ),
      size: CGSize(
        width: buttonWidth,
        height: buttonHeight
      ),
      fill: SKColor.gameCyan,
      border: SKColor.gameCyan,
      textColor: SKColor.gameBackground,
      name: "pause_resume"
    )

    makeButton(
      title: "↻  RESTART",
      position: CGPoint(
        x: center.x,
        y: center.y - 80
      ),
      size: CGSize(
        width: buttonWidth,
        height: buttonHeight
      ),
      fill: SKColor.gamePanel,
      border: SKColor.gameBorder,
      textColor: SKColor.gameText,
      name: "pause_restart"
    )

    makeButton(
      title: "←  MAIN MENU",
      position: CGPoint(
        x: center.x,
        y: center.y - 138
      ),
      size: CGSize(
        width: buttonWidth,
        height: buttonHeight
      ),
      fill: SKColor.gamePanel,
      border: SKColor.gameBorder,
      textColor: SKColor.gameSecondaryText,
      name: "pause_main_menu"
    )
  }
  
  //- dsd: components
  //
  private
  func makeRect(
    size: CGSize,
    fill: SKColor,
    border: SKColor,
    borderWidth: CGFloat = 1
  ) -> SKShapeNode
  {
    let node = SKShapeNode(
      rect: CGRect(
        x: -size.width / 2,
        y: -size.height / 2,
        width: size.width,
        height: size.height
      )
    )

    node.fillColor = fill
    node.strokeColor = border
    node.lineWidth = borderWidth

    return node
  }
  
  private
  func addLabel(
    _ text: String,
    position: CGPoint,
    size: CGFloat,
    color: SKColor,
    alignment: SKLabelHorizontalAlignmentMode = .left
  )
  {
    let label = SKLabelNode(text: text)

    label.fontName = "JetBrainsMonoRoman-Bold"
    label.fontSize = size
    label.fontColor = color
    label.horizontalAlignmentMode = alignment
    label.verticalAlignmentMode = .center
    label.position = position
    label.zPosition = 3

    addChild(label)
  }
  
  private
  func addDivider(
    x: CGFloat,
    y: CGFloat,
    width: CGFloat
  )
  {
    let line = SKShapeNode(
      rectOf: CGSize(
        width: width,
        height: 1
      )
    )

    line.position = CGPoint(x: x, y: y)
    line.fillColor = SKColor.gameBorder
    line.strokeColor = .clear
    line.zPosition = 2

    addChild(line)
  }
  
  private
  func makeButton(
    title: String,
    position: CGPoint,
    size: CGSize,
    fill: SKColor,
    border: SKColor,
    textColor: SKColor,
    name: String
  )
  {
    let button = makeRect(
      size: size,
      fill: fill,
      border: border
    )

    button.position = position
    button.name = name
    button.zPosition = 2

    addChild(button)

    let label = SKLabelNode(text: title)

    label.fontName = "JetBrainsMonoRoman-Bold"
    label.fontSize = 13
    label.fontColor = textColor
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center
    label.position = position
    label.name = name
    label.zPosition = 3

    addChild(label)
  }
  
  //- dsd: input
  //
  func handleTouch(at location: CGPoint)
  {
    let touchedNodes = nodes(at: location)
      .sorted { $0.zPosition > $1.zPosition }

    for node in touchedNodes
    {
      guard let name = node.name else { continue }

      switch name
      {
      case "pause_resume": onResume?()
      case "pause_restart": onRestart?()
      case "pause_main_menu": onMainMenu?()
      default: continue
      }

      return
    }
  }

}
