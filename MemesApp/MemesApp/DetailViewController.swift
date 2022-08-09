//
//  DetailViewController.swift
//  MemesApp
//
//  Created by Sergii Miroshnichenko on 07.08.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    var memeOnTop: String?
    var memeOnBottom: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = selectedImage {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

            let img = renderer.image { ctx in
                let image = UIImage(named: imageToLoad)
                image?.draw(at: CGPoint(x: 0, y: 0))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 24),
                    .paragraphStyle: paragraphStyle,
                    .backgroundColor: UIColor.white.cgColor
                ]

                if let string = memeOnTop {
                    let attributedString = NSAttributedString(string: string, attributes: attrs)

                    attributedString.draw(with: CGRect(x: 12, y: 12, width: imageView.maximumContentSizeCategory.hashValue, height: imageView.maximumContentSizeCategory.hashValue), options: .usesLineFragmentOrigin, context: nil)
                }
                
                if let string = memeOnBottom {
                    let attributedString = NSAttributedString(string: string, attributes: attrs)

                    attributedString.draw(with: CGRect(x: 12, y: 475, width: imageView.maximumContentSizeCategory.hashValue, height: imageView.maximumContentSizeCategory.hashValue), options: .usesLineFragmentOrigin, context: nil)
                }
            }

            imageView.image = img
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
