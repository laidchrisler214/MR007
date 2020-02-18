//
//  DepositMethodModel.swift
//  MR007
//
//  Created by Roger Molas on 24/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum Model: String {
    //case methodId   = "id"
    case category   = "category"
    case label      = "label"
    case gateWays   = "gateways"
    case banks      = "banks" // array
    case payWay     = "payWay" // array
    case offline    = "offline"
}

class DepositMethodModel: NSObject {
    //var methodId    = ""
    var category    = ""
    var label       = ""

    var gateways    = [GateWayModel]()
    var banks       = [BankModel]()
    var payway      = [String]()

    var offline     = false

    func setMethod(data: NSDictionary) {
        //self.methodId = data[Model.methodId.rawValue] as? String ?? ""
        self.category = data[Model.category.rawValue] as? String ?? ""
        self.label = data[Model.label.rawValue] as? String ?? ""

        self.offline = ((data[Model.offline.rawValue] as? NSNumber)?.boolValue)!

        /// Set gate ways for each method model
        if data[Model.gateWays.rawValue] as? NSArray != nil {
            self.set(gateways: (data[Model.gateWays.rawValue] as? NSArray)!)
        }

        /// Set banks for each method model
        if data[Model.banks.rawValue] as? NSArray != nil {
            self.set(banks: (data[Model.banks.rawValue] as? NSArray)!)
        }

        /// Set payway methods
        if data[Model.payWay.rawValue] as? NSArray != nil {
            self.set(payways: (data[Model.payWay.rawValue] as? NSArray)!)
        }
    }

    // Set gateways
    fileprivate func set(gateways: NSArray) {
        let container = NSMutableArray()
        for gateWay in gateways {
            let gateWayModel = GateWayModel()
            gateWayModel.setGateWay(data: (gateWay as? NSDictionary)!)
            container.add(gateWayModel)
        }
        self.gateways = (container.mutableCopy() as? [GateWayModel])!
    }

    // Set banks
    fileprivate func set(banks: NSArray) {
        let container = NSMutableArray()
        for bank in banks {
            let bankModel = BankModel()
            bankModel.setBank(info: (bank as? NSDictionary)!)
            container.add(bankModel)
        }
        self.banks = (container.mutableCopy() as? [BankModel])!
    }

    // Set Payways
    fileprivate func set(payways: NSArray) {
        let container = NSMutableArray()
        for payway in payways {
            container.add(payway)
        }
        self.payway = (container.mutableCopy() as? [String])!
    }
}
