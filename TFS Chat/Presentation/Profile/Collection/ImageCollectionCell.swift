//
//  ImageCollectionCell.swift
//  TFS Chat
//
//  Created by dmitry on 17.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    func loadImage(by url: String) {
        guard let url = URL(string: url) else {return}
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        dataTask.resume()
    }
}
