//
//  SubscriptionManager.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 26/11/2025.
//

import Foundation
import SwiftUI
import Combine
import UIKit
import RevenueCat
class SubscriptionManager: ObservableObject {
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false

    static let shared = SubscriptionManager()

    private init() {
//        Purchases.configure(withAPIKey: "test_eyjJlseGtdGTErXtgAplnwYopAO")
        Purchases.configure(withAPIKey: "appl_oRVzZmEXgHognioplTrepDvSPry")
    }

    func refreshStatus() {
        Task {
            do {
             
                let customerInfo = try await Purchases.shared.customerInfo()
                self.isPremiumUser = customerInfo.entitlements.all["pro"]?.isActive == true
                print("checkEntitlement() :  isPremiumUser \( self.isPremiumUser) ")
            } catch {
                print("checkEntitlement() :  Error \(error) ")
            }
        }
    }
}
