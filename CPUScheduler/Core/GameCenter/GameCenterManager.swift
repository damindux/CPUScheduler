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
        
        self.isAuthenticated = player.isAuthenticated
      }
      

      
      
    }
  }
}
