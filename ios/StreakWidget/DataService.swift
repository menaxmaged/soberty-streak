//
//  DataService.swift
//  SobertyWidgetExtension
//
//  Created by Mena Maged on 08/05/2025.
//

import Foundation
import SwiftUI


struct DataService{
    @AppStorage("streak",store: UserDefaults(suiteName: "group.net.codexeg.SobertyStreak")) private var streak = 0
    
    
    
    func log(){
        
        streak+=1
    }
    
    func progress() -> Int{
        return streak 
    }
}
