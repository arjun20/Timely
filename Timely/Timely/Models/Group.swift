//
//  Group.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import SwiftUICore

struct Group: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String?
    var members: [GroupMember]
    var color: GroupColor
    var createdAt: Date
    var isActive: Bool
    
    init(name: String, description: String? = nil, members: [GroupMember] = [], color: GroupColor = .blue) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.members = members
        self.color = color
        self.createdAt = Date()
        self.isActive = true
    }
}

struct GroupMember: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String?
    var phoneNumber: String?
    var isAdmin: Bool
    var joinedAt: Date
    
    init(name: String, email: String? = nil, phoneNumber: String? = nil, isAdmin: Bool = false) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.isAdmin = isAdmin
        self.joinedAt = Date()
    }
}

enum GroupColor: String, CaseIterable, Codable {
    case blue = "blue"
    case green = "green"
    case orange = "orange"
    case purple = "purple"
    case pink = "pink"
    case teal = "teal"
    
    var color: Color {
        switch self {
        case .blue:
            return .timelyBlue
        case .green:
            return .timelyGreen
        case .orange:
            return .timelyOrange
        case .purple:
            return .timelyPurple
        case .pink:
            return .pink
        case .teal:
            return .teal
        }
    }
    
    var emoji: String {
        switch self {
        case .blue:
            return "🔵"
        case .green:
            return "🟢"
        case .orange:
            return "🟠"
        case .purple:
            return "🟣"
        case .pink:
            return "🩷"
        case .teal:
            return "🟦"
        }
    }
}
