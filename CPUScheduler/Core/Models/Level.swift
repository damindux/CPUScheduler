//
//  Level.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import SwiftUI

struct Level : Identifiable
{
  let id = UUID()
  let name: String
  let noOfCPUCores: Int32
  let availableMemory: Int32
  let tasks: Array<WorkloadTask>
  let difficulty: Difficulty
  let timeLimit: TimeInterval
}

enum Difficulty
{
  case Easy
  case Medium
  case Hard
  case VeryHard
}
