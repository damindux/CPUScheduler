//
//  CPUSchedulerApp.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SwiftUI
import SwiftData

@main
struct CPUSchedulerApp : App
{
  var body: some Scene {
    WindowGroup {
      AppRootView()
    }
    .modelContainer(
      for: [
        Level.self,
        WorkloadTask.self,
        PlayerProfile.self,
        LevelProgress.self,
      ])
  }
}
