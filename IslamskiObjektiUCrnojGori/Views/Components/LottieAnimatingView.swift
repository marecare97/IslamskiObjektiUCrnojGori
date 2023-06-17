//
//  LottieAnimatingView.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 16.6.23..
//

import UIKit
import SwiftUI
import Lottie

struct LottieAnimatingView: UIViewRepresentable {
    enum Lottie: String {
        case map_loader
    }
    let animation: Lottie
    let loopMode: LottieLoopMode = .loop
    
    init(animation: LottieAnimatingView.Lottie = .map_loader) {
        self.animation = animation
    }

    func makeUIView(context: UIViewRepresentableContext<LottieAnimatingView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(animation.rawValue)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
