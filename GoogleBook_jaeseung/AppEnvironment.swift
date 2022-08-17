//
//  AppEnvironment.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/17.
//

import Foundation

final class AppEnvironment {
    static var current = Environment()
}

struct Environment {
    
    let networkingService: NetworkingService
    
    init(networkingService: NetworkingService = NetworkManager()) {
        self.networkingService = networkingService
    }
    
}
