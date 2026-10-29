//
//  LevelSeeder.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-29.
//

import Foundation
import SwiftData

// TODO(dsd): why we need to use enum here
@MainActor
enum LevelSeeder
{
  // NOTE(dsd): this implementation cannot pick up new levels added to the seed.
  // it works only if the database is empty. so we need to drop the db to seed it
  // with new data.
  static
  func seedIfNeeded(context: ModelContext) throws
  {
    let request = FetchDescriptor<Level>()
    let existingLevels = try context.fetch(request)

    guard existingLevels.isEmpty else { return }

    //- dsd: get the file path
    guard let url = Bundle.main.url(
      forResource: "levels",
      withExtension: "json",
      subdirectory: "Resources"
    )
    else
    {
      throw CocoaError(.fileNoSuchFile)
    }

    //- dsd: extract data from file and decode the json
    let data = try Data(contentsOf: url)
    let catalogue = try JSONDecoder().decode(
      LevelCatalogue.self,
      from: data
    )

    do
    {
      //- dsd: insert levels
      for definition in catalogue.levels
      {
        let level = Level(
          id: definition.id,
          name: definition.name,
          noOfCPUCores: definition.noOfCPUCores,
          availableMemory: definition.availableMemory,
          difficulty: definition.difficulty,
          timeLimit: definition.timeLimit,
          sector: definition.sector
        )

        context.insert(level)

        //- dsd: insert the tasks to a level
        for taskDefinition in definition.tasks
        {
          let task = WorkloadTask(
            id: taskDefinition.id,
            cpuBurst: taskDefinition.cpuBurst,
            remainingTime: taskDefinition.cpuBurst,
            priority: taskDefinition.priority,
            arrivalTime: taskDefinition.arrivalTime,
            deadline: taskDefinition.deadline,
            memoryRequired: taskDefinition.memoryRequired,
            state: .Ready,
            assignedCore: -1,
            waitingTime: 0,
            level: level
          )

          level.tasks.append(task)
        }
      }

      try context.save()
    }
    catch
    {
      context.rollback()
      throw error
    }
  }
}
