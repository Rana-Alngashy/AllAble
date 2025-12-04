//
//  Services.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

//Mock API Layer
//  Services.swift
//  AllAble
//

import Foundation

// MARK: - Nafath Service (Parent Verification)
class NafathService {
    static let shared = NafathService()
    
    func startVerification(nationalID: String) async throws -> String {
        // Mock network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        // Return a mock Request ID
        return "REQ-\(UUID().uuidString.prefix(8))"
    }
    
    func checkStatus(requestID: String) async throws -> Bool {
        // Mock polling delay
        try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
        // Return success
        return true
    }
}

// MARK: - Sehaty Service (Medical Data)
class SehatyService {
    static let shared = SehatyService()
    
    func fetchCarbRatio(childID: String) async throws -> Double {
        // Mock fetching data from Ministry of Health API
        try await Task.sleep(nanoseconds: 2_000_000_000)
        // Return a mock Insulin-to-Carb Ratio (e.g., 1 unit per 15g carbs)
        return 15.0
    }
}

// MARK: - Document Service (Uploads)
class DocumentService {
    static let shared = DocumentService()
    
    func uploadMedicalReport(filename: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        return true
    }
}
