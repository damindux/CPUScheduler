//
//  GameScene.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SpriteKit

// TODO(dsd): create pause menu
// TODO(dsd): create the levels
// TODO(dsd): finish the game loop
// TODO(dsd): find what is zPosition
// TODO(dsd): add functionality to pause menu

final
class GameScene : SKScene
{
  private
  struct TaskCardData
  {
    let name: String
    let subtitle: String
    let tag: String
    let memory: String
    let status: String
    let color: SKColor
    let taskID: Int
  }

  //- dsd: configuration
  let rows = 2
  let columns = 2
  
  let cellWidth: CGFloat = 175
  let cellHeight: CGFloat = 120
  let cellSpacing: CGFloat = 10
  
  private let gameViewModel: GameViewModel
  private var pauseMenu: PauseScene?
  var onMainMenu: (() -> Void)?
  
  private let monoFont = "JetBrainsMonoRoman-Bold"
  private let regularFont = "JetBrainsMonoRoman-Regular"
  
  private var scaleFactor: CGFloat {
    min(size.width / 390, size.height / 844)
  }
  
  private var unit: CGFloat {
    scaleFactor
  }
  
  init(gameViewModel: GameViewModel, size: CGSize)
  {
    self.gameViewModel = gameViewModel
    super.init(size: size)
  }
  
  // NOTE(dsd): compiler asked me to implement this because SKScene conforms to NSCoding
  required
  init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var nodeList: HorizontalNodeList?
  private var draggedTask: SKNode?
  private var draggedTaskOffset = CGPoint.zero
  private weak var draggedTaskParent: SKNode?
  private var draggedTaskOriginalPosition = CGPoint.zero

  //- dsd: scene lifecycle
  override
  func didMove(to view: SKView)
  {
    self.backgroundColor = SKColor.gameBackground
    
    removeAllChildren()

    drawHeader()
    drawCPUCores()
    drawRAMPool()
    drawIncomingTasks()
  }
  
  //- dsd: drawing helpers
  //
  @discardableResult
  private
  func addPanel(
    position: CGPoint,
    size: CGSize,
    fill: SKColor,
    border: SKColor,
    borderWidth: CGFloat = 1.5,
    dashed: Bool = false
  ) -> SKShapeNode
  {
    let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
    
    let node: SKShapeNode
    
    if dashed
    {
      let path = CGPath(rect: rect, transform: nil)
      let dashedPath = path.copy(dashingWithPhase: 0, lengths: [6 * unit, 5 * unit])
      
      node = SKShapeNode(path: dashedPath)
    }
    else
    {
      node = SKShapeNode(rect: rect)
    }
    
    node.position = position
    node.fillColor = dashed ? .clear : fill
    node.strokeColor = border
    node.lineWidth = borderWidth * unit
    
    addChild(node)
    return node
  }
  
  @discardableResult
  private
  func addLabel(
    _ text: String,
    position: CGPoint,
    fontSize: CGFloat,
    color: SKColor,
    font: String? = nil,
    alignment: SKLabelHorizontalAlignmentMode = .left
  ) -> SKLabelNode
  {
    let label = SKLabelNode(text: text)
    
    label.fontName = font ?? monoFont
    label.fontSize = fontSize * unit
    label.fontColor = color
    label.horizontalAlignmentMode = alignment
    label.verticalAlignmentMode = .center
    label.position = position
    
    addChild(label)
    return label
  }
  
  private
  func addDivider(y: CGFloat)
  {
    let line = SKShapeNode(
      rectOf: CGSize(
        width: size.width - 32 * unit,
        height: 1 * unit
      )
    )
    
    line.position = CGPoint(
      x: size.width / 2,
      y: y
    )
    
    line.fillColor = .white.withAlphaComponent(0.08)
    line.strokeColor = .clear
    
    addChild(line)
  }
  
