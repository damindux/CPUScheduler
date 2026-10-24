//
//  Fonts.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-24.
//

import SwiftUI

enum Fonts
{
  static func jbBold(_ size: CGFloat) -> Font
  {
    .custom("JetBrainsMonoRoman-Bold", size: size)
  }
  
  static func jbRegular(_ size: CGFloat) -> Font
  {
    .custom("JetBrainsMonoRoman-Regular", size: size)
  }
  
  static func jbItalic(_ size: CGFloat) -> Font
  {
    .custom("JetBrainsMonoRoman-Italic", size: size)
  }
}
