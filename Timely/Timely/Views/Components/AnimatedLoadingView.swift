//
//  AnimatedLoadingView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct AnimatedLoadingView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    let message: String
    let showMessage: Bool
    
    init(message: String = "Loading...", showMessage: Bool = true) {
        self.message = message
        self.showMessage = showMessage
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Animated loading indicator
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.timelyBlue.opacity(0.3), .timelyGreen.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotationAngle))
                
                // Inner spinning circle
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.timelyBlue, .timelyGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(rotationAngle))
                    .scaleEffect(scale)
            }
            
            if showMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .opacity(isAnimating ? 0.6 : 1.0)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Rotation animation
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Scale animation
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.1
        }
        
        // Opacity animation for text
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

struct PulsingLoadingView: View {
    @State private var isPulsing = false
    @State private var opacity: Double = 0.3
    
    let color: Color
    let size: CGFloat
    
    init(color: Color = .timelyBlue, size: CGFloat = 20) {
        self.color = color
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .opacity(opacity)
                    .scaleEffect(isPulsing ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: isPulsing
                    )
            }
        }
        .onAppear {
            withAnimation {
                isPulsing = true
            }
        }
    }
}

struct WaveLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [.timelyBlue, .timelyGreen],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 4, height: isAnimating ? 30 : 10)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        AnimatedLoadingView(message: "Finding available times...")
        
        PulsingLoadingView()
        
        WaveLoadingView()
    }
    .padding()
}
