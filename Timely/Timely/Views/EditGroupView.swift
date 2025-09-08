//
//  EditGroupView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct EditGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupName: String
    @State private var groupDescription: String
    @State private var selectedColor: GroupColor
    @State private var members: [GroupMember]
    
    let group: Timely.Group
    let onGroupUpdated: (Timely.Group) -> Void
    
    init(group: Timely.Group, onGroupUpdated: @escaping (Timely.Group) -> Void) {
        self.group = group
        self.onGroupUpdated = onGroupUpdated
        self._groupName = State(initialValue: group.name)
        self._groupDescription = State(initialValue: group.description ?? "")
        self._selectedColor = State(initialValue: group.color)
        self._members = State(initialValue: group.members)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 4)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Edit Group")
                                .timelyStyle(.largeTitle)
                            
                            Text("Update your group details")
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
                                Text("Description")
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
                        
                        // Save Changes Button
                        Button(action: saveChanges) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save Changes")
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(canSaveChanges ? selectedColor.color : Color.gray)
                            )
                            .timelyButtonShadow()
                        }
                        .disabled(!canSaveChanges)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Edit Group")
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
    }
    
    private var canSaveChanges: Bool {
        !groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        let updatedGroup = Timely.Group(
            name: groupName.trimmingCharacters(in: .whitespacesAndNewlines),
            description: groupDescription.isEmpty ? nil : groupDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            members: members,
            color: selectedColor
        )
        
        HapticFeedback.shared.success()
        onGroupUpdated(updatedGroup)
        dismiss()
    }
}

#Preview {
    EditGroupView(
        group: Group(
            name: "Coffee Friends",
            description: "Weekly coffee meetups",
            members: [],
            color: .blue
        )
    ) { _ in }
}
