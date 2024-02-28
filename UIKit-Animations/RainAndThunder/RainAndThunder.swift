//
//  RainAndThunder.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class RainAndThunder: UIViewController {

    private lazy var dissmis: UIButton = {
        let button = UIButton(type: .close)
        button.frame = .init(x: 10, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        return button
    }()
    
    private var thunderstormLayer = CAEmitterLayer()
    private var rainCell = CAEmitterCell()
    private var lightningCell = CAEmitterCell()
    private var lightningLayer = CAEmitterLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(dissmis) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addThunderstorm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension RainAndThunder {
    // Function to create and configure the main lightning layer with a single emitter cell
    func createLightningLayer() -> CAEmitterLayer {
        // Configure emitter layer properties
        lightningLayer.emitterShape = .line
        lightningLayer.emitterMode = .outline
        lightningLayer.renderMode = .oldestFirst
        lightningLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 300)
        lightningLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        
        // Create a lightning emitter cell
        let lightningCell = createLightningCell()
        
        // Set the emitter cells for the lightning layer
        lightningLayer.emitterCells = [lightningCell]
        
        // Configure opacity animation for the lightning layer
        // it is necessary for the lightning to flicker and not just appear
        let alphaAnimation = CAKeyframeAnimation(keyPath: Constant.opacity)
        alphaAnimation.values = [0.0, 1.0, 0.0, 1.0]
        alphaAnimation.keyTimes = [1.0]
        alphaAnimation.duration = CFTimeInterval(lightningCell.lifetime)
        alphaAnimation.repeatCount = .infinity
        lightningLayer.add(alphaAnimation, forKey: Constant.opacityAnimation)
        
        return lightningLayer
    }

    // Function to add thunderstorm effect with rain and lightning layers
    func addThunderstorm() {
        // Configure thunderstorm layer properties
        thunderstormLayer.emitterShape = .line
        thunderstormLayer.emitterMode = .outline
        thunderstormLayer.renderMode = .oldestFirst
        thunderstormLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        thunderstormLayer.emitterSize = view.bounds.size
        
        // Create rain emitter cell
        let rainCell = createRainCell()
        thunderstormLayer.emitterCells = [rainCell]
        
        // Create and add the lightning layer to the view
        let lightningLayer = createLightningLayer()
        view.layer.addSublayer(thunderstormLayer)
        view.layer.addSublayer(lightningLayer)
    }

    // Function to create and configure a rain emitter cell
    func createRainCell() -> CAEmitterCell {
        // Configure rain emitter cell properties
        
        // Sets the birth rate of the emitter cell, defining the number of particles emitted per second.
        // In this case, it's set to 150, indicating a high rate.
        rainCell.birthRate = 150
        
        // The lifetime of a particle, specifying how long each particle will exist before disappearing.
        // Here, it's set to 6 seconds, meaning each raindrop particle will last for 6 seconds.
        rainCell.lifetime = 6
        
        // Specifies the initial velocity of the particles.
        // Each raindrop particle starts with a velocity of 500 units per second.
        rainCell.velocity = 500
        
        // Adds a range of variability to the velocity.
        // This can create a more natural and varied appearance for the rain.
        // The range here is set to 50, allowing for some speed variation among raindrops.
        rainCell.velocityRange = 50
        
        // Specifies the direction of particle emission in radians.
        // Here, particles are emitted vertically downward (angle: π).
        rainCell.emissionLongitude = .pi
        
        // Adds variability to the emission direction, creating a more natural spread of raindrops.
        // The emission range here is set to π/10 radians, allowing some deviation from the vertical direction.
        rainCell.emissionRange = .pi / 10
        
        // Adds a spin or rotation to each raindrop particle.
        // The spin here is set to 1.5 radians per second.
        rainCell.spin = 1.5
        
        // Adds a range of variability to the spin.
        // The spin range is set to 0.9, allowing for some variation in the spin rate among raindrops.
        rainCell.spinRange = 0.9
        
        // Specifies the initial scale of each raindrop particle.
        // The value 0.005 indicates that each raindrop starts with a small size.
        rainCell.scale = 0.005
        
        // Adds a range of variability to the scale.
        // The scale range is set to 0.05, allowing for some variation in size among raindrops.
        rainCell.scaleRange = 0.05
        
        // Assigns the content of the particle.
        // In this case, it uses an image named "particles" from the asset catalog and retrieves its cgImage.
        rainCell.contents = UIImage(named: Constant.particles)?.cgImage
        return rainCell
    }
    
    // Function to create and configure a lightning emitter cell
    func createLightningCell() -> CAEmitterCell {
        // Configure lightning emitter cell properties
        lightningCell.birthRate = 0.4
        lightningCell.lifetime = 0.2
        lightningCell.velocity = 0
        lightningCell.emissionLongitude = .pi
        lightningCell.emissionRange = .pi / 4
        lightningCell.contents = UIImage(named: Constant.thunder)?.cgImage
        return lightningCell
    }
}
