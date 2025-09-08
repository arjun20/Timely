//
//  GroupDetailView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct GroupDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let group: Timely.Group
    let onAction: () -> Void
    
    @State private var showingEditGroup = false
    @State private var showingAddMember = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 6)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Group Header
                        VStack(spacing: 16) {
                            // Group Icon
                            ZStack {
                                Circle()
                                    .fill(group.color.color.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Text(group.color.emoji)
                                    .font(.system(size: 40))
                            }
                            
                            // Group Info
                            VStack(spacing: 8) {
                                Text(group.name)
                                    .timelyStyle(.title)
                                
                                if let description = group.description {
                                    Text(description)
                                        .timelyStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Text("Created \(group.createdAt, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Members Section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Members (\(group.members.count))")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingAddMember = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.timelyBlue)
                                }
                            }
                            .padding(.horizontal)
                            
                            if group.members.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "person.2")
                                        .font(.system(size: 40))
                                        .foregroundColor(.secondary.opacity(0.6))
                                    
                                    Text("No members yet")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(40)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.secondary.opacity(0.1))
                                )
                                .padding(.horizontal)
                            } else {
                                LazyVStack(spacing: 8) {
                                    ForEach(group.members) { member in
                                        MemberDetailRowView(member: member)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            // Start Finding Time Button
                            Button(action: {
                                onAction()
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("Find Time Together")
                                }
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(group.color.color)
                                )
                                .timelyButtonShadow()
                            }
                            
                            // Edit Group Button
                            Button(action: {
                                showingEditGroup = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Group")
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.timelyBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.timelyBlue, lineWidth: 2)
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Group Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.timelyBlue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.timelyBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditGroup) {
            EditGroupView(group: group) { updatedGroup in
                // Handle group update
            }
        }
        .sheet(isPresented: $showingAddMember) {
            AddMemberView { member in
                // Handle adding member
            }
        }
    }
}

struct MemberDetailRowView: View {
    let member: GroupMember
    
    var body: some View {
        HStack {
            // Avatar
            Circle()
                .fill(Color.timelyBlue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(member.name.prefix(1)).uppercased())
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.timelyBlue)
                )
            
            // Member Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(member.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if member.isAdmin {
                        Text("Admin")
                            .font(.caption)
                            .foregroundColor(.timelyOrange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.timelyOrange.opacity(0.1))
                            )
                    }
                }
                
                if let email = member.email {
                    Text(email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let phone = member.phoneNumber {
                    Text(phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Joined date
            VStack(alignment: .trailing, spacing: 2) {
                Text("Joined")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(member.joinedAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.timelyCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        )
        .timelyCardShadow()
    }
}

#Preview {
    GroupDetailView(
        group: Group(
            name: "Coffee Friends",
            description: "Weekly coffee meetups",
            members: [
                GroupMember(name: "Alice", email: "alice@example.com", isAdmin: true),
                GroupMember(name: "Bob", email: "bob@example.com")
            ],
            color: .blue
        )
    ) {
        // Handle action
    }
}
