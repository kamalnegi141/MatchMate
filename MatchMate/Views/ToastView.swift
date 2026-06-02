//
//  ToastView.swift
//  MatchMate
//

import SwiftUI

enum ToastType {
    case accepted, declined, error

    var icon: String {
        switch self {
        case .accepted: return "checkmark.seal.fill"
        case .declined: return "xmark.seal.fill"
        case .error:    return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .accepted: return .green
        case .declined: return .red
        case .error:    return .orange
        }
    }
}

struct Toast {
    let message: String
    let type: ToastType
}

struct ToastView: View {
    let toast: Toast

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.type.icon)
                .foregroundColor(toast.type.color)
            Text(toast.message)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
