//
//  SplashScreenView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.1
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            // Floating particles
            FloatingParticlesView()
                .opacity(0.6)
            
            VStack(spacing: 32) {
                Spacer()
                
                // App Icon with animation
                VStack(spacing: 24) {
                    // Main app icon
                    ZStack {
                        // Outer glow ring
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.timelyBlue.opacity(0.3), .timelyGreen.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                            .opacity(isAnimating ? 0.3 : 0.8)
                            .animation(
                                .easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        // Inner circle with gradient
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.timelyBlue, .timelyGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                // Clock icon
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(rotationAngle))
                            )
                            .scaleEffect(scale)
                            .shadow(color: .timelyBlue.opacity(0.3), radius: 20, x: 0, y: 10)
                    }
                    
                    // App name with animation
                    VStack(spacing: 8) {
                        Text("Timely")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.timelyBlue, .timelyGreen],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(opacity)
                        
                        Text("Find time together")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .opacity(opacity * 0.8)
                    }
                }
                
                Spacer()
                
                // Loading indicator
                if showContent {
                    VStack(spacing: 16) {
                        // Animated dots
                        HStack(spacing: 8) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.timelyBlue)
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                                    .animation(
                                        .easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: isAnimating
                                    )
                            }
                        }
                        
                        Text("Loading...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .opacity(0.7)
                    }
                    .opacity(opacity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            print("Splash screen appeared")
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Initial scale and opacity animation
        withAnimation(.easeOut(duration: 0.8)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Show content after initial animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                showContent = true
            }
        }
        
        // Start continuous animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isAnimating = true
            
            // Rotation animation for clock icon
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
        
        // Complete splash screen after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 0
                scale = 1.1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onComplete()
            }
        }
    }
}

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.timelyBlue.opacity(0.3),
                Color.timelyGreen.opacity(0.3),
                Color.timelyOrange.opacity(0.2),
                Color.timelyBlue.opacity(0.3)
            ],
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct FloatingParticlesView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .animation(
                        .linear(duration: particle.duration)
                        .repeatForever(autoreverses: false),
                        value: particle.position
                    )
            }
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        let colors: [Color] = [
            .timelyBlue.opacity(0.3),
            .timelyGreen.opacity(0.3),
            .timelyOrange.opacity(0.2)
        ]
        
        for i in 0..<15 {
            let particle = Particle(
                id: i,
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                color: colors.randomElement() ?? .timelyBlue.opacity(0.3),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.3...0.7),
                duration: Double.random(in: 8...15)
            )
            particles.append(particle)
        }
        
        // Animate particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                withAnimation(.linear(duration: particles[i].duration).repeatForever(autoreverses: false)) {
                    particles[i].position = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                }
            }
        }
    }
}

struct Particle: Identifiable {
    let id: Int
    var position: CGPoint
    let color: Color
    let size: CGFloat
    let opacity: Double
    let duration: Double
}

#Preview {
    SplashScreenView(onComplete: {})
}
