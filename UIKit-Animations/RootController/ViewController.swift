//
//  ViewController.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionView)
        collection.backgroundColor = .systemGray2
        collectionView.scrollDirection = .vertical
        collection.register(CellForCollection.self, forCellWithReuseIdentifier: CellForCollection.identifier)
        collectionView.minimumLineSpacing = Constant.minimumLineSpacing
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    //MARK: - LifeCyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .clear
    }
}

//MARK: - setupUI

private extension ViewController {
    func setupUI() {
        addSubviews()
        setupConstraints()
        view.backgroundColor = .systemGray2
        title = "UIKit Animations"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSolutions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellForCollection.identifier, for: indexPath) as? CellForCollection else {return UICollectionViewCell()}
        let model = allSolutions.allCases[indexPath.row].rawValue
        cell.setup(text: model)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: Constant.heightItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = getController(indexPath: indexPath.row)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getController(indexPath: Int) -> UIViewController {
        let controller: UIViewController
        switch indexPath {
        case 0: controller = GradientButton()
        case 1: controller = Slider()
        case 2: controller = TableView()
        case 3: controller = DrawHearts()
        case 4: controller = GravityXcode()
        case 5: controller = RainAndThunder()
        default: controller = ViewController()
        }
        return controller
    }
}
