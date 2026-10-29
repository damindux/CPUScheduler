//
//  LevelSelectViewModel.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-29.
//

import Foundation
import SwiftData
import Combine

final
class LevelSelectViewModel : ObservableObject
{
  private var modelContext: ModelContext?
  
  @Published private(set) var levels: Array<Level> = Array()
  
  func configure(_ modelContext: ModelContext)
  {
    self.modelContext = modelContext
  }
  
  func loadLevels(for sector: String)
  {
    guard let modelContext else { return }
    
    // TODO(dsd): look what #predicate is
    let predicate = #Predicate<Level> { level in
      level.sector == sector
    }
    
    let descriptor = FetchDescriptor<Level>(
      predicate: predicate,
      sortBy: [SortDescriptor(\.name)]
    )
    
    levels = (try? modelContext.fetch(descriptor)) ?? []
  }
}