  private
  func addProgressBar(
    position: CGPoint,
    width: CGFloat,
    progress: CGFloat,
    color: SKColor
  )
  {
    let height = 6 * unit

    addPanel(
      position: position,
      size: CGSize(width: width, height: height),
      fill: SKColor(red: 0.025, green: 0.035, blue: 0.05, alpha: 1),
      border: SKColor(red: 0.12, green: 0.22, blue: 0.29, alpha: 1),
      borderWidth: 1
    )

    let fillWidth = max(0, (width - 2 * unit) * progress)

    if fillWidth > 0
    {
      let fill = SKShapeNode(
        rect: CGRect(
          x: 0,
          y: 0,
          width: fillWidth,
          height: height - 2 * unit
        )
      )

      fill.position = CGPoint(
        x: position.x - width / 2 + unit,
        y: position.y - height / 2 + unit
      )

      fill.fillColor = color
      fill.strokeColor = .clear

      addChild(fill)
    }
  }
  
  //- dsd: header
  //
  private
  func drawHeader()
  {
    let top = size.height
    
    let left = 24 * unit
    let right = size.width - 24 * unit
    
    let headerY = top - 70 * unit
    
    // dsd: pause button
    addPanel(
      position: CGPoint(x: left + 12 * unit, y: headerY),
      size: CGSize(width: 40 * unit, height: 40 * unit),
      fill: SKColor.gamePanel,
      border: SKColor.white.withAlphaComponent(0.10)
    )
    
    addLabel(
      "Ⅱ",
      position: CGPoint(x: left + 12 * unit, y: headerY),
      fontSize: 22,
      color: SKColor.gameCyan,
      alignment: .center
    )
    
    // TODO(dsd): need to add the real level name
    addLabel(
      "DATABASE RUSH",
      position: CGPoint(x: left + 54 * unit, y: headerY),
      fontSize: 17,
      color: .white
    )
    
    // dsd: countdown timer
    let timerWidth = 108 * unit
    let timerHeight = 42 * unit
    
    addPanel(
      position: CGPoint(
        x: right - timerWidth / 2,
        y: headerY
      ),
      size: CGSize(width: timerWidth, height: timerHeight),
      fill: SKColor(red: 0.025, green: 0.035, blue: 0.05, alpha: 1),
      border: SKColor.gameRed,
      borderWidth: 1
    )
    
    addLabel(
      "◴",
      position: CGPoint(
        x: right - timerWidth + 13 * unit,
        y: headerY
      ),
      fontSize: 21,
      color: SKColor.gameCyan
    )

    // TODO(dsd): need to show the real timer here
    #warning("Placeholder")
    addLabel(
      "00",
      position: CGPoint(
        x: right - 76 * unit,
        y: headerY
      ),
      fontSize: 19,
      color: .white
    )

    addLabel(
      ":",
      position: CGPoint(
        x: right - 49 * unit,
        y: headerY
      ),
      fontSize: 19,
      color: SKColor.gameCyan
    )

    #warning("Placeholder")
    addLabel(
      "30",
      position: CGPoint(
        x: right - 36 * unit,
        y: headerY
      ),
      fontSize: 19,
      color: SKColor.gameRed
    )
    
    addDivider(y: headerY - 29 * unit)
    
    // dsd: score
    let scoreY = headerY - 48 * unit

    addLabel(
      "♜",
      position: CGPoint(x: left, y: scoreY),
      fontSize: 20,
      color: SKColor.gameYellow
    )

    addLabel(
      "SCORE:",
      position: CGPoint(x: left + 19 * unit, y: scoreY),
      fontSize: 14,
      color: SKColor.gameSecondaryText
    )

    #warning("Placeholder")
    // TODO(dsd): need to add real score
    addLabel(
      "5,350",
      position: CGPoint(x: left + 72 * unit, y: scoreY),
      fontSize: 20,
      color: SKColor.gameYellow
    )
    
    // dsd: active cores badge
    let badgeWidth = 80 * unit

    addPanel(
      position: CGPoint(
        x: right - badgeWidth / 2,
        y: scoreY
      ),
      size: CGSize(width: badgeWidth, height: 23 * unit),
      fill: SKColor.gamePanel,
      border: SKColor.white.withAlphaComponent(0.10)
    )

    #warning("Placeholder")
    // TODO(dsd): need the real count of active cores
    addLabel(
      "3/4 CORES",
      position: CGPoint(
        x: right - badgeWidth / 2,
        y: scoreY
      ),
      fontSize: 12,
      color: SKColor.gameSecondaryText,
      alignment: .center
    )

    addDivider(y: scoreY - 25 * unit)
  }
  
