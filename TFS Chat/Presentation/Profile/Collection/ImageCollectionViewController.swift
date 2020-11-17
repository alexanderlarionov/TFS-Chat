//
//  ImagesCollectionViewController.swift
//  TFS Chat
//
//  Created by dmitry on 17.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    private let itemsPerRow: CGFloat = 3
    private var data: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
    }
}

extension ImageCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return data?.hits.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }
        cell.imageView.image = nil
        cell.loadImage(by: data?.hits[indexPath.row].previewURL ?? "")
        return cell
    }
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension ImageCollectionViewController {
    
    func loadImages() {
        guard let url = URL(string: "https://pixabay.com/api/?key=19139831-67087a5068526f1d9fc406fc3&q=icons&image_type=photo&per_page=150") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            self.data = try? JSONDecoder().decode(DataModel.self, from: data)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        dataTask.resume()
    }
}

struct DataModel: Decodable {
    let hits: [ImageData]
    
    struct ImageData: Decodable {
        let previewURL: String
    }
}
