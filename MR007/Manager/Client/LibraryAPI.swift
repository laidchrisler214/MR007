//
//  LibraryAPI.swift
//  MR007
//
//  Created by Dwaine Alingarog on 23/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

/**
 Class for creating dummy data for testing purpose.
 */
class LibraryAPI: NSObject {

    /**
     Gets dummy details for home page.
     - Returns : [platform]
     */
    static func getPlatformList() -> [Platform] {
        //Dummy data for home view testing
        var platformList:[Platform] = []

        //Start inserting categories
        var platform:Platform = Platform(platformId: 1,
                                         urlPhoto: "https://firebasestorage.googleapis.com/v0/b/mr007-a71b4.appspot.com/o/assets%2Fimages%2Fag-fishing.jpeg?alt=media&token=b59faace-081b-4a5b-85ac-89d65a441b41",
                                         name: "AG捕鱼王",
                                         details: "新颖玩法 画面华丽 \n马上加入AG捕鱼的欢乐之旅吧",
                                         type: .agFisher)
        platformList.append(platform)

        platform = Platform(platformId: 2,
                            urlPhoto: "https://firebasestorage.googleapis.com/v0/b/mr007-a71b4.appspot.com/o/assets%2Fimages%2Fpt-image.jpeg?alt=media&token=af63001d-d697-4218-81e9-3ee2995cc2f0",
                            name: "PT老虎机",
                            details: "最热门的电子游戏平台 \n让您在闲暇之余享受竞技的乐趣！",
                            type: .slotMachine)
        platformList.append(platform)

        platform = Platform(platformId: 3,
                            urlPhoto: "https://firebasestorage.googleapis.com/v0/b/mr007-a71b4.appspot.com/o/assets%2Fimages%2Fag-slots.jpeg?alt=media&token=29728690-e7b7-4e57-9b80-ebf41603b7b6",
                            name: "AG真人馆",
                            details: "现场视讯 真人娱乐 \n快来跟性感动人的美女荷官互动吧！",
                            type: .sportsBet)
        platformList.append(platform)

        platform = Platform(platformId: 4,
                            urlPhoto: "https://firebasestorage.googleapis.com/v0/b/mr007-a71b4.appspot.com/o/assets%2Fimages%2Fsports-img.jpeg?alt=media&token=e6f16cb0-0685-450c-b72d-932393c29262",
                            name: "AG捕鱼王",
                            details: "新颖玩法 画面华丽 \n马上加入AG捕鱼的欢乐之旅吧！",
                            type: .slotMachine)
        platformList.append(platform)

        platform = Platform(platformId: 5,
                            urlPhoto: "https://firebasestorage.googleapis.com/v0/b/mr007-a71b4.appspot.com/o/assets%2Fimages%2Fpt-image.jpeg?alt=media&token=af63001d-d697-4218-81e9-3ee2995cc2f0",
                            name: "AG捕鱼王",
                            details: "新颖玩法 画面华丽 \n马上加入AG捕鱼的欢乐之旅吧！",
                            type: .slotMachine)
        platformList.append(platform)

        return platformList
    }
}
