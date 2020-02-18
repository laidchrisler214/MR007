//
//  Platform.swift
//  MR007
//
//  Created by Dwaine Alingarog on 23/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import Foundation

struct Platform {
    var platformId:Int
    var urlPhoto:String?
    var name:String
    var details:String
    var type:PlatformType

    init(platformId:Int, urlPhoto:String? = nil, name:String, details:String, type:PlatformType) {
        self.platformId = platformId
        self.urlPhoto = urlPhoto
        self.name = name
        self.details = details
        self.type = type
    }
}

public enum PlatformType {
    case slotMachine
    case agFisher
    case sportsBet
}
