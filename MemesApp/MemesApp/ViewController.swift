//
//  ViewController.swift
//  MemesApp
//
//  Created by Sergii Miroshnichenko on 07.08.2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var memeImages = [String]()
    
    var memeOnTop = ""
    var memeOnBottom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memes"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importImage)), UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(delImage))]
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(topMem)), UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(bottomMem))]
        
        let defaults = UserDefaults.standard

        if let savedMeme = defaults.object(forKey: "meme") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                memeImages = try jsonDecoder.decode([String].self, from: savedMeme)
            } catch {
                print("Failed to load meme")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeImage", for: indexPath)
        
        let meme = memeImages[indexPath.item]
        let path = getDocumentsDirectory().appendingPathComponent(meme)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = UIImage(contentsOfFile: path.path)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let path = getDocumentsDirectory().appendingPathComponent(memeImages[indexPath.item])
            
            vc.selectedImage = path.path
            vc.memeOnTop = memeOnTop
            vc.memeOnBottom = memeOnBottom

            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func delImage() {
        let ac = UIAlertController(title: "Delete", message: nil, preferredStyle: .actionSheet)
        for (number, mem) in memeImages.enumerated() {
            ac.addAction(UIAlertAction(title: mem, style: .default, handler: { [self] _ in
                memeImages.remove(at: number)
                collectionView.reloadData()
                save()
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func topMem() {
        promptMem("top")
    }
    
    @objc func bottomMem() {
        promptMem("bottom")
    }
    
    func promptMem(_ side: String) {
        let ac = UIAlertController(title: "MEM", message: "Enter the new mem for \(side)", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, self] _ in
            guard let mem = ac?.textFields?[0].text else { return }
            
            if side == "top" {
                memeOnTop = mem
            } else if side == "bottom" {
                memeOnBottom = mem
            }
            
            save()
            collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        memeImages.append(imageName)
        save()
        collectionView.reloadData()

        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(memeImages) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "meme")
        } else {
            print("Failed to save meme.")
        }
    }
}

