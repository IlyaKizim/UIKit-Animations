//
//  VC.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class GradientButton: UIViewController {
    
    //MARK: - Properties
    
    private lazy var dissmis: UIButton = {
        let button = UIButton(type: .close)
        button.frame = .init(x: 10, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        return button
    }()
    
    private let rectangle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private let rectangleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap me"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let rectangleLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.blue.cgColor,
            UIColor.red.cgColor
        ]
        layer.startPoint = .init(x: 0, y: 1)
        layer.endPoint = .init(x: 1, y: 0)
        layer.cornerRadius = 10
        return layer
    }()
    
    //MARK: - LifeCyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}


// MARK: - setupUI

private extension GradientButton {
    func setupUI() {
        addSubview()
        setConstraints()
        addTapGesture()
    }
    
    func addSubview() {
        view.addSubview(rectangle)
        rectangle.layer.addSublayer(rectangleLayer)
        rectangle.addSubview(rectangleLabel)
        view.addSubview(dissmis)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            rectangle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rectangle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rectangle.widthAnchor.constraint(equalToConstant: 150),
            rectangle.heightAnchor.constraint(equalToConstant: 150),
            
            rectangleLabel.centerXAnchor.constraint(equalTo: rectangle.centerXAnchor),
            rectangleLabel.centerYAnchor.constraint(equalTo: rectangle.centerYAnchor),
            rectangleLabel.widthAnchor.constraint(equalToConstant: 100),
            rectangleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

// MARK: - Auto Layout

extension GradientButton {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rectangleLayer.frame = rectangle.bounds
    }
}

// MARK: - Animation

private extension GradientButton {
    
    // Function to start animating the shadow color of a rectangle
    func startAnimatingShadow() {
        // Create a keyframe animation for the "shadowColor" property
        let colorAnimation = CAKeyframeAnimation(keyPath: "shadowColor")
        
        // Define the sequence of colors for the shadow
        colorAnimation.values = [
            UIColor.blue.cgColor,
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        
        // Define the key times for each color in the sequence
        colorAnimation.keyTimes = [0, 0.25, 0.5, 1]
        
        // Set the duration of the animation
        colorAnimation.duration = 4.0
        
        // Set the animation to repeat indefinitely
        colorAnimation.repeatCount = .infinity
        
        // Set the initial shadow opacity to 1.0
        rectangle.layer.shadowOpacity = 1.0
        
        // Add the shadow color animation to the rectangle layer
        rectangle.layer.add(colorAnimation, forKey: "shadowColor")
    }
    
    // Function to start animating the gradient colors of a layer
    func startAnimatingGradient() {
        // Create a basic animation for the "colors" property of the gradient layer
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        
        // Set the initial and final values for the gradient colors
        colorAnimation.fromValue = [
            UIColor.blue.cgColor,
            UIColor.red.cgColor
        ]
        colorAnimation.toValue = [
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        
        // Set the duration of the animation
        colorAnimation.duration = 2.0
        
        // Set the animation to repeat indefinitely
        colorAnimation.repeatCount = .infinity
        
        // Enable autoreverses to make the animation back and forth
        colorAnimation.autoreverses = true
        
        // Add the gradient colors animation to the rectangle layer's gradient layer
        rectangleLayer.add(colorAnimation, forKey: "colors")
    }
    
    func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        rectangle.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc  func tap() {
        startAnimatingGradient()
        startAnimatingShadow()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.rectangleLabel.alpha = 0.0
        }) { _ in
            self.rectangleLabel.removeFromSuperview()
        }
    }
}
