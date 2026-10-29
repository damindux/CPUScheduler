//
//  LevelSelectView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import SwiftUI
import SwiftData

// TODO(dsd): create levels.json
struct LevelSelectView : View
{
  @Environment(\.dismiss)
  private var dismiss
  
  @Environment(\.modelContext)
  private var modelContext
  
  @State
  private var selectedSector = 0
  
  @StateObject
  private var levelSelectViewModel = LevelSelectViewModel()

  private let sectors = [
    ("SECTOR 1", "BASICS"),
    ("SECTOR 2", "SERVERS"),
    ("SECTOR 3", "OVERCLOCK")
  ]
  
  let player: PlayerProfile
  let onStartLevel: (Level) -> Void
  
  private var sectorLevels: Array<Level>
  {
    let sectorID = sectors[selectedSector].0

    return levelSelectViewModel.levels
      .filter { $0.sector == sectorID }
      .sorted { $0.id < $1.id }
  }
  
  //- dsd: "escaping" is needed here because i am
  // assigning it to onStartLevel property.
  init(player: PlayerProfile, onStartLevel: @escaping (Level) -> Void)
  {
    self.onStartLevel = onStartLevel
    self.player = player
  }

  var body: some View {
    GeometryReader { geometry in
      let componentScale = min(max(geometry.size.width / 430, 0.68), 0.8)
      
      ZStack {
        Color.appBackground.ignoresSafeArea()
        
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: 0) {
            header(componentScale)
              .padding(.top, 18)
            
            sectorSelector(componentScale)
              .padding(.top, 22)
            
            sectionHeading(componentScale)
              .padding(.top, 20)
              .padding(.bottom, 18)
            
            levelList
            
            Spacer(minLength: 40)
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 24)
        }
      }
      .toolbar(.hidden, for: .navigationBar)
      .preferredColorScheme(.dark)
    }
    .task {
      levelSelectViewModel.configure(modelContext)
      
      levelSelectViewModel.loadLevels(for: sectors[selectedSector].0)
      levelSelectViewModel.loadCompletedLevels(for: player.gamePlayerID)
    }
    .onChange(of: selectedSector) {
      levelSelectViewModel.loadLevels(for: sectors[selectedSector].0)
    }
  }
  
  private
  func header(_ scale: Float64) -> some View
  {
    return HStack(spacing: 28) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "arrow.left")
          .font(Fonts.jbRegular(22))
          .foregroundStyle(Color.white.opacity(0.8))
          .frame(width: 36 * scale, height: 48 * scale)
      }
      .buttonStyle(.plain)

      Text("LEVEL SELECT")
        .font(Fonts.jbBold(20))
        .foregroundStyle(Color.white.opacity(0.9))

      Spacer()
    }
  }

  private
  func sectorSelector(_ scale: Float64) -> some View
  {
    return HStack(spacing: 0) {
      ForEach(sectors.indices, id: \.self) { index in
        let isSelected = selectedSector == index

        Button {
          withAnimation(.easeInOut(duration: 0.2)) {
            selectedSector = index
          }
        } label: {
          VStack(spacing: 7) {
            Text(sectors[index].0)
              .font(Fonts.jbBold(14))
              .lineLimit(1)
              .minimumScaleFactor(scale)

            Text(sectors[index].1)
              .font(Fonts.jbBold(11))
              .tracking(0.5)
              .lineLimit(1)
              .minimumScaleFactor(scale)
          }
          .foregroundStyle(
            isSelected
            ? Color.appCyan
            : Color.white.opacity(0.38)
          )
          .frame(maxWidth: .infinity, minHeight: 76)
          .background(
            isSelected
            ? Color.appCyan.opacity(0.14)
            : Color.clear
          )
          .overlay {
            if isSelected {
              Rectangle()
                .strokeBorder(
                  Color.appCyan.opacity(0.45),
                  lineWidth: 1.5
                )
            }
          }
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
      }
    }
    .padding(6)
    .background(Color.appPanel)
    .overlay {
      Rectangle()
        .strokeBorder(
          Color.white.opacity(0.09),
          lineWidth: 1.5
        )
    }
  }

  private
  func sectionHeading(_ scale: Float64) -> some View
  {
    return VStack(alignment: .leading, spacing: 12) {
      Text(String(format: "SECTOR %02d", selectedSector + 1))
      .font(Fonts.jbBold(14))
        .tracking(4)
        .foregroundStyle(Color.appCyan)

      Text(
        //- dsd: create a temp array with the names of the sectors
        // and subscript it right here using selectedSector as the
        // index.
        
        // TODO(dsd): this is harder to read but looks really cool.
        // need to decide whether to keep it or just make it readable.
        [
          sectors[0].1,
          sectors[1].1,
          sectors[2].1,
        ][selectedSector]
      )
      .font(Fonts.jbBold(26))
      .foregroundStyle(.white)
      .minimumScaleFactor(scale)
      .lineLimit(1)
    }
  }
  
  //- dsd: level unlocking happens sequentially
  // completing a level unlocks next one
  private
  func isLevelUnlocked(_ level: Level) -> Bool
  {
    let allLevels = levelSelectViewModel.levels.sorted { $0.id < $1.id }

    guard let index = allLevels.firstIndex(where: { $0.id == level.id })
    else
    {
      return false
    }

    //- dsd: the first level is always unlocked.
    if index == 0
    {
      return true
    }

    let previousLevel = allLevels[index - 1]

    return levelSelectViewModel.completedLevelIDs.contains(previousLevel.id)
  }

  // TODO(dsd): this should load according to the level list
  @ViewBuilder
  private var levelList: some View {
    let levels = sectorLevels
    
    VStack(spacing: 12) {
      ForEach(Array(levels.enumerated()), id: \.element.id) { index, level in
        let isCompleted = levelSelectViewModel.completedLevelIDs.contains(level.id)

        let isUnlocked = isLevelUnlocked(level)

        if isCompleted
        {
          ClearedLevelCard(
            number: String(format: "%02d", index + 1),
            title: level.name,
            onReplay: {
              onStartLevel(level)
            }
          )
        }
        else if isUnlocked
        {
          CurrentLevelCard(
            number: String(format: "%02d", index + 1),
            title: level.name,
            objective: "Complete within \(Int(level.timeLimit))s"
          ) {
            onStartLevel(level)
          }
        }
        else
        {
          LockedLevelCard(
            number: String(format: "%02d", index + 1),
            title: level.name
          )
        }
      }
    }
  }
}

