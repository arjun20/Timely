//
//  AppWideBackgroundView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct AppWideBackgroundView: View {
    @State private var animateGradient = false
    @State private var animateParticles = false
    @State private var particles: [BackgroundParticle] = []
    @State private var rotationAngle: Double = 0
    
    let showFloatingParticles: Bool
    let particleCount: Int
    
    init(showFloatingParticles: Bool = true, particleCount: Int = 12) {
        self.showFloatingParticles = showFloatingParticles
        self.particleCount = particleCount
    }
    
    var body: some View {
        ZStack {
            // Base animated gradient (same as splash screen)
            LinearGradient(
                colors: [
                    Color.timelyBlue.opacity(0.1),
                    Color.timelyGreen.opacity(0.1),
                    Color.timelyOrange.opacity(0.05),
                    Color.timelyBlue.opacity(0.1)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            
            // Floating particles (same as splash screen)
            if showFloatingParticles {
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
                .ignoresSafeArea()
            }
            
            // Subtle mesh gradient overlay
            MeshGradientOverlay()
                .opacity(0.2)
            
            // Subtle floating orbs
            FloatingOrbsView()
                .opacity(0.3)
        }
        .onAppear {
            startAnimations()
            if showFloatingParticles {
                generateParticles()
            }
        }
    }
    
    private func startAnimations() {
        // Gradient animation
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
            animateGradient.toggle()
        }
        
        // Particle animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                animateParticles.toggle()
            }
        }
    }
    
    private func generateParticles() {
        let colors: [Color] = [
            .timelyBlue.opacity(0.15),
            .timelyGreen.opacity(0.12),
            .timelyOrange.opacity(0.1)
        ]
        
        for i in 0..<particleCount {
            let particle = BackgroundParticle(
                id: i,
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                color: colors.randomElement() ?? .timelyBlue.opacity(0.15),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.3...0.7),
                blur: 0,
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

struct FloatingOrbsView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Large orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.timelyBlue.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .position(
                        x: geometry.size.width * 0.2,
                        y: geometry.size.height * 0.3
                    )
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 4.0)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
                
                // Medium orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.timelyGreen.opacity(0.08),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .position(
                        x: geometry.size.width * 0.8,
                        y: geometry.size.height * 0.7
                    )
                    .scaleEffect(animate ? 0.9 : 1.1)
                    .animation(
                        .easeInOut(duration: 3.0)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
                
                // Small orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.timelyOrange.opacity(0.06),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .position(
                        x: geometry.size.width * 0.6,
                        y: geometry.size.height * 0.2
                    )
                    .scaleEffect(animate ? 1.1 : 0.9)
                    .animation(
                        .easeInOut(duration: 5.0)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

// MARK: - View Modifier
struct AppWideBackgroundModifier: ViewModifier {
    let showFloatingParticles: Bool
    let particleCount: Int
    
    func body(content: Content) -> some View {
        ZStack {
            AppWideBackgroundView(showFloatingParticles: showFloatingParticles, particleCount: particleCount)
            content
        }
    }
}

extension View {
    func appWideBackground(showFloatingParticles: Bool = true, particleCount: Int = 12) -> some View {
        modifier(AppWideBackgroundModifier(showFloatingParticles: showFloatingParticles, particleCount: particleCount))
    }
}

#Preview {
    VStack {
        Text("App Wide Background")
            .font(.title)
            .foregroundColor(.primary)
        Spacer()
    }
    .appWideBackground()
}
