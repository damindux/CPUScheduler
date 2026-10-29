//
//  AppRootView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-29.
//

import SwiftUI

struct AppRootView : View
{
  @Environment(\.modelContext)
  private var modelContext
  
  @State
  private var seedError: String?
  
  var body: some View {
    MainMenuView().task {
      do
      {
        try LevelSeeder.seedIfNeeded(context: modelContext)
      }
      catch
      {
        seedError = error.localizedDescription
        print("Failed to seed levels: \(error)")
      }
    }
    .alert(
      "Failed to Load Levels",
      isPresented: Binding(
        get: { seedError != nil },
        set: { if !$0 { seedError = nil } }
      )
    ) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(seedError ?? "An unknown error occurred.")
    }
  }
}

#Preview {
  AppRootView()
}
