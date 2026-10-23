//
//  GameCenterViewModel.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-23.
//

import Combine
import SwiftUI
import GameKit

@MainActor
final class GameCenterViewModel : ObservableObject
{
  @Published private(set) var avatar: UIImage?
  @Published var signedIn: Bool = false
  @Published var loginSheet: IdentifiableViewController?
  @Published var errorMessage: String?
  @Published var showError = false
  
  private let identityService = IdentityService()
  private let gcManager = GameCenterManager()
  
  func playerSignIn() throws
  {
    self.gcManager.authenticate()
    if let error = self.gcManager.authenticationError
    {
      throw error
    }
    self.signedIn = true
    self.loadAvatar()
  }
  
  func getPlayerDisplayName() -> String
  {
    self.gcManager.localPlayer.displayName
  }
  
  func presentLogin(_ viewController: UIViewController)
  {
    loginSheet = IdentifiableViewController(vc: viewController)
  }
  
  func dismissLogin()
  {
    loginSheet = nil
    self.gcManager.viewController = nil
  }
  
  private func loadAvatar()
  {
    self.gcManager.localPlayer.loadPhoto(for: .small) { [weak self] image, error in
      if let error
      {
        print("Failed to load Game Center avatar:", error)
        return
      }
      
      Task { @MainActor [weak self] in
        self?.avatar = image
      }
    }
  }
}

// helper struct to make the sheet presentation work with Identifiable
struct IdentifiableViewController : Identifiable
{
  let id = UUID()
  let vc: UIViewController
}
