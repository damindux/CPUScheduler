//
//  ContentView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SwiftUI
import GameKit

struct ContentView: View {
  @StateObject private var gcManager = GameCenterManager()

  var body: some View {
    VStack(spacing: 20) {
      Text(
        gcManager.isAuthenticated
          ? "Game Center: Online" : "Game Center: Offline"
      )
      .font(.headline)
      
      Text(
        gcManager.isAuthenticated
          ? "DisplayName: \(gcManager.localPlayer.displayName)\n" +
            "Id: \(gcManager.localPlayer.gamePlayerID)"
          : ""
      )
      .font(.headline)

      if !gcManager.isAuthenticated {
        Button("Sign In to Game Center") {
          gcManager.authenticate()
        }
      }
    }
    .padding()
    .onAppear {
      gcManager.authenticate()
    }
    .sheet(
      item: Binding<IdentifiableViewController?>(
        get: {
          gcManager.authViewController.map {
            IdentifiableViewController(vc: $0)
          }
        },
        set: { _ in gcManager.authViewController = nil }
      )
    ) { sheetVC in
      GameCenterLoginView(viewController: sheetVC.vc)
    }
  }
}

// helper struct to make the sheet presentation work with Identifiable
struct IdentifiableViewController: Identifiable {
  let id = UUID()
  let vc: UIViewController
}

#Preview {
    ContentView()
}
