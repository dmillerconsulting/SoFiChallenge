//
//  ImgurImage.swift
//  SoFiCHallenge
//
//  Created by Work on 5/29/19.
//  Copyright © 2019 Giglioroninomicon. All rights reserved.
//

import Foundation
import UIKit

class ImgurImage {
    // ALL IMAGES COMING BACK WITH EMPTY TITLES FOR SOME REASON
    let id: String
    var title: String = "No Title"
    let link: String
    let description: String
    let views: Int
    let width: Int
    let height: Int
    let date: TimeInterval
    public var image: UIImage?
    
    init?(dictionary: [String:Any]) {
        print(dictionary)
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String? ?? "No title",
            let link = dictionary["link"] as? String,
            let description = dictionary["description"] as? String,
            let views = dictionary["views"] as? Int,
            let height = dictionary["height"] as? Int,
            let width = dictionary["width"] as? Int,
            let date = dictionary["datetime"] as? TimeInterval
            else { return nil }
        
        self.id = id
        self.title = title
        self.link = link
        self.description = description
        self.views = views
        self.height = height
        self.width = width
        self.date = date
    }
}
