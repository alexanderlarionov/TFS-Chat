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
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let frameWidth = view.frame.width
        view.layer.cornerRadius = frameWidth / 2;
        firstLetterLabel.font = UIFont.boldSystemFont(ofSize: frameWidth / 2)
        secondLetterLabel.font = UIFont.boldSystemFont(ofSize: frameWidth / 2)
        lettersStackView.spacing = -frameWidth / 10
        addSubview(view)
    }
    
}
