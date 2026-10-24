//
//  GameViewModel.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-19.
//

import Combine
import Foundation

final
class GameViewModel : ObservableObject
{
  @Published var currentlevel: Level = Level(
    name: "",
    noOfCPUCores: 0,
    availableMemory: 0,
    tasks: Array(),
    difficulty: .Easy,
    timeLimit: TimeInterval(),
  )
  @Published var gameStatus: GameStatus = .Ready
  @Published var score: Int32 = 0
  @Published var elapsedTime: Float32 = 0
  @Published var completedTasks: Array<Int32> = Array()
  
  @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  func setupGame(level: Level)
  {
    self.currentlevel = level
    self.gameStatus = .Ready
    self.score = 0
    self.elapsedTime = 0
    self.completedTasks.removeAll()
  }
  
  func addScore(taskPriority: Priority)
  {
    switch taskPriority
    {
    case .High:
      self.score += 500
    case .Normal:
      self.score += 300
    case .Low:
      self.score += 100
    }
  }
  
  // TODO(dsd): @feature Create task queue
  // Task must come in random intervals and random amount of tasks
  // around 2-5 tasks should come at a time. We have the task list
  // So I have to create a mechanism to achieve this without
  // changing the task list.
  
  // TODO(dsd): @feature add the timers in game view model
}

enum GameStatus
{
  case Ready, Won, GameOver, Paused
}