  //- dsd: CPU cores
  private
  func drawCPUCores()
  {
    let sectionTop = size.height - 178 * unit
    
    addLabel(
      "▦ CPU CORES",
      position: CGPoint(
        x: 18 * unit,
        y: sectionTop
      ),
      fontSize: 15,
      color: .white
    )
    
    // TODO(dsd): need to add functionality to this
    // if this is not simple, just remove this
    #warning("Not implemented")
    addLabel(
      "↻ AUTO-SCHEDULE",
      position: CGPoint(
        x: size.width - 18 * unit,
        y: sectionTop
      ),
      fontSize: 12,
      color: SKColor(red: 0.08, green: 0.72, blue: 0.83, alpha: 1),
      alignment: .right
    )
    
    let horizontalPadding = 16 * unit
    let spacing = 12 * unit
    
    let cardWidth = (
      size.width - 2 * horizontalPadding - spacing
    ) / 2
    
    let cardHeight = 104 * unit
    
    // Keep the first row below the section labels with a clear vertical gap.
    let firstY = sectionTop - 15 * unit - cardHeight / 2
    let secondY = firstY - cardHeight - spacing
    
    let firstX = horizontalPadding + cardWidth / 2
    let secondX = firstX + cardWidth + spacing
    
    #warning("Placeholder")
    // TODO(dsd): draw the cpu cores according to the actual states
    // TODO(dsd): should show the correct information for the tasks
    // TODO(dsd): should be able to change the number of CPU cores
    drawCore(
      number: 1,
      task: "Task 1",
      memory: "1.2 GB",
      progress: 0.50,
      color: SKColor.gameCyan,
      position: CGPoint(x: firstX, y: firstY),
      cardSize: CGSize(width: cardWidth, height: cardHeight)
    )
    
    drawCore(
      number: 2,
      task: "Task 2",
      memory: "800 MB",
      progress: 0.43,
      color: SKColor.gameCyan,
      position: CGPoint(x: secondX, y: firstY),
      cardSize: CGSize(width: cardWidth, height: cardHeight)
    )
    
    drawCore(
      number: 3,
      task: "Task 3",
      memory: "512 MB",
      progress: 0.38,
      color: SKColor.gamePurple,
      position: CGPoint(x: firstX, y: secondY),
      cardSize: CGSize(width: cardWidth, height: cardHeight)
    )
    
    drawEmptyCore(
      position: CGPoint(x: secondX, y: secondY),
      cardSize: CGSize(width: cardWidth, height: cardHeight)
    )
  }
  
