//
//  MainMenu.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SwiftUI
import GameKit

struct MainMenuView : View
{
  @StateObject private var gcManager = GameCenterManager()
  
  @ViewBuilder
  var profileImage: some View {
    if let avatar = gcManager.avatar
    {
      Image(uiImage: avatar)
        .resizable()
        .scaledToFill()
        .frame(width: 80, height: 80)
        .clipShape(Circle())
    }
    else
    {
      Image(systemName: "person.circle.fill")
        .font(.system(size: 80))
    }
  }
  
  var profileName: some View {
    Text(gcManager.localPlayer.displayName)
      .font(.headline)
  }
  
  var mainButtons: some View {
    VStack {
      NavigationLink(destination: GameView()) {
        Text("PLAY NOW")
      }
      NavigationLink(destination: LevelSelectView()) {
        Text("LEVEL SELECT")
      }
      NavigationLink(destination: GameView()) {
        Text("SURVIVAL MODE")
      }
      otherButtons
    }
  }
  
  var otherButtons: some View {
    HStack {
      NavigationLink(destination: ChallengesView()) {
        Text("CHALLENGES")
      }
      NavigationLink(destination: LeaderboardView()) {
        Text("LEADERBOARD")
      }
      NavigationLink(destination: SettingsView()) {
        Text("SETTINGS")
      }
    }
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        if #available(iOS 26.0, *)
        {
          HStack(spacing: 10) {
            if gcManager.isAuthenticated {
              profileImage
              profileName
            }
            Spacer()
          }
          .padding(.horizontal, 14)
          .padding(.vertical, 8)
          .glassEffect(.regular, in: .capsule)
        }
        else
        {
          HStack(spacing: 10) {
            if gcManager.isAuthenticated
            {
              profileImage
              profileName
            }
            Spacer()
          }
          .padding(.horizontal, 14)
          .padding(.vertical, 8)
          .background(.ultraThinMaterial, in: .capsule)
        }
        
        if !gcManager.isAuthenticated
        {
          Button("Sign In to Game Center") {
            gcManager.authenticate()
          }
        }
        else
        {
          mainButtons
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
}

// helper struct to make the sheet presentation work with Identifiable
struct IdentifiableViewController : Identifiable
{
  let id = UUID()
  let vc: UIViewController
}

#Preview
{
  MainMenuView()
}
