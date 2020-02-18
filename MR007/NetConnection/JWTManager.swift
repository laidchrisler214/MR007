//
//  JWTManager.swift
//  MR007
//
//  Created by Roger Molas on 08/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import JWT

fileprivate let secretKey: String = "9mIl-RXG931vkzh7im6JXMd2QC5OlazFoJogkKPIcaAXUUmz0b-N8engAm2LFLYh"
public typealias JWTMgrAlgorithm = Algorithm
public typealias JWTMgrInvalidToken = InvalidToken

class JWTManager {

    // MARK: JWT Encoding / Decoding
    class func encodeJWT(payload: Payload) -> String {
        let data = secretKey.data(using: .utf8)!
        let encoded = JWT.encode(payload, algorithm: .hs256(data))
        return encoded
    }

    class func decodeJWT(string: String) -> Payload {
        var output: Payload? = nil
        do {
            let data = secretKey.data(using: .utf8)!
            output = try JWT.decode(string, algorithm: .hs256(data))
        } catch {
            print("Failed to decode JWT: \(error)")
        }
        return output!
    }

    class func encode(payload: Payload, algorithm: JWTMgrAlgorithm) -> String {
        let encoded = JWT.encode(payload, algorithm: algorithm)
        return encoded
    }

    class func decode(string: String, algorithm: JWTMgrAlgorithm) -> Payload {
        var output: Payload? = nil
        do {
            output = try JWT.decode(string, algorithm: algorithm)
        } catch {
            print("Failed to decode JWT: \(error)")
        }
        return output!
    }
}
