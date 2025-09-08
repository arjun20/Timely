//
//  EmptyStateView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(icon)
                .font(.system(size: 64))
                .opacity(0.6)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                .padding(.horizontal, 32)
            }
        }
        .padding(32)
    }
}

#Preview {
    VStack(spacing: 20) {
        EmptyStateView(
            icon: "📅",
            title: "No Available Times",
            message: "We couldn't find any overlapping free times in your calendars. Try expanding your search range or checking different days.",
            actionTitle: "Try Again",
            action: {}
        )
        
        EmptyStateView(
            icon: "🎉",
            title: "All Set!",
            message: "Your event has been created and added to everyone's calendar."
        )
    }
}
