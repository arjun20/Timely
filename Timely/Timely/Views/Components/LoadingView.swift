//
//  LoadingView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Outer glow ring
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
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.5 : 0.8)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
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
            
            Text("Finding your perfect time...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .opacity(isAnimating ? 0.6 : 1.0)
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

struct PulsingDot: View {
    @State private var isPulsing = false
    let color: Color
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .scaleEffect(isPulsing ? 1.5 : 1.0)
            .opacity(isPulsing ? 0.3 : 1.0)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

struct DotsLoadingView: View {
    var body: some View {
        HStack(spacing: 8) {
            PulsingDot(color: .timelyBlue, delay: 0)
            PulsingDot(color: .timelyGreen, delay: 0.2)
            PulsingDot(color: .timelyOrange, delay: 0.4)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        LoadingView()
        DotsLoadingView()
    }
    .padding()
}
