//
//  CreateGroupView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var selectedColor: GroupColor = .blue
    @State private var members: [GroupMember] = []
    @State private var newMemberName = ""
    @State private var newMemberEmail = ""
    @State private var showingAddMember = false
    
    let onGroupCreated: (Timely.Group) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 6)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Create New Group")
                                .timelyStyle(.largeTitle)
                            
                            Text("Set up a group to find time together with friends")
                                .timelyStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Group Details Card
                        VStack(spacing: 20) {
                            // Group Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Group Name")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("Enter group name", text: $groupName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                            }
                            
                            // Group Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description (Optional)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("What's this group about?", text: $groupDescription, axis: .vertical)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                                    .lineLimit(3...6)
                            }
                            
                            // Color Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Group Color")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                    ForEach(GroupColor.allCases, id: \.self) { color in
                                        ColorOptionView(
                                            color: color,
                                            isSelected: selectedColor == color
                                        ) {
                                            selectedColor = color
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.timelyCardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .timelyCardShadow()
                        .padding(.horizontal)
                        
                        // Members Section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Group Members")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingAddMember = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add Member")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.timelyBlue)
                                }
                            }
                            .padding(.horizontal)
                            
                            if members.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "person.2")
                                        .font(.system(size: 40))
                                        .foregroundColor(.secondary.opacity(0.6))
                                    
                                    Text("No members yet")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Add friends to your group to start finding time together")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(40)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.secondary.opacity(0.1))
                                )
                                .padding(.horizontal)
                            } else {
                                LazyVStack(spacing: 8) {
                                    ForEach(members) { member in
                                        MemberRowView(member: member) {
                                            removeMember(member)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Create Group Button
                        Button(action: createGroup) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Create Group")
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(canCreateGroup ? selectedColor.color : Color.gray)
                            )
                            .timelyButtonShadow()
                        }
                        .disabled(!canCreateGroup)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.timelyBlue)
                }
            }
        }
        .sheet(isPresented: $showingAddMember) {
            AddMemberView { member in
                members.append(member)
            }
        }
    }
    
    private var canCreateGroup: Bool {
        !groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func createGroup() {
        let newGroup = Timely.Group(
            name: groupName.trimmingCharacters(in: .whitespacesAndNewlines),
            description: groupDescription.isEmpty ? nil : groupDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            members: members,
            color: selectedColor
        )
        
        HapticFeedback.shared.success()
        onGroupCreated(newGroup)
        dismiss()
    }
    
    private func removeMember(_ member: GroupMember) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            members.removeAll { $0.id == member.id }
        }
    }
}

struct ColorOptionView: View {
    let color: GroupColor
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(color.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(color.color, lineWidth: isSelected ? 3 : 1)
                    .frame(width: 50, height: 50)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(color.color)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct MemberRowView: View {
    let member: GroupMember
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            // Avatar
            Circle()
                .fill(Color.timelyBlue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(member.name.prefix(1)).uppercased())
                        .font(.headline)
                        .foregroundColor(.timelyBlue)
                )
            
            // Member Info
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let email = member.email {
                    Text(email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Admin Badge
            if member.isAdmin {
                Text("Admin")
                    .font(.caption)
                    .foregroundColor(.timelyOrange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.timelyOrange.opacity(0.1))
                    )
            }
            
            // Remove Button
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

#Preview {
    CreateGroupView { _ in }
}
