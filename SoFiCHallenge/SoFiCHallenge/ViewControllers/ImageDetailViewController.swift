//
//  ImageDetailViewController.swift
//  SoFiCHallenge
//
//  Created by Work on 5/29/19.
//  Copyright © 2019 Giglioroninomicon. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    @IBOutlet weak var veiwsValueLabel: UILabel!
    @IBOutlet weak var sizeValueLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    
    public var image: ImgurImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        if let dateInterval = image?.date {
            let date = Date(timeIntervalSince1970: dateInterval)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            self.dateValueLabel.text = formattedDate
        }
        
        self.title = self.image?.title
        self.descriptionValueLabel.text = image?.description
        self.veiwsValueLabel.text = "\(image?.views ?? 0)"
        self.sizeValueLabel.text = "\(image?.height ?? 0) x \(image?.width ?? 0)"
        guard let imageURL = self.image?.link else { return }
        ImageController.image(forURL: imageURL) { (image) in
            guard let detailImage = image else { return }
            self.imageView.image = detailImage
        }
    }
}
