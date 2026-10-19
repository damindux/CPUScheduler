//
//  Task.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import SwiftUI

struct WorkloadTask : Identifiable
{
  let id = UUID()
  let cpuBurst: Float32
  var remainingTime: Float32
  var priority: Priority
  let arrivalTime: TimeInterval
  let deadline: TimeInterval?
  let memoryRequired: Float32
  var state: State
  var assignedCore: Int32
  var waitingTime: Float32
}

enum Priority : Int32
{
  // @note: The raw values of this enum represent the
  // starvation threshold for each priority in seconds.
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