  // TODO(dsd): take this parameters from a task instead of
  // separate like this.
  private
  func drawCore(
    number: Int32,
    task: String,
    memory: String,
    progress: CGFloat,
    color: SKColor,
    position: CGPoint,
    cardSize: CGSize
  )
  {
    let halfWidth = cardSize.width / 2
    let halfHeight = cardSize.height / 2
    
    let card = addPanel(
      position: position,
      size: cardSize,
      fill: SKColor.gamePanel,
      border: color.withAlphaComponent(0.55),
      borderWidth:  2
    )
    
    card.name = "core_\(number)"
    
    let left = position.x - halfWidth + 12 * unit
    let right = position.x + halfWidth - 12 * unit
    let top = position.y + halfHeight
    
    // dsd: core indicator
    let dot = SKShapeNode(circleOfRadius: 3 * unit)

    dot.position = CGPoint(
      x: left + 3 * unit,
      y: top - 21 * unit
    )
    
    dot.fillColor = color
    dot.strokeColor = .clear
    
    addChild(dot)
    
    addLabel(
      "CORE \(number)",
      position: CGPoint(
        x: left + 10 * unit,
        y: top - 21 * unit
      ),
      fontSize: 11,
      color: color
    )
    
    // dsd: memory badge
    let memoryWidth = memory.count > 5 ? 48 : 42
    
    addPanel(
      position: CGPoint(
        x: right - CGFloat(memoryWidth) * unit / 2,
        y: top - 21 * unit
      ),
      size: CGSize(
        width: CGFloat(memoryWidth) * unit,
        height: 20 * unit
      ),
      fill: color.withAlphaComponent(0.08),
      border: color.withAlphaComponent(0.35),
      borderWidth: 1
    )
    
    addLabel(
      memory,
      position: CGPoint(
        x: right - CGFloat(memoryWidth) * unit / 2,
        y: top - 21 * unit
      ),
      fontSize: 10,
      color: color,
      alignment: .center
    )
    
    // dsd: task and utilization
    addLabel(
      task,
      position: CGPoint(
        x: left,
        y: top - 45 * unit
      ),
      fontSize: 15,
      color: .white,
      font: monoFont
    )
    
    #warning("Placeholder")
    // TODO(dsd): add real progress here
    addLabel(
      "\(Int(progress * 100))%",
      position: CGPoint(
        x: right,
        y: top - 45 * unit
      ),
      fontSize: 11,
      color: color,
      alignment: .right
    )
    
    // dsd: utilization bar
    addProgressBar(
      position: CGPoint(
        x: position.x,
        y: top - 61 * unit
      ),
      width: cardSize.width - 24 * unit,
      progress: progress,
      color: color
    )
    
    // dsd: preempt button
    let buttonWidth = cardSize.width - 24 * unit
    let buttonY = position.y - halfHeight + 21 * unit

    let button = addPanel(
      position: CGPoint(
        x: position.x,
        y: buttonY
      ),
      size: CGSize(
        width: buttonWidth,
        height: 23 * unit
      ),
      fill: SKColor.gameRed,
      border: SKColor(
        red: 1.0, green: 0.25, blue: 0.35, alpha: 1
      ),
      borderWidth: 1
    )

    button.name = "preempt_\(number)"

    // TODO(dsd): add functionality to this button
    addLabel(
      "PREEMPT",
      position: CGPoint(
        x: position.x,
        y: buttonY
      ),
      fontSize: 11,
      color: .white,
      alignment: .center
    ).name = "preempt_\(number)"
  }
  
  private
  func drawEmptyCore(position: CGPoint, cardSize: CGSize)
  {
    let card = addPanel(
      position: position,
      size: cardSize,
      fill: SKColor(red: 0.035, green: 0.075, blue: 0.085, alpha: 1),
      border: SKColor.gameGreen,
      borderWidth: 2,
      dashed: true
    )

    card.name = "empty_core"

    // Dashed border with a separate transparent hit target
    let hitTarget = SKShapeNode(
      rectOf: cardSize
    )

    hitTarget.position = position
    hitTarget.fillColor = .clear
    hitTarget.strokeColor = .clear
    hitTarget.name = "queue_to_core"

    addChild(hitTarget)

    let top = position.y + cardSize.height / 2

    // TODO(dsd): This is hard coded at the momemt.
    // Need to change it.
    #warning("Placeholder")
    addLabel(
      "● CORE 4",
      position: CGPoint(
        x: position.x - cardSize.width / 2 + 12 * unit,
        y: top - 21 * unit
      ),
      fontSize: 11,
      color: SKColor.gameGreen
    )

    let plus = addLabel(
      "+",
      position: CGPoint(
        x: position.x,
        y: position.y + 2 * unit
      ),
      fontSize: 27,
      color: SKColor.gameGreen,
      alignment: .center
    )

    plus.fontName = monoFont

    let circle = SKShapeNode(
      circleOfRadius: 14 * unit
    )

    circle.position = CGPoint(
      x: position.x,
      y: position.y + 5 * unit
    )

    circle.fillColor = .clear
    circle.strokeColor = SKColor.gameGreen
    circle.lineWidth = 1.2 * unit
    circle.name = "queue_to_core"

    addChild(circle)

    addLabel(
      "TAP QUEUE",
      position: CGPoint(
        x: position.x,
        y: position.y - 20 * unit
      ),
      fontSize: 11,
      color: SKColor.gameGreen,
      alignment: .center
    )
  }
  
