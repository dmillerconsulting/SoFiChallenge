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
    
    public var image: ImgurImage? {
        didSet {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        self.title = self.image?.title
        guard let imageURL = self.image?.link else { return }
        ImageController.image(forURL: imageURL) { (image) in
            guard let detailImage = image else { return }
            self.imageView.image = detailImage
        }
    }
}
