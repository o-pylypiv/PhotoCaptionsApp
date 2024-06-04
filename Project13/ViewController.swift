//
//  ViewController.swift
//  Project13
//
//  Created by Olha Pylypiv on 20.03.2024.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures.")
            }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            // we failed to get PictureCell
            fatalError("Unable to dequeue PictureCell")
        }
        let picture = pictures[indexPath.row]
        cell.imageName.text = picture.name
        
        let path = getDocumetsDirectory().appendingPathComponent(picture.image)
        cell.imageViewPicture.image = UIImage(contentsOfFile: path.path)
        
        cell.imageViewPicture.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageViewPicture.layer.borderWidth = 2
        cell.imageViewPicture.layer.cornerRadius = 3
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        let ac1 = UIAlertController(title: "Select option", message: nil, preferredStyle: .actionSheet)
        
        ac1.addAction(UIAlertAction(title: "Open image", style: .default){
            [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedImage = picture.image
                vc.pictureCaption = picture.name
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        ac1.addAction(UIAlertAction(title: "Edit caption", style: .default) {
            [weak self]_ in
            let ac2 = UIAlertController(title: "Edit caption", message: nil, preferredStyle: .alert)
            ac2.addTextField()
            
            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac2.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak ac2] _ in
                guard let newName = ac2?.textFields?[0].text else {return}
                picture.name = newName
                
                self?.tableView.reloadData()
                self?.savePicture()
            })
            self?.present(ac2, animated: true)
        })
        
        ac1.addAction(UIAlertAction(title: "Delete", style: .default){
            [weak self] _ in
            let ac3 = UIAlertController(title: "Delete this picture?", message: nil, preferredStyle: .alert)
            ac3.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac3.addAction(UIAlertAction(title: "Delete", style: .default) {
                [weak self] _ in
                self?.pictures.remove(at: indexPath.row)
                self?.tableView.reloadData()
            })
            self?.present(ac3, animated: true)
        })
        
        ac1.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac1, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumetsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let picture = Picture(name: "Caption here", image: imageName)
        pictures.append(picture)
        print(pictures)
        tableView.reloadData()
        savePicture()
        dismiss(animated: true)
    }
    
    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        //picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func savePicture() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
    
    func getDocumetsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

