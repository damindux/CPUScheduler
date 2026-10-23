//
//  GameCenterManager.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import Combine
import GameKit

final class GameCenterManager
{
  private(set) var isAuthenticated = false
  private(set) var authenticationError: GameCenterError? = nil
  
  var viewController: UIViewController? = nil

  var localPlayer: GKLocalPlayer {
    GKLocalPlayer.local
  }

  func authenticate()
  {
    localPlayer.authenticateHandler = { [weak self] viewController, error in
      Task { [weak self] in
        guard let self else { return }

        if let error
        {
          self.isAuthenticated = false
          self.authenticationError = GameCenterError.AuthenticationFailed
          return
        }

        if let viewController
        {
          self.viewController = viewController
          return
        }

        self.isAuthenticated = self.localPlayer.isAuthenticated
      }
    }
  }
  
  func getPlayerIdentityInfo() async throws -> IdentitySignature
  {
    guard self.isAuthenticated else
    {
      throw GameCenterError.NotAuthenticated
    }
    
    let (publicUrl, signature, salt, timestamp) = try await localPlayer.fetchItemsForIdentityVerificationSignature()
    
    return IdentitySignature(
      publickeyURL: publicUrl,
      signature: signature,
      salt: salt,
      timestamp: timestamp,
      playerID: localPlayer.teamPlayerID
    )
  }
}

struct IdentitySignature
{
  let publickeyURL: URL
  let signature: Data
  let salt: Data
  let timestamp: UInt64
  let playerID: String
}

enum GameCenterError : Error
{
  case NotAuthenticated
  case AuthenticationFailed
}