  //- dsd: RAM pool
  #warning("Placeholder")
  // TODO(dsd): need to change it to work with real values
  private
  func drawRAMPool()
  {
    let centerY = size.height - 510 * unit
    let width = size.width - 32 * unit
    let height = 72 * unit

    addPanel(
      position: CGPoint(
        x: size.width / 2,
        y: centerY
      ),
      size: CGSize(width: width, height: height),
      fill: SKColor.gamePanel,
      border: SKColor.gameCyan.withAlphaComponent(0.4),
      borderWidth: 1
    )

    let left = 28 * unit
    let right = size.width - 28 * unit

    let titleY = centerY + 21 * unit

    addLabel(
      "▦ RAM POOL",
      position: CGPoint(x: left, y: titleY),
      fontSize: 13,
      color: .white
    )

    addLabel(
      "6.2 / 8.0 GB",
      position: CGPoint(x: right, y: titleY),
      fontSize: 14,
      color: SKColor.gameCyan,
      alignment: .right
    )

    addProgressBar(
      position: CGPoint(
        x: size.width / 2,
        y: centerY
      ),
      width: width - 22 * unit,
      progress: 0.775,
      color: SKColor.gameCyan
    )

    addLabel(
      "● ALLOCATED",
      position: CGPoint(
        x: left,
        y: centerY - 16 * unit
      ),
      fontSize: 10,
      color: SKColor.gameSecondaryText
    )

    addLabel(
      "78% IN USE",
      position: CGPoint(
        x: right,
        y: centerY - 16 * unit
      ),
      fontSize: 10,
      color: SKColor.gameCyan,
      alignment: .right
    )
  }
  
  //- dsd: incoming queue
  private
  func drawIncomingTasks()
  {
    let headingY = size.height - 585 * unit

    addLabel(
      "▤ INCOMING QUEUE",
      position: CGPoint(
        x: 18 * unit,
        y: headingY
      ),
      fontSize: 14,
      color: .white
    )

    addLabel(
      "TAP TASK TO DISPATCH",
      position: CGPoint(
        x: size.width - 18 * unit,
        y: headingY
      ),
      fontSize: 10,
      color: SKColor.gameSecondaryText,
      alignment: .right
    )

    // TODO(dsd): hard coded at the moment.
    // need to make it work according to tasks in a level
    #warning("Placeholder")
    let tasks = [
      TaskCardData(
      name: "Task 4",
      subtitle: "Snapshot worker",
      tag: "⚡ URGENT",
      memory: "640 MB",
      status: "EXPIRING",
      color: SKColor.gameYellow,
      taskID: 4
      ),
      TaskCardData(
      name: "Task 5",
      subtitle: "Disk sink cache",
      tag: "NORMAL",
      memory: "256 MB",
      status: "8.0s",
      color: SKColor.gameGreen,
      taskID: 5
      ),
      TaskCardData(
      name: "Stream Sync",
      subtitle: "Waitlist queue #3",
      tag: "BATCH",
      memory: "1.5 GB",
      status: "15s",
      color: SKColor.gamePurple,
      taskID: 6
      ),
      TaskCardData(
      name: "Log Drain",
      subtitle: "Telemetry pipeline",
      tag: "ASYNC",
      memory: "128 MB",
      status: "22s",
      color: SKColor.gameCyan,
      taskID: 7
      )
    ]

    let viewportSize = CGSize(width: size.width - 32 * unit, height: 100 * unit)
    let list = HorizontalNodeList(size: viewportSize)
    list.position = CGPoint(x: size.width / 2, y: headingY - 76 * unit)
    nodeList = list
    addChild(list)

    let cardSize = CGSize(width: 260 * unit, height: 88 * unit)
    let items = tasks.map { makeTaskCard($0, size: cardSize) }
    list.setItems(items, spacing: 10 * unit)
  }

