//
//  ViewController.swift
//  SoFiCHallenge
//
//  Created by Work on 5/29/19.
//  Copyright © 2019 Giglioroninomicon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    // MARK - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageResultsCollectionView: UICollectionView!
    
    // MARK: - Properties
    var images: [ImgurImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.imageResultsCollectionView.reloadData()
            }
        }
    }
    var page = 0
    var currentSearchTerm = "Cats" {
        didSet {
            self.title = self.currentSearchTerm
            self.page = 0
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchSearchResults(for: "cats") { (imageArray) in
            self.images = imageArray
        }
    }
    
    // MARK: - Logic Methods
    func fetchSearchResults(for searchTerm: String, completion: @escaping ([ImgurImage]) -> Void) {
        self.currentSearchTerm = searchTerm
        guard let baseUrl = NetworkController.baseUrl else { return }
        let parameters: [String:String] = ["q":searchTerm, "page": "\(self.page)"]
        NetworkController.performRequest(for: baseUrl, httpMethod: .Get, urlParameters: parameters, body: nil) { (data, error) in
            if error != nil {
                //FIXME: Handle error response
            }
            
            guard let data = data, let imgurImageArray = self.parseResponseData(data) else { return }
            completion(imgurImageArray)
        }
    }
    
    func parseResponseData(_ response: Data) -> [ImgurImage]? {
        var images: [ImgurImage] = []
        guard let responseDictionary = try? JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String:Any],
            let albumDataDictionaryArray = responseDictionary["data"] as? [[String:Any]]
            else { return nil }
        
        for albumDataDictionary in albumDataDictionaryArray {
            guard let imageDictionaryArray = albumDataDictionary["images"] as? [[String:Any]]
                else { continue }
            for imageDictionary in imageDictionaryArray {
                if imageDictionary["type"] as? String == "image/jpeg", let image = ImgurImage(dictionary: imageDictionary) {
                    images.append(image)
                }
            }
        }
        return images
    }
    
    func paginate() {
        self.page += 1
        self.fetchSearchResults(for: currentSearchTerm) { (imageArray) in
            self.images.append(contentsOf: imageArray)
        }
    }
    
    func clearCells() {
        self.images = [ImgurImage]()
    }
    
    //MARK: - Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.imgurImage = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= self.images.count - 10 {
            self.paginate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.prepareForReuse()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clearCells()
        self.resignFirstResponder()
        self.fetchSearchResults(for: self.searchTextField.text ?? "") { (images) in
            self.images = images
        }
        return true
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toImageDetails",
            let destinationVC = segue.destination as? ImageDetailViewController,
            let selectedIndexPath = imageResultsCollectionView.indexPathsForSelectedItems,
            let cell = self.imageResultsCollectionView.cellForItem(at: selectedIndexPath[0]) as? ImageCollectionViewCell
            else { return }
        
        let image = cell.imgurImage
        destinationVC.image = image
    }
}

