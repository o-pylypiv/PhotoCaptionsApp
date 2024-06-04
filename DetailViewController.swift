//
//  DetailViewController.swift
//  Project13
//
//  Created by Olha Pylypiv on 20.03.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailImageView: UIImageView!
    var selectedImage: String?
    var pictureCaption: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let pictureCaption = pictureCaption {
            title = pictureCaption
        }
        
        if let imageToLoad = selectedImage {
            let path = getDocumetsDirectory().appendingPathComponent(imageToLoad)
            detailImageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func getDocumetsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
