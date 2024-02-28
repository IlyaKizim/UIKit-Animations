//
//  TableViewCell.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class CellForCollection: UICollectionViewCell {

    //MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var label: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = .white
       setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Methods
    
    func setupElements() {
        contentView.addSubview(label)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setup(text: String) {
        label.text = text
    }
}
