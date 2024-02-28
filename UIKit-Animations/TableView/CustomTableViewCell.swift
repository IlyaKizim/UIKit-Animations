//
//  CustomTableViewCell.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 8, height: 8)
        view.layer.shadowRadius = 5
        return view
    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: Constant.checkMark))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var rectangleLayer: CAGradientLayer = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        conteinerView.layer.addSublayer(rectangleLayer)
        conteinerView.layer.cornerRadius = 10
        rectangleLayer.frame = conteinerView.bounds
    }
}

//MARK: - setupUI

extension CustomTableViewCell {
    
    private func addSubviews() {
        contentView.addSubview(indexLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.insertSubview(conteinerView, at: 0)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            conteinerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            conteinerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            conteinerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            conteinerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            indexLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),
            indexLabel.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 10),
            indexLabel.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -10),
            
            checkmarkImageView.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 10),
            checkmarkImageView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -10),
            checkmarkImageView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor)
        ])
    }
    
    func checkMarkIsHidden() {
        checkmarkImageView.isHidden.toggle()
    }
}

//MARK: - createParticlesforDeleteCellAndRemovingCell

extension CustomTableViewCell {
    func addParticlesForDeleteCell() {
        // Set the opacity of the cell's background gradient to 0 to hide removing cell animation
        rectangleLayer.opacity = 0.0
        
        //create emitterLayer
        let emitterLayer = CAEmitterLayer()
        
        // Configure emitter properties
        emitterLayer.emitterPosition = CGPoint(x: conteinerView.bounds.midX, y: conteinerView.bounds.midY)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: conteinerView.bounds.width, height: conteinerView.bounds.height - 20)
        emitterLayer.emitterMode = .volume
        
        // Configure emitter cell for particles
        // Сreate 4 different cells so that they fly in different directions and have different colors
        // it can be done in a loop so as not to write several times, but for understanding I wrote separately
        let cell = CAEmitterCell()
        
        // This sets the birth rate of the emitter cell, defining the number of particles emitted per second. In this case, it's set to 2000, indicating a high rate.
        cell.birthRate = 2000
        
        // The lifetime of a particle, specifying how long each particle will exist before disappearing. Here, it's set to 0.5 seconds.
        cell.lifetime = 0.5
        
        // Determines the initial velocity of the emitted particles. A negative value indicates the direction of emission, and the absolute value signifies the speed. Here, particles are emitted upwards with a speed of 50 units per second.
        cell.velocity = -50
        
        // Specifies the direction of particle emission in radians. Here, particles are emitted at an angle of π/4 radians (45 degrees) from the horizontal axis.
        cell.emissionLongitude = .pi / 4
        
        //  Defines the initial scale of each particle. The value 0.04 indicates that each particle starts with a small size.
        cell.scale = 0.04
        
        // Sets the spin of the particle in radians per second. Here, particles rotate at a rate of π/2 radians per second.
        cell.spin = .pi / 2
        
        // Assigns the content of the particle. In this case, it uses an image named "particles" from the asset catalog and retrieves its cgImage.
        cell.contents = UIImage(named: Constant.particles)?.cgImage
        
        // Defines the color of the particle. Here, it's set to a fully opaque red color using the RGB values.
        cell.color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        
        
        let cell2 = CAEmitterCell()
        cell2.birthRate = 2000
        cell2.lifetime = 0.5
        cell2.velocity = -50
        cell2.emissionLongitude = -.pi / 4
        cell2.scale = 0.04
        cell2.spin = .pi / 2
        cell2.contents = UIImage(named: Constant.particles)?.cgImage
        cell2.color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        
        let cell1 = CAEmitterCell()
        cell1.birthRate = 2000
        cell1.lifetime = 0.5
        cell1.velocity = -50
        cell1.emissionLongitude = -.pi / 2
        cell1.scale = 0.04
        cell1.spin = .pi / 2
        cell1.contents = UIImage(named: Constant.particles)?.cgImage
        cell1.color = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0).cgColor
        
        let cell3 = CAEmitterCell()
        cell3.birthRate = 2000
        cell3.lifetime = 0.5
        cell3.velocity = -50
        cell3.emissionLongitude = .pi / 2
        cell3.scale = 0.04
        cell3.spin = .pi / 2
        cell3.contents = UIImage(named: Constant.particles)?.cgImage
        cell3.color = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0).cgColor
        
        // Set the emitter cells for the emitter layer
        emitterLayer.emitterCells = [cell, cell2, cell1, cell3]
        
        // Add the emitter layer to the cell's container view
        conteinerView.layer.addSublayer(emitterLayer)
        
        // After a delay of 0.3 seconds, set the birth rate of the emitter layer to 0 to stop the particle animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            emitterLayer.birthRate = 0
        }
    }
    
    func addParticlesAfterRemovingCell() {
        // Set the opacity of the cell's background gradient to 1 to show cell
        rectangleLayer.opacity = 1
        
        //create emitterLayer
        let emitterLayer = CAEmitterLayer()
        
        // Configure emitter properties
        emitterLayer.emitterPosition = CGPoint(x: conteinerView.bounds.midX, y: conteinerView.bounds.midY)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: conteinerView.bounds.width, height: conteinerView.bounds.height)
        emitterLayer.emitterMode = .volume
        
        
        // Configure emitter cell for particles
        // Create 2 cells with different directions (left, right) and different color
        let cell = CAEmitterCell()
        cell.birthRate = 2000
        cell.lifetime = 0.5
        cell.velocity = 50
        cell.emissionLongitude = .pi
        cell.scale = 0.04
        cell.spin = .pi / 2
        cell.contents = UIImage(named: Constant.particles)?.cgImage
        cell.color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        
        let cell3 = CAEmitterCell()
        cell3.birthRate = 2000
        cell3.lifetime = 0.5
        cell3.velocity = -50
        cell3.emissionLongitude = .pi
        cell3.scale = 0.04
        cell3.spin = .pi / 2
        cell3.contents = UIImage(named: Constant.particles)?.cgImage
        cell3.color = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0).cgColor
        
        // Set the emitter cells for the emitter layer
        emitterLayer.emitterCells = [cell, cell3]
        
        // Add the emitter layer to the cell's container view
        conteinerView.layer.addSublayer(emitterLayer)
        
        // After a delay of 0.3 seconds, set the birth rate of the emitter layer to 0 to stop the particle animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            emitterLayer.birthRate = 0
        }
    }
}
