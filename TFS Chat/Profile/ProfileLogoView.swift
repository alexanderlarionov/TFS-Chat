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
    
    private func setupFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        prepareView(view)
    }
    
    private func prepareView(_ view: UIView) {
        //TODO how to fix for ios12? (view not loading)
        view.frame = self.bounds
        let frameWidth = view.frame.width
        view.layer.cornerRadius = frameWidth / 2
        self.firstLetterLabel.font = UIFont.boldSystemFont(ofSize: frameWidth / 2)
        self.secondLetterLabel.font = UIFont.boldSystemFont(ofSize: frameWidth / 2)
        self.lettersStackView.spacing = -frameWidth / 10
        addSubview(view)
        
        activityIndicator.startAnimating()
        
        GCDDataManager.instance.loadAvatar(
            completion: { avatar in
                self.activityIndicator.stopAnimating()
                self.setImage(avatar)
            },
            failure: {
                self.activityIndicator.stopAnimating()
            })
    }
    
}
