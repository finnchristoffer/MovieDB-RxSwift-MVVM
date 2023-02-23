//
//  CustomCell.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 19/02/23.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        moviePoster.image = nil
        movieTitle.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 7
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
    }
    
    func setupConstraints() {
        moviePoster.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor)
        moviePoster.setDimensions(width: contentView.widthAnchor, height: contentView.widthAnchor, widthMultiplier: 0.95, heightMultiplier: 1.3)
        
        movieTitle.anchor(top: moviePoster.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: 3)
    }
}

