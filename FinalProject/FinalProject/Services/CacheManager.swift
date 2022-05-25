//
//  CacheManager.swift
//  FinalProject
//
//  Created by Dmitry on 2.05.22.
//

import Foundation
import AlamofireImage

final class CacheManager {
    
    private init() {}
    static let shared = CacheManager()
    
    let imageCache = AutoPurgingImageCache (
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
}
