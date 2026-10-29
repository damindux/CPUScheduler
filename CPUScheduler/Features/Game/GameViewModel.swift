//
//  GameViewModel.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-19.
//

import Combine
import Foundation
import SwiftData

@MainActor  // TODO(dsd): why main actor here
final
class GameViewModel : ObservableObject
{
  @Published var currentLevel: Level?
  @Published var gameStatus: GameStatus = .Ready
  @Published var score: Int32 = 0
  @Published var elapsedTime: Float32 = 0
  @Published var remainingTime: TimeInterval = 0
  @Published var completedTasks: Array<Int32> = Array()
  
  @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  private var timerSubscription: AnyCancellable?

  init()
  {
    timerSubscription = timer.sink { [weak self] _ in
      self?.updateTimer()
    }
  }
  
  //- dsd: get number of cores, available memory and tasks list
  // of the current level
  func getLevelData() -> (Int32, Int32, Array<WorkloadTask>?)
  {
    guard let currentLevel else
    {
      return (0, 0, nil)
    }
    
    return (currentLevel.noOfCPUCores, currentLevel.availableMemory, currentLevel.tasks)
  }
  
  func setupGame(with level: Level)
  {
    self.currentLevel = level
    self.gameStatus = .Ready
    self.score = 0
    self.elapsedTime = 0
    self.remainingTime = level.timeLimit
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
  
  func getReadyTasks() -> Array<WorkloadTask>
  {
    guard let currentLevel else { return Array() }

    return currentLevel.tasks.filter { task in
      task.state == .Ready
    }
  }
  
  //- dsd: complete a level (need to trigger the win condition)
  func completeLevel(level: Level, player: PlayerProfile, modelContext: ModelContext) throws
  {
    let playerID = player.gamePlayerID
    let levelID = level.id
    
    let predicate = #Predicate<LevelProgress> { progress in
      progress.levelID == levelID && progress.player?.gamePlayerID == playerID
    }
    let descriptor = FetchDescriptor<LevelProgress>(predicate: predicate)
    
    let progress: LevelProgress
    
    //- dsd: look if the player is already completed the level
    if let existingProgress = try modelContext.fetch(descriptor).first
    {
      progress = existingProgress
    }
    else
    {
      progress = LevelProgress(levelID: levelID)
      progress.player = player
      modelContext.insert(progress)
    }
    
    progress.isCompleted = true
    progress.completedAt = .now
    
    try modelContext.save()
  }
  
  // TODO(dsd): @feature Create task queue
  // Task must come in random intervals and random amount of tasks
  // around 2-5 tasks should come at a time. We have the task list
  // So I have to create a mechanism to achieve this without
  // changing the task list.
  
  private 
  func updateTimer()
  {
    guard let currentLevel else { return }
    
    guard gameStatus == .Ready, currentLevel.timeLimit > 0 else { return }

    elapsedTime += 1
    remainingTime = max(0, currentLevel.timeLimit - TimeInterval(elapsedTime))

    if remainingTime == 0
    {
      gameStatus = .GameOver
    }
  }
}

enum GameStatus : Equatable
{
  case Ready
  case Won
  case GameOver
  case Paused
}
