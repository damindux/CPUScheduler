//
//  GameView.swift
//  CPUScheduler
//
//  Created by Student3 on 2026-10-01.
//

import SwiftUI
import SpriteKit

struct GameView : View
{
  private let gameViewModel = GameViewModel()
  
  var scene: SKScene {
    let scene = GameScene(
      gameViewModel: gameViewModel,
      size: CGSize(width: 400, height: 800),
    )
    scene.scaleMode = .resizeFill
    return scene
  }
  
  var body: some View {
    SpriteView(scene: scene)
      .ignoresSafeArea()
      .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  GameView()
}
