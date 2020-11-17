//
//  ImagesCollectionViewController.swift
//  TFS Chat
//
//  Created by dmitry on 17.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    private let itemsPerRow: CGFloat = 3
    private var data: DataModel?
    var setAvatarBlock: ((UIImage) -> Void)?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadPreviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data?.hits.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }
        guard let previewURL = data?.hits[indexPath.row].previewURL else { return UICollectionViewCell() }
        let placeholder = UIImage(named: "profile")
        cell.setImage(placeholder)
        loadImage(url: previewURL) { image in
            cell.setImage(image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let webformatURL = data?.hits[indexPath.row].webformatURL else { return }
        loadImage(url: webformatURL) { image in
            self.setAvatarBlock?(image)
            self.dismiss(animated: true)
        }
        
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
    
}

extension ImageCollectionViewController {
    
    func loadPreviews() {
        guard let url = URL(string: "https://pixabay.com/api/?key=19139831-67087a5068526f1d9fc406fc3&q=icons&image_type=photo&per_page=150") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            self.data = try? JSONDecoder().decode(DataModel.self, from: data)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
        dataTask.resume()
    }
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else {return}
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        dataTask.resume()
    }
}

struct DataModel: Decodable {
    let hits: [ImageData]
    
    struct ImageData: Decodable {
        let previewURL: String
        let webformatURL: String
    }
}

extension ImageCollectionViewController: Themable {
    
    func adjustViewForCurrentTheme() {
        let theme = ThemeManager.instance.currentTheme
        collectionView.backgroundColor = theme.navigationBarColor
    }
}
