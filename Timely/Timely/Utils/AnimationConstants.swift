//
//  AnimationConstants.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct AnimationConstants {
    // MARK: - Spring Animations
    static let gentleSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bouncySpring = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let smoothSpring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    // MARK: - Ease Animations
    static let quickEase = Animation.easeInOut(duration: 0.2)
    static let standardEase = Animation.easeInOut(duration: 0.3)
    static let slowEase = Animation.easeInOut(duration: 0.5)
    
    // MARK: - Custom Animations
    static let cardHover = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let buttonPress = Animation.spring(response: 0.2, dampingFraction: 0.8)
    static let pageTransition = Animation.spring(response: 0.5, dampingFraction: 0.8)
}
