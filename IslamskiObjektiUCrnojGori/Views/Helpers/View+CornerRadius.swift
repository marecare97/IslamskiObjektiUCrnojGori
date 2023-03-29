//
//  View+CornerRadius.swift
//  IslamskiObjektiUCrnojGori
//
//  Created by Marko Sentivanac on 25.3.23..
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
