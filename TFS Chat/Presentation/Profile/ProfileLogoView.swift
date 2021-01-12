//
//  ProfileLogoView.swift
//  TFS Chat
//
//  Created by dmitry on 02.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileLogoView: UIView {
    
    var view: UIView?
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var firstLetterLabel: UILabel!
    @IBOutlet var secondLetterLabel: UILabel!
    @IBOutlet var lettersStackView: UIStackView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupFromNib()
    }
    
    func setImage(_ image: UIImage) {
        profileImage.image = image
    }
    
    
    /// Советую под это дело завести удобную категорию;
    /// Пример: https://stackoverflow.com/a/53937885/2742161
    
    private func setupFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    /// Странное название для метода в классе Лого;
    /// Тут в принципе не важно что какая-то загрузка завершилась
    /// Я бы предложил назвать как-то вроде load(with dataManager: FileStorageServiceProtocol)

    func finishViewLoading(dataManager: FileStorageServiceProtocol) {
        //TODO how to fix for ios12? (view not loading)
        
        
        /// Я бы сделал addSubview(view) сразу после её создания
        /// Для актулизации размеров указывал бы frame в переопределенном методе layoutSubviews;
        
        guard let view = view else { return }
        view.frame = self.bounds
        let frameWidth = view.frame.width
        view.layer.cornerRadius = frameWidth / 2
        self.firstLetterLabel.font = UIFont.boldSystemFont(ofSize: frameWidth / 2)
        self.secondLetterLabel.font = UIFont.boldSystemFont(ofSize: frameWidth / 2)
        self.lettersStackView.spacing = -frameWidth / 10
        addSubview(view)
        
        activityIndicator.startAnimating()
        
        dataManager.loadAvatar(
            completion: { avatar in
                self.activityIndicator.stopAnimating()
                self.setImage(avatar)
            },
            failure: {
                self.activityIndicator.stopAnimating()
                self.lettersStackView.isHidden = false
                view.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
            })
    }
    
}
