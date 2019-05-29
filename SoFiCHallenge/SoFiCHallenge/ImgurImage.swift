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
    let id: String
    var title: String = "No Title"
    let link: String
    public var image: UIImage?
    
    init(id: String, title: String, link: String) {
        self.id = id
        self.title = title
        self.link = link
    }
    
    init?(dictionary: [String:Any]) {
        print(dictionary)
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String? ?? "No title",
            let link = dictionary["link"] as? String
            else { return nil }
        
        self.id = id
        self.title = title
        self.link = link
    }
}
