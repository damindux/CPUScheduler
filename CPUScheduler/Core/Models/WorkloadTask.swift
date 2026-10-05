//
//  Task.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import Foundation

struct WorkloadTask
{
  let id: Int
  let cpuBurst: Float
  var remainingTime: Float
  var priority: Priority
  let arrivalTime: TimeInterval
  let deadline: TimeInterval?
  let memoryRequired: Float
  var state: State
  var assignedCore: Int
  var waitingTime: Float
}

enum Priority : Int
{
  case Low = 30
  case Normal = 20
  case High = 10
}

enum State
{
  case Ready
  case Running
  case IOWait
  case Completed
}