  private
  func makeTaskCard(_ task: TaskCardData, size cardSize: CGSize) -> SKNode
  {
    let container = SKNode()
    let rect = CGRect(x: -cardSize.width / 2, y: -cardSize.height / 2,
                      width: cardSize.width, height: cardSize.height)
    let card = SKShapeNode(rect: rect)
    card.fillColor = SKColor.gamePanel
    card.strokeColor = task.color.withAlphaComponent(0.65)
    card.lineWidth = unit
    card.name = "task_\(task.taskID)"
    container.addChild(card)

    let left = -cardSize.width / 2 + 10 * unit
    let right = cardSize.width / 2 - 10 * unit
    let top = cardSize.height / 2

    // dsd: task type badge
    let tagWidth = min(
      CGFloat(task.tag.count * 7 + 14) * unit,
      cardSize.width * 0.53
    )
    addTaskCardBadge(task.tag, color: task.color, width: tagWidth,
                     position: CGPoint(x: left + tagWidth / 2, y: top - 16 * unit),
                     to: container)

    // dsd: memory badge
    let memoryWidth = 52 * unit
    addTaskCardBadge(task.memory, color: task.color, width: memoryWidth,
                     position: CGPoint(x: right - memoryWidth / 2, y: top - 16 * unit),
                     to: container)

    // dsd: task title
    addTaskCardLabel(task.name, at: CGPoint(x: left, y: top - 37 * unit),
                     size: 13, color: .white, font: monoFont, to: container)

    // dsd: status
    addTaskCardLabel(task.status, at: CGPoint(x: right, y: top - 37 * unit),
                     size: 10, color: task.taskID == 4 ? SKColor.gameRed : SKColor.gameSecondaryText,
                     alignment: .right, to: container)

    // dsd: description
    addTaskCardLabel(task.subtitle, at: CGPoint(x: left, y: -cardSize.height / 2 + 14 * unit),
                     size: 10, color: SKColor.gameSecondaryText, font: regularFont,
                     to: container, name: "task_\(task.taskID)")

    return container
  }

  private
  func addTaskCardBadge(
    _ text: String,
    color: SKColor,
    width: CGFloat,
    position: CGPoint,
    to parent: SKNode
  )
  {
    let badge = SKShapeNode(rectOf: CGSize(width: width, height: 19 * unit))
    badge.position = position
    badge.fillColor = color.withAlphaComponent(0.12)
    badge.strokeColor = color.withAlphaComponent(0.65)
    badge.lineWidth = unit
    parent.addChild(badge)
    addTaskCardLabel(text, at: position, size: 10, color: color,
                     alignment: .center, to: parent)
  }

  private
  func addTaskCardLabel(
    _ text: String,
    at position: CGPoint,
    size: CGFloat,
    color: SKColor,
    font: String? = nil,
    alignment: SKLabelHorizontalAlignmentMode = .left,
    to parent: SKNode,
    name: String? = nil
  )
  {
    let label = SKLabelNode(text: text)
    label.fontName = font ?? monoFont
    label.fontSize = size * unit
    label.fontColor = color
    label.horizontalAlignmentMode = alignment
    label.verticalAlignmentMode = .center
    label.position = position
    label.name = name
    parent.addChild(label)
  }
  
  //- dsd: handle pause menu
  private
  func showPauseMenu()
  {
    guard pauseMenu == nil else { return }
    
    // dsd: pause the game simulation
    isPaused = true
    
    let menu = PauseScene(size: size)
    
    // dsd: keep the overlay visible when the scene is paused
    menu.isPaused = false
    
    menu.onResume = { [weak self, weak menu] in
      guard let self else { return }
      
      menu?.removeFromParent()
      self.pauseMenu = nil
      self.isPaused = false
    }
    
    menu.onRestart = { [weak self, weak menu] in
      guard let self else { return }
      
      menu?.removeFromParent()
      self.pauseMenu = nil
      self.isPaused = false
      
      // TODO(dsd): restart implementation goes here
    }
    
    menu.onMainMenu = { [weak self] in
      guard let self else { return }
      self.pauseMenu?.removeFromParent()
      self.pauseMenu = nil
      self.isPaused = false
      self.onMainMenu?()
    }
    
    pauseMenu = menu
    addChild(menu)
  }
  
