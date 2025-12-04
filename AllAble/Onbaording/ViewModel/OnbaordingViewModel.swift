//
//  OnbaordingViewModel.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

//
//  OnboardingViewModel.swift
//  AllAble
//
//
//
//  OnboardingViewModel.swift
//  AllAble
//
//  Created by AllAble Architect.
//

import SwiftUI
import Combine // <--- THIS WAS MISSING. IT FIXES THE OBSERVABLE OBJECT ERRORS.

@MainActor
class OnboardingViewModel: ObservableObject {
    // Parent Data
    @Published var nationalID: String = ""
    @Published var nafathRequestID: String? = nil
    @Published var isNafathVerified: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Child Data
    @Published var childName: String = ""
    @Published var childAge: String = ""
    @Published var carbRatioInput: String = ""
    @Published var selectedSource: ICRSource = .sehaty
    @Published var medicalDocName: String? = nil
    
    enum ICRSource { case sehaty, manual }
    
    // --- Nafath Logic ---
    func triggerNafathVerification() async {
        guard !nationalID.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let reqID = try await NafathService.shared.startVerification(nationalID: nationalID)
            self.nafathRequestID = reqID
            
            // Poll for status
            let success = try await NafathService.shared.checkStatus(requestID: reqID)
            self.isNafathVerified = success
        } catch {
            self.errorMessage = "Verification failed. Please try again."
        }
        
        isLoading = false
    }
    
    // --- Sehaty Logic ---
    func fetchICRFromSehaty() async {
        isLoading = true
        do {
            let ratio = try await SehatyService.shared.fetchCarbRatio(childID: UUID().uuidString)
            self.carbRatioInput = String(format: "%.0f", ratio)
        } catch {
            self.errorMessage = "Could not fetch data from Sehaty."
        }
        isLoading = false
    }
    
    // --- Upload Logic ---
    func uploadDocument() async {
        isLoading = true
        do {
            _ = try await DocumentService.shared.uploadMedicalReport(filename: "MedicalReport.pdf")
            self.medicalDocName = "Medical_Report_Verified.pdf"
        } catch {
            self.errorMessage = "Upload failed."
        }
        isLoading = false
    }
}
