//
//  Double+Extensions.swift
//  Slice
//
//  Created by Shahzaib Ali on 13/04/2025.
//

import SwiftUI
import UIKit


extension Double {


    func toInt() -> Int {
       return Int(self)
    }
   
    var sp: Double {
#if os(iOS)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
    
        
        // Base dimensions are from a standard device (e.g., iPhone 13 Pro)
        let baseWidth: Double = 428
        let baseHeight: Double = 926
        
        // Calculate scale factors for width and height
        let widthScale = screenWidth / baseWidth
        let heightScale = screenHeight / baseHeight
        
        // Use the smaller scale factor to ensure consistent sizing
        let scaleFactor = min(widthScale, heightScale)
        return self * scaleFactor
#else
        return self
#endif
    }
}
