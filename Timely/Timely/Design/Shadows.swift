//
//  Shadows.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

extension View {
    // MARK: - Card Shadows
    func timelyCardShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )
    }
    
    func timelyCardShadowHover() -> some View {
        self.shadow(
            color: Color.black.opacity(0.15),
            radius: 12,
            x: 0,
            y: 6
        )
    }
    
    // MARK: - Button Shadows
    func timelyButtonShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.2),
            radius: 4,
            x: 0,
            y: 2
        )
    }
    
    // MARK: - Floating Element Shadows
    func timelyFloatingShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.25),
            radius: 16,
            x: 0,
            y: 8
        )
    }
    
    // MARK: - Subtle Shadows
    func timelySubtleShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.05),
            radius: 2,
            x: 0,
            y: 1
        )
    }
}
