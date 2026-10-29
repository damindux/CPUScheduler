//
//  GameCenterManager.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import Combine
import GameKit
import SwiftData

final
class GameCenterManager
{
  private(set) var isAuthenticated = false
  private(set) var authenticationError: GameCenterError? = nil
  
  var viewController: UIViewController? = nil

  var localPlayer: GKLocalPlayer {
    GKLocalPlayer.local
  }
  
  // TODO(dsd): need to create a guest profile and save it as the
  // local profile until player signs in with game center
  
  //- dsd: creating a local profile for offline play
  func loadOrCreateProfile(modelContext: ModelContext) throws -> PlayerProfile
  {
    guard isAuthenticated else
    {
      throw GameCenterError.NotAuthenticated
    }
    
    let gamePlayerID = localPlayer.gamePlayerID
    
    // TODO(dsd): look into predicate, descriptor
    let predicate = #Predicate<PlayerProfile> { profile in
      profile.gamePlayerID == gamePlayerID
    }
    let descriptor = FetchDescriptor<PlayerProfile>(predicate: predicate)
    
    //- dsd: check for existing local profile and update it
    if let existingProfile = try modelContext.fetch(descriptor).first
    {
      existingProfile.lastPlayedAt = .now
      try modelContext.save()
      return existingProfile
    }
    
    //- dsd: create a local profile for the player
    let profile = PlayerProfile(gamePlayerID: gamePlayerID)
    modelContext.insert(profile)
    try modelContext.save()
    
    return profile
  }

  func authenticate()
  {
    localPlayer.authenticateHandler = { [weak self] viewController, error in
      Task { [weak self] in
        guard let self else { return }

        if error != nil
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
