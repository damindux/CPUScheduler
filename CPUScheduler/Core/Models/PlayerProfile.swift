//
//  PlayerProfile.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-29.
//

import Foundation
import SwiftData

@Model
final
class PlayerProfile
{
  @Attribute(.unique)
  var gamePlayerID: String

  var createdAt: Date
  var lastPlayedAt: Date

  @Relationship(deleteRule: .cascade, inverse: \LevelProgress.player)
  var levelProgress: Array<LevelProgress> = Array()

  init(gamePlayerID: String)
  {
    self.gamePlayerID = gamePlayerID
    self.createdAt = .now
    self.lastPlayedAt = .now
  }
}
