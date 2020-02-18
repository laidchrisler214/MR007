//
//  LaunchGameRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case ttg = "m/ttg/launch"
    case agsbGames = "m/lobby/games"
    case ttgswggGames = "m/lobby/games/launch"
    case ptGames = "m/pt/launch"
}

class LaunchGameRequestManager: APIRequestManager {
    /// Launch PT Game Platform
    func launchTTGGame(completionHandler: @escaping(_ user: UserModel?, _ urlString: String?) -> Void,
                       error: RequestErrorBlock?,
                       param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: String?) in
            print("Game URL: \(String(describing: data))")
            completionHandler(user, data!)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.ttg.rawValue, param: param, tag: 0)
    }

    /// Launch Game Platform outside app
    func launchExternalRequest(param: NSDictionary, platform: String) {
        var request:URLRequest? = nil
        request = URLBuilder().buildGETRequest(api: "\(platform)/launch", params: param)
        print("HTTP Request : \(String(describing: request?.url?.absoluteString))")
        print("Parameter: \(param)")

        UIApplication.shared.open((request?.url!)!, options: ["launch":"game"], completionHandler: nil)
    }

    func launchAGGames(completionHandler: @escaping(_ user: UserModel?, _ urlString: String?) -> Void,
                         error: RequestErrorBlock?,
                         param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let urlString = (data!["url"] as? String)!
            print("Game URL: \(String(describing: urlString))")
            completionHandler(user, urlString)
        }, error: { (_error) in
            error!(_error)

        }, urlString: API.agsbGames.rawValue, param: param, tag: 0)
    }

    func launchSBGames(completionHandler: @escaping(_ user: UserModel?, _ webUrl: String?, _ mobileUrl: String?) -> Void,
                         error: RequestErrorBlock?,
                         param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let webUrlString = (data!["web_url"] as? String)!
            let mobileUrlString = (data!["mobile_url"] as? String)!
            completionHandler(user, webUrlString, mobileUrlString)
        }, error: { (_error) in
            error!(_error)

        }, urlString: API.agsbGames.rawValue, param: param, tag: 0)
    }

    func launchTTGSWGGGames(completionHandler: @escaping(_ user: UserModel?, _ urlString: String?) -> Void,
                         error: RequestErrorBlock?,
                         param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: String?) in
            print("Game URL: \(String(describing: data))")
            completionHandler(user, data!)
        }, error: { (_error) in
            error!(_error)

        }, urlString: API.ttgswggGames.rawValue, param: param, tag: 0)
    }

    func launchPTGames(completionHandler: @escaping(_ user: UserModel?, _ urlString: String?) -> Void,
                            error: RequestErrorBlock?,
                            param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: String?) in
            print("Game URL: \(String(describing: data))")
            completionHandler(user, data!)
        }, error: { (_error) in
            error!(_error)

        }, urlString: API.ptGames.rawValue, param: param, tag: 0)
    }
}
