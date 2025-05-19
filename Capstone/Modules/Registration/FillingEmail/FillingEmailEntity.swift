//
//  FillingEmailEntity.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

enum FillingEmailViewFlow {
    case email
    case registration
    case login
    
    var hint: String {
        switch self {
        case .email:
            "Fill in your email"
        case .registration:
            "Create your password"
        case .login:
            "Fill in your password"
        }
    }
}
