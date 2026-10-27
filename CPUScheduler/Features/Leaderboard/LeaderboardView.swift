//
//  LeaderboardView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import SwiftUI

// TODO(dsd): fix margins and spacing
// TODO(dsd): think a way to add friends or just remove the feature
// TODO(dsd): use geometry reader here
struct LeaderboardView : View
{
  @Environment(\.dismiss)
  private var dismiss
  
  @State
  private var selectedTab: LeaderboardTab = .global
  
  private let tabs = LeaderboardTab.allCases
  
  var body: some View {
    ZStack {
      Color.appBackground.ignoresSafeArea()
      
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 0) {
          header.padding(.top, 24)
          
          tabSelector.padding(.top, 32)
          
          playerSummary.padding(.top, 24)
          
          rankingsHeader
            .padding(.top, 24)
            .padding(.bottom, 8)
          
          rankingsList
          
          Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .preferredColorScheme(.dark)
  }
  
  //- dsd: header section
  private var header: some View {
    HStack(spacing: 28) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "arrow.left")
          .font(Fonts.jbRegular(28))
          .foregroundStyle(Color.white.opacity(0.8))
          .frame(width: 36, height: 48)
      }
      .buttonStyle(.plain)
      
      Text("Leaderboard")
        .font(Fonts.jbBold(24))
        .foregroundStyle(Color.white.opacity(0.9))
      
      Spacer()
    }
  }
  
  //- dsd: place where the tabs live
  private var tabSelector: some View {
    HStack(spacing: 0) {
      ForEach(tabs) { tab in
        let isSelected = selectedTab == tab
        
        Button {
          withAnimation(.easeInOut(duration: 0.2)) {
            selectedTab = tab
          }
        } label: {
          Text(tab.rawValue.uppercased())
            .font(Fonts.jbBold(16))
            .tracking(1)
            .foregroundStyle(
              isSelected
              ? Color(red: 0.65, green: 0.75, blue: 1.0)
              : Color.white.opacity(0.7)
            )
            .frame(maxWidth: .infinity, minHeight: 48)
            .background {
              if isSelected {
                Color.white.opacity(0.025)
              }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
      }
    }
    .padding(8)
    .background(Color.appPanel)
  }
  
  //- dsd: current player details
  private var playerSummary: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(summaryLabel)
        .font(Fonts.jbBold(16))
        .tracking(1.5)
        .foregroundStyle(Color(red: 0.45, green: 0.78, blue: 1.0))
      
      HStack(spacing: 10) {
        // TODO(dsd): need to put actual rank
        Text("#42")
          .font(Fonts.jbBold(36))
          .foregroundStyle(Color(red: 0.45, green: 0.78, blue: 1.0))
        
        // TODO(dsd): need to put actual name
        Text("ARCH_ROOT")
          .font(Fonts.jbBold(25))
          .foregroundStyle(.white.opacity(0.9))
          .lineLimit(1)
          .minimumScaleFactor(0.65) // TODO(dsd): look what this actually does
        
        Text("YOU")
          .font(Fonts.jbBold(13))
          .tracking(1)
          .foregroundStyle(Color.appGreen)
          .padding(.horizontal, 6)
          .background(Color.appGreen.opacity(0.07))
        
        Spacer(minLength: 0)
        
        // TODO(dsd): need to put actual scores here
        Text("1,420,850")
          .font(Fonts.jbBold(27))
          .foregroundStyle(Color(red: 0.45, green: 0.78, blue: 1.0))
          .lineLimit(1)
          .minimumScaleFactor(0.65)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 26)
      .background(Color.white.opacity(0.025))
    }
    .padding(24)
    .background(Color.appPanel.opacity(0.75))
    .overlay {
      Rectangle()
        .strokeBorder(Color(red: 0.20, green: 0.27, blue: 0.32), lineWidth: 1.5)
    }
  }
  
  private var summaryLabel: String {
    switch selectedTab
    {
    case .global:
      return "TOP 2.4% GLOBAL"
    case .friends:
      return "FRIENDS RANKING"
    case .weekly:
      return "WEEKLY RANKING"
    }
  }
  
  //- dsd: rankings
  private var rankingsHeader: some View {
    Text("RANKINGS")
      .font(Fonts.jbBold(16))
      .tracking(1.5)
      .foregroundStyle(Color.white.opacity(0.75))
      .padding(.leading, 8)
  }
  
  private var rankingsList: some View {
    VStack(spacing: 8) {
      ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
        RankingRow(rank: Int32(index + 1), entry: entry)
      }
    }
  }
  
  //- dsd: fetch entries depending on the selected tab
  private var entries: Array<LeaderboardEntry> {
    switch selectedTab
    {
    case .global:
      return LeaderboardEntry.globalEntries
    case .friends:
      return LeaderboardEntry.friendsEntries
    case .weekly:
      return LeaderboardEntry.weeklyEntries
    }
  }
}

