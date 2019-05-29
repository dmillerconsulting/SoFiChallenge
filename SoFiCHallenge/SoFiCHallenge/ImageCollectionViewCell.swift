//
//  ImageCollectionViewCell.swift
//  SoFiCHallenge
//
//  Created by Work on 5/29/19.
//  Copyright © 2019 Giglioroninomicon. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var imgurImage: ImgurImage? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    func updateViews() {
        titleLabel.text = self.imgurImage?.title
        guard let imageURL = self.imgurImage?.link else { return }
        ImageController.image(forURL: imageURL, completion: { (image) in
                self.imageView.image = image
        })
        self.activityIndicator.stopAnimating()
    }
}
