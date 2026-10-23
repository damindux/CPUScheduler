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
  @StateObject private var gcViewModel = GameCenterViewModel()
  
  @ViewBuilder
  var profileImage: some View {
    if let avatar = gcViewModel.avatar
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
    Text(gcViewModel.getPlayerDisplayName())
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
        // NOTE: Just playing around with platform macros
        if #available(iOS 26.0, *)
        {
          if gcViewModel.signedIn
          {
            HStack(spacing: 10) {
              profileImage
              profileName
              Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: .capsule)
          }
        }
        else
        {
          if gcViewModel.signedIn
          {
            HStack(spacing: 10) {
              profileImage
              profileName
              Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: .capsule)
          }
        }
        
        if !gcViewModel.signedIn
        {
          Button("Sign In to Game Center") {
            do
            {
              try gcViewModel.playerSignIn()
            }
            catch
            {
              gcViewModel.errorMessage = error.localizedDescription
              gcViewModel.showError = true
            }
          }
        }
        else
        {
          mainButtons
        }
      }
      .padding()
      .onAppear {
        do
        {
          try gcViewModel.playerSignIn()
        }
        catch
        {
          gcViewModel.errorMessage = error.localizedDescription
          gcViewModel.showError = true
        }
      }
      .alert("Sign In Failed", isPresented: $gcViewModel.showError) {
        Button("OK", role: .cancel) {}
      } message: {
        Text(gcViewModel.errorMessage ?? "An unknown error occured.")
      }
      .sheet(item: $gcViewModel.loginSheet) { sheetVC in
        GameCenterLoginView(viewController: sheetVC.vc)
      }
    }
  }
}

#Preview
{
  MainMenuView()
}
