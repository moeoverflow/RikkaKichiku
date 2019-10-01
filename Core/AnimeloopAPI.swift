//
//  AnimeloopAPI.swift
//  RikkaKichiku
//
//  Created by ShinCurry on 2019/10/1.
//  Copyright © 2019 Moeoverflow. All rights reserved.
//

import Foundation
import Alamofire

class AnimeloopAPI {
    static func getRandomFavLoops(n: Int, handler: @escaping (_ urls: [String]?) -> Void) {
        AF.request("https://api.animeloop.org/loops/best/rand?n=\(n)", method: .get).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let jsonData):
                let json = (jsonData as! Dictionary<String, Any>)["loops"] as! [Dictionary<String, Any>]
                let urls: [String] = json.map { "https://animeloop.org/files/mp4_1080p/\($0["_id"] as! String).mp4" }
                handler(urls)
                break
            case .failure(let error):
                handler(nil)
                break
            }
        })
    }
}
