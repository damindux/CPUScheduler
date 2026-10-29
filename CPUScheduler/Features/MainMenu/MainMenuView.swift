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
        
        let componentScale = min(max(geometry.size.width / 390, 0.72), 0.88)
        
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
              playerHeader.padding(.top, 12)
              
              Image("CPUEmblem")
                .resizable()
                .scaledToFit()
                .frame(width: 120 * componentScale, height: 120 * componentScale)
                .padding(.top, geometry.size.height * 0.025)
              
              title.padding(.top, 16)
              
              Color.clear
                .frame(height: geometry.size.height * 0.035)
              
              if gcViewModel.signedIn
              {
                mainButtons(scale: componentScale)
              }
              else
              {
                signInButton
              }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
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
    .font(Fonts.jbBold(30))
    .minimumScaleFactor(0.55)
    .lineLimit(1)
    .frame(maxWidth: .infinity)
    .shadow(color: Color.appCyan.opacity(0.2), radius: 18)
  }
  
  private
  func mainButtons(scale: CGFloat) -> some View
  {
    VStack(spacing: 12 * scale) {
      
      //- dsd: Campaign mode button
      NavigationLink(destination: GameView()) {
        HStack(spacing: 18 * scale) {
          Image(systemName: "play.fill")
            .font(Fonts.jbBold(28 * scale))
            .frame(width: 76 * scale, height: 84 * scale)
            .background(.white.opacity(0.17))
            .overlay {
              Rectangle()
                .strokeBorder(
                  .white.opacity(0.3),
                  lineWidth: 1.5
                )
            }
          
          VStack(alignment: .leading, spacing: 8 * scale) {
            Text("PLAY NOW")
              .font(Fonts.jbBold(24 * scale))
              .lineLimit(1)
              .minimumScaleFactor(0.7)
            
            // TODO(dsd): Change the placeholder text with real values.
            // The text should represent the next level or just nothing
            // if they completed it or just didn't start.
            #warning("Placeholder")
            Text("SECTOR 01 - DATABASE")
              .font(Fonts.jbBold(13 * scale))
              .tracking(0.8)
              .lineLimit(1)
              .minimumScaleFactor(0.65)
              .foregroundStyle(.white.opacity(0.85))
          }
          
          Spacer(minLength: 0)
          
          Image(systemName: "arrow.right")
            .font(.system(size: 23 * scale, weight: .semibold))
            .frame(width: 42 * scale, height: 48 * scale)
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
        .padding(14 * scale)
        .frame(maxWidth: .infinity, minHeight: 132 * scale)
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
        HStack(spacing: 22 * scale) {
          MenuIcon(
            symbol: "square.grid.2x2",
            color: Color.appCyan,
            background: Color.appCyan.opacity(0.08),
            scale: scale
          )
          
          Text("LEVEL SELECT")
            .font(Fonts.jbBold(20 * scale))
            .foregroundStyle(.white.opacity(0.95))
          
          Spacer(minLength: 0)
          
          Image(systemName: "chevron.right")
            .font(Fonts.jbBold(18 * scale))
            .foregroundStyle(.white.opacity(0.4))
        }
        .padding(16 * scale)
        .frame(maxWidth: .infinity, minHeight: 102 * scale)
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
        HStack(spacing: 22 * scale) {
          MenuIcon(
            symbol: "cpu",
            color: .white,
            background: .white.opacity(0.17),
            scale: scale
          )
          
          Text("SURVIVAL MODE")
            .font(Fonts.jbBold(20 * scale))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
          
          Spacer(minLength: 0)
        }
        .padding(16 * scale)
        .frame(maxWidth: .infinity, minHeight: 102 * scale)
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
      HStack(spacing: 12 * scale) {
        NavigationCard(
          title: "CHALLENGES",
          symbol: "trophy.fill",
          color: Color.orange,
          scale: scale
        ) {
          ChallengesView()
        }
        
        NavigationCard(
          title: "RANKS",
          symbol: "chart.bar.fill",
          color: Color.appCyan,
          scale: scale
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
          ),
          scale: scale
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
  var scale: CGFloat = 1
  
  var body: some View {
    Image(systemName: symbol)
      .font(Fonts.jbBold(28 * scale))
      .foregroundStyle(color)
      .frame(width: 70 * scale, height: 70 * scale)
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
  var scale: CGFloat = 1
  
  init(
    title: String,
    symbol: String,
    color: Color,
    scale: CGFloat = 1,
    @ViewBuilder destination: () -> Destination
  )
  {
    self.title = title
    self.symbol = symbol
    self.color = color
    self.scale = scale
    self.destination = destination()
  }
  
  var body: some View {
    NavigationLink(destination: destination) {
      VStack(spacing: 8 * scale) {
        Image(systemName: symbol)
          .font(Fonts.jbBold(29 * scale))
          .foregroundStyle(color)
          .frame(width: 48 * scale, height: 48 * scale)
          .background(color.opacity(0.09))
          .overlay {
            Rectangle()
              .strokeBorder(
                color.opacity(0.3),
                lineWidth: 1.5
              )
          }
        
        Text(title)
          .font(Fonts.jbBold(12 * scale))
          .foregroundStyle(.white)
          .lineLimit(1)
          .minimumScaleFactor(0.6)
      }
      .frame(maxWidth: .infinity, minHeight: 112 * scale)
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

#Preview {
  MainMenuView()
}