  //- dsd: input
  
  // TODO(dsd): cannot scroll the task queue it triggers a drag and drop one
  // so instead make the left and right swipe to scroll the queue and
  // swipe up to take the task from the queue. if the task is not drag to
  // a CPU core, the task should go back to the queue.
  
  override
  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    guard let touch = touches.first else { return }
    
    let location = touch.location(in: self)
    let hitNodes = nodes(at: location)
    nodeList?.handleTouchesBegan(touches)
    
    if let pauseMenu
    {
      pauseMenu.handleTouch(at: location)
      return
    }
    
    for node in nodes(at: location)
    {
      if node.name == "pause"
      {
        showPauseMenu()
        return
      }
    }
    
    for node in hitNodes
    {
      guard let name = node.name else { continue }
      
      if name.hasPrefix("preempt_")
      {
        let coreNumber = name.replacingOccurrences(of: "preempt_", with: "")
        
        print("Preempt requested for \(coreNumber)")
        // TODO(dsd): notify GameViewModel
        return
      }
      
      if name.hasPrefix("task_")
      {
        // dsd: task hit targets can be either the card or its subtitle label
        var taskNode: SKNode? = node
        while let current = taskNode,
              !current.children.contains(where: {
                $0.name?.hasPrefix("task_") == true && $0 is SKShapeNode
              })
        {
          taskNode = current.parent
        }
        guard let taskCard = taskNode, let parent = taskCard.parent else { return }
        let scenePoint = location
        let cardCenter = taskCard.convert(CGPoint.zero, to: self)
        draggedTaskOffset = CGPoint(x: cardCenter.x - scenePoint.x, y: cardCenter.y - scenePoint.y)
        draggedTaskParent = parent
        draggedTaskOriginalPosition = taskCard.position
        taskCard.removeFromParent()
        addChild(taskCard)
        taskCard.position = cardCenter
        taskCard.zPosition = 1000
        draggedTask = taskCard
        return
      }
      
      if name == "queue_to_core" || name == "empty_core"
      {
        print("Open task dispatch selection")
        // TODO(dsd): present available tasks.
        return
      }
      
      if name == "pause"
      {
        print("Pause requested")
        // TODO(dsd): present pause menu
        return
      }
    }
    
  }

  override
  func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if let touch = touches.first, let draggedTask
    {
      let point = touch.location(in: self)
      draggedTask.position = CGPoint(x: point.x + draggedTaskOffset.x,
                                     y: point.y + draggedTaskOffset.y)
      return
    }
    nodeList?.handleTouchesMoved(touches)
  }

  override
  func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    finishTaskDrag(at: touches.first?.location(in: self))
    nodeList?.handleTouchesEnded()
  }

  override
  func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    finishTaskDrag(at: nil)
    nodeList?.handleTouchesEnded()
  }

  private
  func finishTaskDrag(at point: CGPoint?)
  {
    guard let task = draggedTask else { return }
    draggedTask = nil
    task.zPosition = 0

    guard let point, let destination = nodes(at: point).first(where: {
      $0.name == "empty_core" || $0.name?.hasPrefix("core_") == true
    })
    else
    {
      task.removeFromParent()
      if let parent = draggedTaskParent
      {
        parent.addChild(task)
        task.position = draggedTaskOriginalPosition
      }
      draggedTaskParent = nil
      return
    }

    let taskName = task.children.first(where: { $0.name?.hasPrefix("task_") == true })?.name ?? task.children.first(where: { $0 is SKShapeNode })?.name
    let taskID = taskName?.replacingOccurrences(of: "task_", with: "") ?? "?"
    let core = destination.name == "empty_core" ? "4" :
      (destination.name?.replacingOccurrences(of: "core_", with: "") ?? "?")
    print("Dispatch requested for task \(taskID) to core \(core)")
    task.removeFromParent()
    draggedTaskParent = nil
  }
}
