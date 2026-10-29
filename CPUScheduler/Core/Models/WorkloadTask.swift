//
//  Task.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import Foundation
import SwiftData

@Model
final
class WorkloadTask
{
  @Attribute(.unique)
  var id: String
  
  var cpuBurst: Float32
  var remainingTime: Float32
  var priority: Priority
  var arrivalTime: TimeInterval
  var deadline: TimeInterval?
  var memoryRequired: Float32
  var state: TaskState
  var assignedCore: Int32
  var waitingTime: Float32
  
  var level: Level?
  
  init(
    id: String,
    cpuBurst: Float32,
    remainingTime: Float32,
    priority: Priority,
    arrivalTime: TimeInterval,
    deadline: TimeInterval?,
    memoryRequired: Float32,
    state: TaskState,
    assignedCore: Int32,
    waitingTime: Float32,
    level: Level? = nil
  )
  {
    self.id = id
    self.cpuBurst = cpuBurst
    self.remainingTime = remainingTime
    self.priority = priority
    self.arrivalTime = arrivalTime
    self.deadline = deadline
    self.memoryRequired = memoryRequired
    self.state = state
    self.assignedCore = assignedCore
    self.waitingTime = waitingTime
    self.level = level
  }
}
