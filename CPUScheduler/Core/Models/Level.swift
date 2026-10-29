//
//  Level.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import Foundation
import SwiftData

@Model
final
class Level
{
  @Attribute(.unique)
  var id: String
  
  var name: String
  var noOfCPUCores: Int32
  var availableMemory: Int32
  var difficulty: Difficulty
  var timeLimit: TimeInterval
  var sector: String
  
  // TODO(dsd): check whether this is actually necessary or not
  @Relationship(deleteRule: .cascade, inverse: \WorkloadTask.level)
  var tasks: Array<WorkloadTask>
  
  init(
    id: String,
    name: String,
    noOfCPUCores: Int32,
    availableMemory: Int32,
    difficulty: Difficulty,
    timeLimit: TimeInterval,
    sector: String,
    tasks: Array<WorkloadTask> = []
  )
  {
    self.id = id
    self.name = name
    self.noOfCPUCores = noOfCPUCores
    self.availableMemory = availableMemory
    self.difficulty = difficulty
    self.timeLimit = timeLimit
    self.sector = sector
    self.tasks = tasks
  }
}

// TODO(dsd): daily challenge should be a seperate model.
// with a Level and objective field.