//- dsd: tabs on the top of the leaderboard screen
private
enum LeaderboardTab : String, CaseIterable, Identifiable
{
  case global = "Global"
  case friends = "Friends"
  case weekly = "Weekly"
  
  var id: Self {
    self
  }
}

//- dsd: an entry in rankings
private
struct LeaderboardEntry : Identifiable
{
  let id = UUID()
  let username: String
  let score: Int32
  let tier: String
  
  #warning("Placeholder")
  // TODO(dsd): change to actual values
  static let globalEntries: [LeaderboardEntry] = [
    .init(username: "0x_CYBER_GHOST", score: 2_890_400, tier: "S+"),
    .init(username: "BYTE_KNIGHT", score: 2_645_120, tier: "S"),
    .init(username: "KERNEL_PANIC", score: 2_410_900, tier: "S"),
    .init(username: "SYNTAX_TERROR", score: 2_180_300, tier: "A+"),
    .init(username: "NULL_PTR", score: 1_995_450, tier: "A+")
  ]

  static let friendsEntries: [LeaderboardEntry] = [
    .init(username: "BYTE_KNIGHT", score: 2_645_120, tier: "S"),
    .init(username: "KERNEL_PANIC", score: 2_410_900, tier: "S"),
    .init(username: "SYNTAX_TERROR", score: 2_180_300, tier: "A+"),
    .init(username: "NULL_PTR", score: 1_995_450, tier: "A+"),
    .init(username: "ARCH_ROOT", score: 1_420_850, tier: "A")
  ]

  static let weeklyEntries: [LeaderboardEntry] = [
    .init(username: "KERNEL_PANIC", score: 890_400, tier: "S"),
    .init(username: "0x_CYBER_GHOST", score: 745_120, tier: "S"),
    .init(username: "ARCH_ROOT", score: 620_850, tier: "A"),
    .init(username: "BYTE_KNIGHT", score: 510_900, tier: "A"),
    .init(username: "NULL_PTR", score: 395_450, tier: "B+")
  ]
}

//- dsd: container that holds a single ranking
private
struct RankingRow : View
{
  let rank: Int32
  let entry: LeaderboardEntry
  
  private var accent: Color {
    switch rank
    {
    case 1:
      return .yellow
    case 2:
      return Color(red: 0.76, green: 0.78, blue: 0.80)
    case 3:
      return Color(red: 0.86, green: 0.48, blue: 0.18)
    default:
      return Color.appMuted
    }
  }
  
  var body: some View {
    HStack(spacing: 16) {
      rankIndicator
      
      Text(entry.username)
        .font(Fonts.jbBold(17))
        .foregroundStyle(Color.white.opacity(0.85))
        .lineLimit(1)
        .minimumScaleFactor(0.6)
      
      Spacer(minLength: 0)
      
      Text(entry.score.formatted())
        .font(Fonts.jbBold(23))
        .foregroundStyle(
          rank == 1
          ? .yellow
          : Color.white.opacity(0.85)
        )
        .lineLimit(1)
        .minimumScaleFactor(0.6)
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, minHeight: 96)
    .background(Color.appPanel)
    .overlay(alignment: .leading) {
      Rectangle()
        .fill(rank <= 3 ? accent : .clear)
        .frame(width: 4)
    }
  }
  
  @ViewBuilder
  private var rankIndicator: some View {
    if rank <= 3
    {
      Image(systemName: "medal.fill")
        .font(.system(size: 25, weight: .bold))
        .foregroundStyle(accent)
        .frame(width: 64, height: 64)
        .background(accent.opacity(0.12))
    }
    else
    {
      Text("\(rank)")
        .font(Fonts.jbBold(20))
        .foregroundStyle(Color.white.opacity(0.75))
        .frame(width: 64, height: 64)
    }
  }
}

#Preview {
  NavigationStack {
    LeaderboardView()
  }
}
