//
//  Results.swift
//  ARShooter2
//
//  Created by Dmitry Apenko on 23.09.2023.
//

import Foundation

struct Results {
    var shootsCount: Int
    var beatsSpheresCount: Int
    
    init(shootsCount: Int, beatsSpheresCount: Int) {
        self.shootsCount = shootsCount
        self.beatsSpheresCount = beatsSpheresCount
    }
}
