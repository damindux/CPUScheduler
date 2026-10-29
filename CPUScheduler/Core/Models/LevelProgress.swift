//
//  LevelProgress.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-29.
//

import Foundation
import SwiftData

@Model
final
class LevelProgress
{
  var levelID: String
  var isCompleted: Bool
  var completedAt: Date?

  var player: PlayerProfile?

  init(
    levelID: String,
    isCompleted: Bool = false,
    bestScore: Int32 = 0,
    completedAt: Date? = nil
  )
  {
    self.levelID = levelID
    self.isCompleted = isCompleted
    self.completedAt = completedAt
  }
}
