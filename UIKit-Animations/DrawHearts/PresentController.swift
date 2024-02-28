//
//  PresentController.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class PresentController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var heartLayer = CAShapeLayer()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(dismissButtonClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - LifeCyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        addSubviews()
        setConstraints()
        preferredContentSize = CGSize(width: Constant.widthPop, height: Constant.heightPop)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawHeart()
    }
}

//MARK: setupUI

private extension PresentController {
    
    func addSubviews() {
        view.addSubview(dismissButton)
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    @objc func dismissButtonClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - DrawingHeart

extension PresentController {
    func drawHeart() {
        heartLayer.fillColor = UIColor.clear.cgColor
        heartLayer.strokeColor = UIColor.red.cgColor
        heartLayer.lineWidth = 2.0
        view.layer.addSublayer(heartLayer)
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue = 1.0
        drawAnimation.duration = 2.0
        
        let originalRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let heartPath = UIBezierPath().getHearts(originalRect: originalRect, scale: 1.0)
        
        let translation = CGAffineTransform(translationX: view.bounds.midX - 50, y: view.bounds.midY - 50)
        heartPath.apply(translation)
        heartLayer.path = heartPath.cgPath
        heartLayer.add(drawAnimation, forKey: "drawHeartAnimation")
    }
}
