//
//  GameCenterManager.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import GameKit
import Combine

@MainActor
final class GameCenterManager: ObservableObject {
  @Published private(set) var isAuthenticated = false
  @Published private(set) var avatar: UIImage?
  
  var localPlayer: GKLocalPlayer {
    GKLocalPlayer.local
  }
  
  @Published var authViewController: UIViewController?
  
  func authenticate()
  {
    let player = GKLocalPlayer.local
    
    player.authenticateHandler = { [weak self] viewController, error in
      Task { @MainActor in
        guard let self else { return }
        
        if let error {
          print("Game Center error: ", error)
          self.isAuthenticated = false
          return
        }
        
        if let viewController {
          self.authViewController = viewController
          return
        }
        
        if player.isAuthenticated {
          self.isAuthenticated = true
          self.loadAvatar()
        }
      }
    }
  }
  
  private func loadAvatar()
  {
    GKLocalPlayer.local.loadPhoto(
      for: .small
    ) { [weak self] image, error in
      Task { @MainActor in
        if let error {
          print("Failed to load Game Center avatar:", error)
          return
        }
        
        self?.avatar = image
      }
    }
  }
}
