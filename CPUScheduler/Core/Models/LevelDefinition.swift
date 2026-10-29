//
//  LevelDefinition.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-29.
//

import Foundation

struct LevelCatalogue : Decodable
{
  let levels: Array<LevelDefinition>
}

struct LevelDefinition : Decodable
{
  let id: String
  let name: String
  let noOfCPUCores: Int32
  let availableMemory: Int32
  let difficulty: Difficulty
  let timeLimit: TimeInterval
  let sector: String
  let tasks: Array<WorkloadTaskDefinition>
}

struct WorkloadTaskDefinition : Decodable
{
  let id: String
  let cpuBurst: Float32
  let priority: Priority
  let arrivalTime: TimeInterval
  let deadline: TimeInterval?
  let memoryRequired: Float32
}

// NOTE(dsd): the raw values of this enum represent the
// starvation threshold for each priority in seconds.
enum Priority : Int32, Codable
{
  case Low = 30
  case Normal = 20
  case High = 10
}

enum Difficulty : String, Codable
{
  case Easy
  case Medium
  case Hard
  case VeryHard
}

enum TaskState : String, Codable
{
  case Ready
  case Running
  case IOWait
  case Completed
}
