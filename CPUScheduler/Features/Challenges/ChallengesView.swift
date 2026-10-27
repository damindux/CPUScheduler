//
//  ChallengesView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-05.
//

import SwiftUI

#warning("Placeholder")
struct ChallengesView : View
{
  @Environment(\.dismiss)
  private var dismiss

  @State
  private var streak = 5
  @State
  private var remainingSeconds = 4 * 3600 + 22 * 60 + 18

  private var resetTime: String {
    let hours = remainingSeconds / 3600
    let minutes = (remainingSeconds % 3600) / 60
    let seconds = remainingSeconds % 60

    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.appBackground
          .ignoresSafeArea()

        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            header

            VStack(spacing: 16) {
              challengeStatusBar

              dailyChallengeCard

              pastChallengesSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            Spacer(minLength: 32)
          }
          .frame(minHeight: geometry.size.height, alignment: .top)
        }
      }
      .preferredColorScheme(.dark)
    }
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .navigationBar)
  }

  private var header: some View {
    HStack(spacing: 24) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "arrow.left")
          .font(Fonts.jbRegular(30))
          .foregroundStyle(Color.appMuted.opacity(1.5))
          .frame(width: 40, height: 48)
      }
      .buttonStyle(.plain)

      Text("CHALLENGES")
        .font(Fonts.jbBold(27))
        .foregroundStyle(Color.white)

      Spacer(minLength: 0)
    }
    .padding(.horizontal, 32)
    .padding(.top, 36)
    .padding(.bottom, 28)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.appBackground)
  }

  private var challengeStatusBar: some View {
    HStack(spacing: 8) {
      HStack(spacing: 7) {
        Image(systemName: "flame.fill")
          .font(Fonts.jbBold(23))
          .foregroundStyle(Color.appGreen)

        Text("\(streak) DAY STREAK")
          .font(Fonts.jbBold(16))
          .tracking(1.2)
          .foregroundStyle(Color.white.opacity(0.85))
          .fixedSize()
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 9)
      .background(Color.appPanel)

      Spacer(minLength: 0)

      HStack(spacing: 6) {
        Image(systemName: "stopwatch")
          .font(Fonts.jbRegular(19))
          .foregroundStyle(Color.appMuted)

        Text("RESET IN")
          .font(Fonts.jbBold(14))
          .tracking(0.8)
          .foregroundStyle(Color.white.opacity(0.75))
          .fixedSize()

        Text(resetTime)
          .font(Fonts.jbBold(14))
          .foregroundStyle(Color.cyan)
          .fixedSize()
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 9)
      .background(Color.appPanel)
    }
  }

  private var dailyChallengeCard: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .topTrailing) {
        LinearGradient(
          colors: [
            Color.appMuted.opacity(0.65),
            Color.appMuted.opacity(0.35),
            Color.appCyan.opacity(0.20)
          ],
          startPoint: .leading,
          endPoint: .trailing
        )

        VStack(alignment: .leading, spacing: 0) {
          HStack(alignment: .top) {
            Text("DAILY CHALLENGE")
              .font(Fonts.jbBold(15))
              .tracking(1.4)
              .foregroundStyle(Color.cyan)
              .padding(.horizontal, 12)
              .padding(.vertical, 7)
              .background(Color.appCyan.opacity(0.13))

            Spacer()

            Button {
              // TODO(dsd): show daily challenge information
            } label: {
              Image(systemName: "info.circle")
                .font(Fonts.jbRegular(27))
                .foregroundStyle(Color.appMuted)
                .frame(width: 64, height: 64)
                .background(Color.black.opacity(0.55))
            }
            .buttonStyle(.plain)
          }

          Spacer(minLength: 16)

          Text("ZERO-FAULT DRIFT")
            .font(Fonts.jbBold(29))
            .tracking(-1.0)
            .foregroundStyle(Color.white)
            .minimumScaleFactor(0.75)
            .lineLimit(1)
        }
        .padding(24)
      }
      .frame(height: 176)

      HStack(alignment: .center, spacing: 12) {
        VStack(alignment: .leading, spacing: 3) {
          Text("SCORE")
            .font(Fonts.jbBold(15))
            .tracking(1.5)
            .foregroundStyle(Color.appMuted.opacity(1.5))

          Text("+500 CR")
            .font(Fonts.jbBold(29))
            .tracking(1)
            .foregroundStyle(Color.appGreen)
        }

        Spacer(minLength: 4)

        Button {
          // TODO(dsd): Launch the daily challenge.
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "play.fill")
              .font(Fonts.jbBold(17))

            Text("LAUNCH")
              .font(Fonts.jbBold(17))
          }
          .foregroundStyle(Color.black.opacity(0.8))
          .padding(.horizontal, 20)
          .frame(height: 68)
          .background(Color.appBlue)
        }
        .buttonStyle(.plain)
      }
      .padding(24)
      .background(Color.appPanel.opacity(0.7))
    }
    .background(Color.appPanel)
  }

  private var pastChallengesSection: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text("PAST CHALLENGES")
        .font(Fonts.jbBold(17))
        .foregroundStyle(Color.appMuted.opacity(1.5))
        .padding(.top, 24)

      pastChallengeRow(
        status: "CLEARED",
        title: "Cache Warmup",
        buttonTitle: "REPLAY",
        statusColor: Color.appGreen
      ) {
        // TODO(dsd): replay the old challenge
      }

      pastChallengeRow(
        status: "EXPIRED",
        title: "Deadline Sprint",
        buttonTitle: "PRACTICE",
        statusColor: Color.appMuted
      ) {
        // TODO(dsd): start Deadline Sprint practice
      }
    }
  }

  private
  func pastChallengeRow(
    status: String,
    title: String,
    buttonTitle: String,
    statusColor: Color,
    action: @escaping () -> Void
  ) -> some View
  {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 8) {
        Text(status)
          .font(Fonts.jbBold(15))
          .tracking(1.1)
          .foregroundStyle(statusColor)
          .padding(.horizontal, 10)
          .padding(.vertical, 5)
          .background(statusColor.opacity(0.18))

        Text(title)
          .font(Fonts.jbBold(23))
          .foregroundStyle(Color.white.opacity(0.9))
          .lineLimit(1)
          .minimumScaleFactor(0.75)
      }

      Spacer(minLength: 4)

      Button(action: action) {
        Text(buttonTitle)
          .font(Fonts.jbBold(15))
          .tracking(0.7)
          .foregroundStyle(Color.white.opacity(0.9))
          .padding(.horizontal, 17)
          .frame(height: 52)
          .background(Color.appMuted.opacity(0.25))
      }
      .buttonStyle(.plain)
    }
    .padding(24)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.appPanel.opacity(0.8))
  }
}

#Preview {
  NavigationStack {
    ChallengesView()
  }
}