private
struct ClearedLevelCard : View
{
  let number: String
  let title: String
  let onReplay: () -> Void

  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "checkmark")
        .font(Fonts.jbBold(20))
        .foregroundStyle(Color.appGreen)
        .frame(width: 52, height: 64)
        .background(Color.appGreen.opacity(0.13))
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.appGreen.opacity(0.4),
              lineWidth: 1.5
            )
        }

      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 8) {
          Text(number)
            .font(Fonts.jbBold(15))
            .foregroundStyle(.white.opacity(0.4))

          Text(title)
            .font(Fonts.jbBold(16))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }

        Text("CLEARED")
          .font(Fonts.jbBold(12))
          .tracking(1)
          .foregroundStyle(Color.appGreen)
      }

      Spacer(minLength: 0)

      Button(action: onReplay) {
        Text("REPLAY")
          .font(Fonts.jbBold(11))
          .foregroundStyle(.white.opacity(0.7))
          .padding(.horizontal, 12)
          .frame(height: 40)
          .background(Color.white.opacity(0.04))
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
    .padding(14)
    .frame(maxWidth: .infinity, minHeight: 108)
    .background(Color(red: 0.055, green: 0.075, blue: 0.105))
    .overlay {
      Rectangle()
        .strokeBorder(
          Color.appGreen.opacity(0.22),
          lineWidth: 1.5
        )
    }
  }
}

private
struct CurrentLevelCard : View {
  let number: String
  let title: String
  let objective: String
  let onPlay: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      HStack(alignment: .center, spacing: 12) {
        Text(number)
          .font(Fonts.jbBold(20))
          .foregroundStyle(Color.black)
          .frame(width: 64, height: 64)
          .background(
            LinearGradient(
              colors: [
                Color(red: 0.08, green: 0.65, blue: 0.91),
                Color.appCyan,
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .shadow(color: Color.appCyan.opacity(0.3), radius: 10, y: 4)

        VStack(alignment: .leading, spacing: 7) {
          HStack(spacing: 7) {
            Text(title)
              .font(Fonts.jbBold(17))
              .foregroundStyle(.white)
              .fixedSize(horizontal: false, vertical: true)
          }

          HStack(spacing: 7) {
            Image(systemName: "stopwatch")
              .foregroundStyle(Color.appCyan)

            Text("Objective: \(objective)")
              .font(Fonts.jbBold(13))
              .foregroundStyle(
                Color(red: 0.62, green: 0.77, blue: 0.86)
              )
              .fixedSize(
                horizontal: false,
                vertical: true
              )
          }
        }

        Spacer(minLength: 0)
      }

      Button(action: onPlay) {
        HStack(spacing: 12) {
          Image(systemName: "play")
          .font(Fonts.jbBold(16))

          Text("PLAY")
            .font(Fonts.jbBold(18))
            .tracking(1)
        }
        .foregroundStyle(Color.black)
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(
          LinearGradient(
            colors: [
              Color(red: 0.17, green: 0.75, blue: 0.96),
              Color(red: 0.22, green: 0.48, blue: 0.97),
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
      }
      .buttonStyle(.plain)
    }
    .padding(18)
    .background(
      LinearGradient(
        colors: [
          Color(red: 0.07, green: 0.12, blue: 0.19),
          Color(red: 0.045, green: 0.07, blue: 0.12),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .overlay {
      Rectangle()
        .strokeBorder(Color.appCyan, lineWidth: 2)
    }
    .shadow(color: Color.appCyan.opacity(0.13), radius: 18)
  }
}

private
struct LockedLevelCard : View
{
  let number: String
  let title: String

  var body: some View {
    HStack(spacing: 18) {
      Image(systemName: "lock")
        .font(Fonts.jbBold(20))
        .foregroundStyle(Color.appMuted.opacity(0.8))
        .frame(width: 52, height: 64)
        .background(Color.white.opacity(0.025))
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.white.opacity(0.035),
              lineWidth: 1.5
            )
        }

      VStack(alignment: .leading, spacing: 7) {
        HStack(spacing: 8) {
          Text(number)
            .font(Fonts.jbBold(15))

          Text(title)
            .font(Fonts.jbBold(16))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }

        Text("Locked")
          .font(Fonts.jbBold(12))
      }
      .foregroundStyle(Color.appMuted.opacity(0.75))

      Spacer(minLength: 0)

      Image(systemName: "lock.fill")
        .font(Fonts.jbRegular(18))
        .foregroundStyle(Color.appMuted.opacity(0.7))
    }
    .padding(14)
    .frame(maxWidth: .infinity, minHeight: 108)
    .background(Color.white.opacity(0.012))
    .overlay {
      Rectangle()
        .strokeBorder(
          Color.white.opacity(0.045),
          lineWidth: 1.5
        )
    }
  }
}

#Preview {
  NavigationStack {
  //  LevelSelectView()
  }
}
