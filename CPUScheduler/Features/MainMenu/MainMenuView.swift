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
  
  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        ZStack {
          Color.appBackground.ignoresSafeArea()
          
          HStack(spacing: 0) {
            Color.appCyan.opacity(0.025)
              .frame(width: 20)
            
            Spacer(minLength: 0)
          }
          .ignoresSafeArea()
          
          ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
              playerHeader.padding(.top, 24)
              
              Image("CPUEmblem")
                .padding(.top, geometry.size.height * 0.065)
              
              title.padding(.top, 32)
              
              Spacer(minLength: geometry.size.height * 0.085)
              
              if gcViewModel.signedIn
              {
                mainButtons
              }
              else
              {
                signInButton
              }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
            .frame(
              minHeight: geometry.size.height,
              alignment: .top
            )
          }
        }
      }
      .toolbar(.hidden, for: .navigationBar)
      .onAppear {
        authenticatePlayer()
      }
      .alert(
        "Sign In Failed",
        isPresented: $gcViewModel.showError
      ) {
        Button("OK", role: .cancel) {}
      } message: {
        Text(
          gcViewModel.errorMessage ?? "An unknown error occurred."
        )
      }
      .sheet(item: $gcViewModel.loginSheet) { sheetVC in
        GameCenterLoginView(viewController: sheetVC.vc)
      }
    }
    .preferredColorScheme(.dark)
  }
  
  private var playerHeader: some View {
    HStack {
      if gcViewModel.signedIn
      {
        HStack(spacing: 12) {
          profileImage
          
          VStack(alignment: .leading, spacing: 2) {
            Text("LVL")
              .font(
                .system(
                  size: 13,
                  weight: .bold,
                  design: .monospaced
                )
              )
              .tracking(1.5)
              .foregroundStyle(Color.appCyan)
            
            Text(gcViewModel.getPlayerDisplayName())
              .font(Fonts.jbBold(17))
              .foregroundStyle(.white)
              .lineLimit(1)
          }
        }
        .padding(8)
        .background(Color.appPanel)
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.white.opacity(0.12),
              lineWidth: 1.5
            )
        }
      }
      else
      {
        HStack(spacing: 10) {
          Image(systemName: "person.crop.circle")
            .font(Fonts.jbRegular(30))
            .foregroundStyle(Color.appCyan)
          
          Text("GUEST PLAYER")
            .font(
              Fonts.jbBold(14)
            )
            .foregroundStyle(.white.opacity(0.8))
        }
        .padding(12)
        .background(Color.appPanel)
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.white.opacity(0.12),
              lineWidth: 1.5
            )
        }
      }
      
      Spacer(minLength: 8)
      
      HStack(spacing: 6) {
        Image(systemName: "bolt.fill")
          .foregroundStyle(.yellow)
        
        #warning("Placeholder")
        // TODO(dsd): Replace placeholder with actual score or remove it if it looks unnecessary
        Text("4850")
          .font(
            Fonts.jbBold(18)
          )
          .tracking(1)
          .foregroundStyle(Color.appCyan.opacity(0.9))
      }
      .padding(.horizontal, 12)
      .frame(height: 48)
      .background(Color.appPanel)
      .overlay {
        Rectangle()
          .strokeBorder(
            Color.white.opacity(0.12),
            lineWidth: 1.5
          )
      }
    }
  }
  
  @ViewBuilder
  private var profileImage: some View {
    if let avatar = gcViewModel.avatar
    {
      Image(uiImage: avatar)
        .resizable()
        .scaledToFill()
        .frame(width: 48, height: 48)
        .clipShape(Rectangle())
    }
    else
    {
      Image(systemName: "person.crop.square.fill")
        .resizable()
        .scaledToFit()
        .foregroundStyle(Color.appCyan)
        .frame(width: 48, height: 48)
    }
  }
  
  private var title: some View {
    HStack(spacing: 7) {
      Text("CPU")
        .foregroundStyle(.white)
      
      Text("//")
        .foregroundStyle(Color.appCyan)
      
      Text("SCHEDULER")
        .foregroundStyle(
          LinearGradient(
            colors: [
              .white,
              Color.appCyan
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
    }
    .font(Fonts.jbBold(35))
    .minimumScaleFactor(0.55)
    .lineLimit(1)
    .frame(maxWidth: .infinity)
    .shadow(color: Color.appCyan.opacity(0.2), radius: 18)
  }
  
  private var mainButtons: some View {
    VStack(spacing: 12) {
      
      //- dsd: Campaign mode button
      NavigationLink(destination: GameView()) {
        HStack(spacing: 18) {
          Image(systemName: "play.fill")
            .font(Fonts.jbBold(28))
            .frame(width: 76, height: 84)
            .background(.white.opacity(0.17))
            .overlay {
              Rectangle()
                .strokeBorder(
                  .white.opacity(0.3),
                  lineWidth: 1.5
                )
            }
          
          VStack(alignment: .leading, spacing: 8) {
            Text("PLAY NOW")
              .font(Fonts.jbBold(24))
              .lineLimit(1)
              .minimumScaleFactor(0.7)
            
            // TODO(dsd): Change the placeholder text with real values.
            // The text should represent the next level or just nothing
            // if they completed it or just didn't start.
            #warning("Placeholder")
            Text("SECTOR 01 - DATABASE")
              .font(Fonts.jbBold(13))
              .tracking(0.8)
              .lineLimit(1)
              .minimumScaleFactor(0.65)
              .foregroundStyle(.white.opacity(0.85))
          }
          
          Spacer(minLength: 0)
          
          Image(systemName: "arrow.right")
            .font(.system(size: 23, weight: .semibold))
            .frame(width: 42, height: 48)
            .background(.black.opacity(0.15))
            .overlay {
              Rectangle()
                .strokeBorder(
                  .white.opacity(0.15),
                  lineWidth: 1
                )
            }
        }
        .foregroundStyle(.white)
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 164)
        .background(
          LinearGradient(
            colors: [
              Color.appBlue,
              Color(red: 0.02, green: 0.59, blue: 0.72),
              Color(red: 0.22, green: 0.49, blue: 0.97)
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .overlay {
          Rectangle()
            .strokeBorder(
              .white.opacity(0.17),
              lineWidth: 1.5
            )
        }
        .shadow(color: Color.appBlue.opacity(0.25), radius: 10, y: 5)
      }
      .buttonStyle(.plain)
      
      //- dsd: level select link
      NavigationLink(destination: LevelSelectView()) {
        HStack(spacing: 22) {
          MenuIcon(
            symbol: "square.grid.2x2",
            color: Color.appCyan,
            background: Color.appCyan.opacity(0.08)
          )
          
          Text("LEVEL SELECT")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white.opacity(0.95))
          
          Spacer(minLength: 0)
          
          Image(systemName: "chevron.right")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white.opacity(0.4))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(Color.appPanel)
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.white.opacity(0.13),
              lineWidth: 1.5
            )
        }
      }
      .buttonStyle(.plain)
      
      //- dsd: survival mode link
      NavigationLink(destination: GameView()) {
        HStack(spacing: 22) {
          MenuIcon(
            symbol: "cpu",
            color: .white,
            background: .white.opacity(0.17)
          )
          
          Text("SURVIVAL MODE")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
          
          Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(
          LinearGradient(
            colors: [
              Color(
                red: 0.02,
                green: 0.57,
                blue: 0.37
              ),
              Color(
                red: 0.10,
                green: 0.77,
                blue: 0.32
              )
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .overlay {
          Rectangle()
            .strokeBorder(
              .white.opacity(0.15),
              lineWidth: 1.5
            )
        }
        .shadow(color: Color.appGreen.opacity(0.2), radius: 14, y: 7)
      }
      .buttonStyle(.plain)
      
      //- dsd: navigations for challenges, ranks, settings
      HStack(spacing: 12) {
        NavigationCard(
          title: "CHALLENGES",
          symbol: "trophy.fill",
          color: Color.orange
        ) {
          ChallengesView()
        }
        
        NavigationCard(
          title: "RANKS",
          symbol: "chart.bar.fill",
          color: Color.appCyan
        ) {
          LeaderboardView()
        }
        
        NavigationCard(
          title: "SETTINGS",
          symbol: "gearshape.fill",
          color: Color(
            red: 0.75,
            green: 0.80,
            blue: 0.88
          )
        ) {
          SettingsView()
        }
      }
      .padding(.top, 6)
    }
  }
  
  private var signInButton: some View {
    Button(action: authenticatePlayer) {
      HStack(spacing: 16) {
        Image(systemName: "person.crop.circle.badge.checkmark")
          .font(Fonts.jbRegular(32))
          .foregroundStyle(Color.appCyan)
        
        VStack(alignment: .leading, spacing: 6) {
          Text("SIGN IN TO GAME CENTER")
            .font(Fonts.jbBold(18))
            .foregroundStyle(.white)
          
          Text("SYNC YOUR PLAYER PROFILE")
            .font(Fonts.jbBold(11))
            .tracking(0.7)
            .foregroundStyle(.white.opacity(0.7))
        }
        
        Spacer(minLength: 0)
        
        Image(systemName: "arrow.right")
          .foregroundStyle(.white)
      }
      .padding(18)
      .frame(maxWidth: .infinity, minHeight: 110)
      .background(
        LinearGradient(
          colors: [Color.appBlue, Color.appCyan.opacity(0.65)],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .overlay {
        Rectangle()
          .strokeBorder(.white.opacity(0.2), lineWidth: 1.5)
      }
    }
    .buttonStyle(.plain)
  }
  
  private
  func authenticatePlayer()
  {
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


//- dsd: resusable icon for menu
private
struct MenuIcon : View
{
  let symbol: String
  let color: Color
  let background: Color
  
  var body: some View {
    Image(systemName: symbol)
      .font(Fonts.jbBold(28))
      .foregroundStyle(color)
      .frame(width: 70, height: 70)
      .background(background)
      .overlay {
        Rectangle()
          .strokeBorder(color.opacity(0.3), lineWidth: 1.5)
      }
  }
}

//- dsd: navigation card for challenges, ranks, settings
private
struct NavigationCard<Destination: View> : View
{
  let title: String
  let symbol: String
  let color: Color
  let destination: Destination
  
  init(
    title: String,
    symbol: String,
    color: Color,
    @ViewBuilder destination: () -> Destination
  )
  {
    self.title = title
    self.symbol = symbol
    self.color = color
    self.destination = destination()
  }
  
  var body: some View {
    NavigationLink(destination: destination) {
      VStack(spacing: 14) {
        Image(systemName: symbol)
          .font(Fonts.jbBold(29))
          .foregroundStyle(color)
          .frame(width: 64, height: 64)
          .background(color.opacity(0.09))
          .overlay {
            Rectangle()
              .strokeBorder(
                color.opacity(0.3),
                lineWidth: 1.5
              )
          }
        
        Text(title)
          .font(Fonts.jbBold(12))
          .foregroundStyle(.white)
          .lineLimit(1)
          .minimumScaleFactor(0.6)
      }
      .frame(maxWidth: .infinity, minHeight: 166)
      .background(
        Color(red: 0.065, green: 0.09, blue: 0.145)
      )
      .overlay {
        Rectangle()
          .strokeBorder(
            Color.white.opacity(0.13),
            lineWidth: 1.5
          )
      }
    }
    .buttonStyle(.plain)
  }
}

// TODO(dsd): @issue need to adjust the sizes of the components to fit the
// screen. It should automatically scale according to the screen.

#Preview {
  MainMenuView()
}
