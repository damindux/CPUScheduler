//
//  AppColors.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-16.
//

import SwiftUI
import SpriteKit

extension Color
{
  static let appBlue = Color(red: 0.12, green: 0.35, blue: 0.96)
  static let appGreen = Color(red: 0.02, green: 0.72, blue: 0.38)
  static let appBackground = Color(red: 0.035, green: 0.055, blue: 0.095)
  static let appPanel = Color(red: 0.075, green: 0.105, blue: 0.165)
  static let appCyan = Color(red: 0.05, green: 0.83, blue: 0.95)
  static let appMuted = Color(red: 0.30, green: 0.32, blue: 0.36)
}

extension SKColor
{
  //- dsd: Base Colors
  static let gameBlue = SKColor(red: 0.12, green: 0.35, blue: 0.96, alpha: 1.0)
  static let gameGreen = SKColor(red: 0.02, green: 0.72, blue: 0.38, alpha: 1.0)
  static let gameBackground = SKColor(red: 0.035, green: 0.055, blue: 0.095, alpha: 1.0)
  static let gamePanel = SKColor(red: 0.075, green: 0.105, blue: 0.165, alpha: 1.0)
  static let gameCyan = SKColor(red: 0.05, green: 0.83, blue: 0.95, alpha: 1.0)

  //- dsd: Additional Accent Colors
  static let gamePurple = SKColor(red: 0.63, green: 0.48, blue: 1.0, alpha: 1.0)
  static let gameYellow = SKColor(red: 1.0, green: 0.72, blue: 0.08, alpha: 1.0)
  static let gameRed = SKColor(red: 0.95, green: 0.12, blue: 0.25, alpha: 1.0)

  //- dsd: Text Colors
  static let gameText = SKColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
  static let gameSecondaryText = SKColor(red: 0.56, green: 0.63, blue: 0.72, alpha: 1.0)
  static let gameDisabledText = SKColor(red: 0.35, green: 0.40, blue: 0.48, alpha: 1.0)

  //- dsd: Borders
  static let gameBorder = SKColor(red: 0.16, green: 0.21, blue: 0.29, alpha: 1.0)
  static let gameBlueBorder = SKColor(red: 0.12, green: 0.35, blue: 0.50, alpha: 1.0)
  static let gameGreenBorder = SKColor(red: 0.02, green: 0.42, blue: 0.32, alpha: 1.0)

  //- dsd: Components
  static let gameTrack = SKColor(red: 0.025, green: 0.035, blue: 0.05, alpha: 1.0)
  static let gameTimerBackground = SKColor(red: 0.025, green: 0.035, blue: 0.05, alpha: 1.0)
  static let gameQueueBackground = SKColor(red: 0.035, green: 0.075, blue: 0.085, alpha: 1.0)
  static let gameButtonRed = SKColor(red: 0.88, green: 0.08, blue: 0.22, alpha: 1.0)

  //- dsd: Transparency Helpers
  static let gameOverlay = SKColor.black.withAlphaComponent(0.55)
  static let gameSubtleWhite = SKColor.white.withAlphaComponent(0.08)
  static let gameSubtleCyan = gameCyan.withAlphaComponent(0.12)
  static let gameSubtleGreen = gameGreen.withAlphaComponent(0.12)
  static let gameSubtlePurple = gamePurple.withAlphaComponent(0.12)
  static let gameSubtleYellow = gameYellow.withAlphaComponent(0.12)
}
