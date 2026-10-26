//
//  LevelSelectView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import SwiftUI

struct LevelSelectView : View
{
  @Environment(\.dismiss) private var dismiss

  @State private var selectedSector = 0

  private let sectors = [
    ("SECTOR 1", "BASICS"),
    ("SECTOR 2", "SERVERS"),
    ("SECTOR 3", "OVERCLOCK")
  ]

  var body: some View {
    ZStack {
      Color.appBackground.ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 0) {
          header
            .padding(.top, 24)

          sectorSelector
            .padding(.top, 32)

          sectionHeading
            .padding(.top, 26)
            .padding(.bottom, 24)

          levelList

          Spacer(minLength: 40)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .preferredColorScheme(.dark)
  }

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

      Text("LEVEL SELECT")
        .font(Fonts.jbBold(24))
        .foregroundStyle(Color.white.opacity(0.9))

      Spacer()
    }
  }

  private var sectorSelector: some View {
    HStack(spacing: 0) {
      ForEach(sectors.indices, id: \.self) { index in
        let isSelected = selectedSector == index

        Button {
          withAnimation(.easeInOut(duration: 0.2)) {
            selectedSector = index
          }
        } label: {
          VStack(spacing: 10) {
            Text(sectors[index].0)
              .font(Fonts.jbBold(17))
              .lineLimit(1)
              .minimumScaleFactor(0.7)

            Text(sectors[index].1)
              .font(Fonts.jbBold(13))
              .tracking(0.5)
              .lineLimit(1)
              .minimumScaleFactor(0.7)
          }
          .foregroundStyle(
            isSelected
            ? Color.appCyan
            : Color.white.opacity(0.38)
          )
          .frame(maxWidth: .infinity, minHeight: 100)
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
    .padding(8)
    .background(Color.appPanel)
    .overlay {
      Rectangle()
        .strokeBorder(
          Color.white.opacity(0.09),
          lineWidth: 1.5
        )
    }
  }

  private var sectionHeading: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(String(format: "SECTOR %02d", selectedSector + 1))
        .font(Fonts.jbBold(17))
        .tracking(4)
        .foregroundStyle(Color.appCyan)

      #warning("Placeholder")
      Text(
        [
          "Silicon Core",
          "Server Infrastructure",
          "Overclock Protocol",
        ][selectedSector]
      )
      .font(Fonts.jbBold(32))
      .foregroundStyle(.white)
      .minimumScaleFactor(0.7)
      .lineLimit(1)
    }
  }

  // TODO(dsd): this should load according to the level list
  @ViewBuilder
  private var levelList: some View {
    switch selectedSector {
    case 0:
      VStack(spacing: 16) {
        ClearedLevelCard(
          number: "01",
          title: "Boot Sequence",
          onReplay: {
            // TODO(dsd): Load level 1.
          }
        )

        ClearedLevelCard(
          number: "02",
          title: "Web Server",
          onReplay: {
            // TODO(dsd): Load level 2.
          }
        )

        CurrentLevelCard(
          number: "03",
          title: "Database Migration",
          objective: "Beat under 20s"
        ) {
          // TODO(dsd): Start level 3.
        }

        LockedLevelCard(
          number: "04",
          title: "Memory Pressure"
        )

        LockedLevelCard(
          number: "05",
          title: "Deadline Rush"
        )
      }

    case 1:
      VStack(spacing: 16) {
        LockedLevelCard(
          number: "01",
          title: "Request Queue"
        )

        LockedLevelCard(
          number: "02",
          title: "Load Balancing"
        )

        LockedLevelCard(
          number: "03",
          title: "Distributed Cache"
        )
      }

    default:
      VStack(spacing: 16) {
        LockedLevelCard(
          number: "01",
          title: "Thermal Limits"
        )

        LockedLevelCard(
          number: "02",
          title: "Priority Inversion"
        )

        LockedLevelCard(
          number: "03",
          title: "Maximum Throughput"
        )
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
    HStack(spacing: 20) {
      Image(systemName: "checkmark")
        .font(Fonts.jbBold(25))
        .foregroundStyle(Color.appGreen)
        .frame(width: 64, height: 80)
        .background(Color.appGreen.opacity(0.13))
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.appGreen.opacity(0.4),
              lineWidth: 1.5
            )
        }

      VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 12) {
          Text(number)
            .font(Fonts.jbBold(18))
            .foregroundStyle(.white.opacity(0.4))

          Text(title)
            .font(Fonts.jbBold(20))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }

        Text("CLEARED")
          .font(Fonts.jbBold(15))
          .tracking(1)
          .foregroundStyle(Color.appGreen)
      }

      Spacer(minLength: 0)

      Button(action: onReplay) {
        Text("REPLAY")
          .font(Fonts.jbBold(14))
          .foregroundStyle(.white.opacity(0.7))
          .padding(.horizontal, 16)
          .frame(height: 50)
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
    .padding(20)
    .frame(maxWidth: .infinity, minHeight: 142)
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
    VStack(spacing: 24) {
      HStack(alignment: .center, spacing: 16) {
        Text(number)
          .font(Fonts.jbBold(25))
          .foregroundStyle(Color.black)
          .frame(width: 80, height: 80)
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

        VStack(alignment: .leading, spacing: 10) {
          HStack(spacing: 10) {
            Text(title)
              .font(Fonts.jbBold(22))
              .foregroundStyle(.white)
              .fixedSize(horizontal: false, vertical: true)

            Text("CURRENT")
              .font(Fonts.jbBold(12))
              .tracking(1)  // TODO(dsd): find what this does
              .foregroundStyle(Color.appCyan)
              .padding(.horizontal, 10)
              .padding(.vertical, 8)
              .background(Color.appCyan.opacity(0.15))
              .overlay {
                Rectangle()
                  .strokeBorder(
                    Color.appCyan.opacity(0.4),
                    lineWidth: 1
                  )
              }
          }

          HStack(spacing: 10) {
            Image(systemName: "stopwatch")
              .foregroundStyle(Color.appCyan)

            Text("Objective: \(objective)")
              .font(Fonts.jbBold(16))
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
            .font(Fonts.jbBold(20))

          Text("PLAY")
            .font(Fonts.jbBold(23))
            .tracking(1)
        }
        .foregroundStyle(Color.black)
        .frame(maxWidth: .infinity, minHeight: 82)
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
    .padding(24)
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
        .strokeBorder(Color.appCyan, lineWidth: 3)
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
    HStack(spacing: 28) {
      Image(systemName: "lock")
        .font(Fonts.jbBold(25))
        .foregroundStyle(Color.appMuted.opacity(0.8))
        .frame(width: 64, height: 80)
        .background(Color.white.opacity(0.025))
        .overlay {
          Rectangle()
            .strokeBorder(
              Color.white.opacity(0.035),
              lineWidth: 1.5
            )
        }

      VStack(alignment: .leading, spacing: 10) {
        HStack(spacing: 12) {
          Text(number)
            .font(Fonts.jbBold(18))

          Text(title)
            .font(Fonts.jbBold(20))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }

        Text("Locked")
          .font(Fonts.jbBold(15))
      }
      .foregroundStyle(Color.appMuted.opacity(0.75))

      Spacer(minLength: 0)

      Image(systemName: "lock.fill")
        .font(Fonts.jbRegular(23))
        .foregroundStyle(Color.appMuted.opacity(0.7))
    }
    .padding(20)
    .frame(maxWidth: .infinity, minHeight: 142)
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
    LevelSelectView()
  }
}
