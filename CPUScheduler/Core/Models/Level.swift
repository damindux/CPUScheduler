//
//  Level.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import Foundation

struct Level
{
  let id: Int
  let name: String
  let noOfCPUCores: Int
  let availableMemory: Int
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
