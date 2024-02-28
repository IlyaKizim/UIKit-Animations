//
//  GravityXcode.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class GravityXcode: UIViewController {
    
    //MARK: - Properties
    
    private lazy var ball: UIImageView = {
        let ball = UIImageView(frame: CGRect(x: -60, y: 300, width: 50, height: 50))
        ball.image = UIImage(named: Constant.imageForView)
        ball.alpha = 0.0
        ball.layer.cornerRadius = 25
        return ball
    }()
    
    private lazy var floorView: UIView = {
        let floorView = UIView(frame: CGRect(x: -70, y: view.bounds.height / 2, width: 600, height: 2))
        floorView.backgroundColor = UIColor.clear
        return floorView
    }()
    
    private lazy var stepOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var stepTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var stepThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var stop: UIView = {
        let view = UIView(frame: CGRect(x: view.center.x + 30, y: 0, width: 3, height: 500))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var imageLogo: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constant.imageLogo))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var imageBuildFailed: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constant.buildFailed))
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var falselightLeft: UIView = {
        let image = UIView()
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var falselightRight: UIView = {
        let image = UIView()
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var dissmis: UIButton = {
        let button = UIButton(type: .close)
        button.frame = .init(x: 10, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        return button
    }()
    
    private lazy var heightBuildFailed: NSLayoutConstraint = {
        return imageBuildFailed.heightAnchor.constraint(equalToConstant: 70)
    }()
    
    private var originalTransform: CGAffineTransform?
    private var animator: UIDynamicAnimator?
    private var timer: Timer?
    private var behavior: UICollisionBehavior?
    private var isAnimating: Bool = false
    private var isFire: Bool = false
    private var count = 0
    private var originalIvanTransform: CGAffineTransform = .identity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurate()
        ball.alpha = 1.0
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - SetupUI

private extension GravityXcode {
    func setupUI() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.addSubview(ball)
        view.addSubview(dissmis)
        view.addSubview(floorView)
        view.addSubview(stepOne)
        view.addSubview(stepTwo)
        view.addSubview(stepThree)
        view.addSubview(imageBuildFailed)
        view.addSubview(imageLogo)
        view.addSubview(stop)
        view.addSubview(falselightLeft)
        view.addSubview(falselightRight)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stepOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepOne.widthAnchor.constraint(equalToConstant: 250),
            stepOne.heightAnchor.constraint(equalToConstant: 30),
            stepOne.bottomAnchor.constraint(equalTo: floorView.topAnchor),
            
            stepTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepTwo.widthAnchor.constraint(equalToConstant: 150),
            stepTwo.heightAnchor.constraint(equalToConstant: 30),
            stepTwo.bottomAnchor.constraint(equalTo: stepOne.topAnchor),
            
            stepThree.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepThree.widthAnchor.constraint(equalToConstant: 60),
            stepThree.heightAnchor.constraint(equalToConstant: 30),
            stepThree.bottomAnchor.constraint(equalTo: stepTwo.topAnchor),
            
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: stepTwo.centerYAnchor),
            imageLogo.widthAnchor.constraint(equalToConstant: 50),
            imageLogo.heightAnchor.constraint(equalToConstant: 50),
            
            imageBuildFailed.bottomAnchor.constraint(equalTo: stepThree.topAnchor),
            imageBuildFailed.centerXAnchor.constraint(equalTo: stepThree.centerXAnchor),
            imageBuildFailed.widthAnchor.constraint(equalToConstant: 70),
            heightBuildFailed,
            
            falselightLeft.leadingAnchor.constraint(equalTo: stepOne.leadingAnchor, constant: 20),
            falselightLeft.bottomAnchor.constraint(equalTo: stepOne.topAnchor),
            falselightLeft.heightAnchor.constraint(equalToConstant: 5),
            falselightLeft.widthAnchor.constraint(equalToConstant: 20),
            
            falselightRight.trailingAnchor.constraint(equalTo: stepOne.trailingAnchor, constant: -20),
            falselightRight.bottomAnchor.constraint(equalTo: stepOne.topAnchor),
            falselightRight.heightAnchor.constraint(equalToConstant: 5),
            falselightRight.widthAnchor.constraint(equalToConstant: 20),
        ])
        view.layoutIfNeeded()
    }
}

//MARK: - Configuration

private extension GravityXcode {
    func configurate() {
        // Create boundary
        let arrayBoundary = Constant.arrayBoundary
        
        // FloorView is clear but this is necessary so that the ball does not fall down
        // "Stop Line" is clear too but needs to stop and prevent the ball from jumping further
        let arrayViews = [floorView, stepOne, stepTwo, stepThree, stop, imageBuildFailed]
        
        animator = UIDynamicAnimator(referenceView: view)
        let gravity = UIGravityBehavior(items: [ball])
        animator?.addBehavior(gravity)
        
        behavior = UICollisionBehavior(items: [ball])
        for (index, string) in arrayBoundary.enumerated() {
            behavior?.addBoundary(withIdentifier: string as NSCopying, for: UIBezierPath(rect: arrayViews[index].frame))
        }
        behavior?.collisionDelegate = self
        animator?.addBehavior(behavior ?? UICollisionBehavior())
        
        let itemBehavior = UIDynamicItemBehavior(items: [ball])
        itemBehavior.elasticity = 0.3
        itemBehavior.allowsRotation = false
        originalIvanTransform = imageBuildFailed.transform
        animator?.addBehavior(itemBehavior)
    }
    
    
}

//MARK: - GravityAnimationBall

extension GravityXcode: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if let ball = item as? UIView {
            if let identifierString = identifier as? String {
                switch identifierString {
                    //depending on the BoundaryIdentifier, we change gravity and jump so that the ball can jump onto the buildFailedImage
                case "floor", "stepOne": animatingJump(ball: ball, dx: 0.85, dy: -2.5, dxDown: 0)
                case "stepTwo": animatingJump(ball: ball, dx: 0, dy: -5, dxDown: 0.25)
                case "imageBuildFailed": animatingJump(ball: ball, dx: 0, dy: -1.5, dxDown: 0)
                    updateCollisionBoundary()
                    animatePressDown()
                case "stepThree":
                    //If the ball touches the third step, then we call the function with the addition of particles (Fireshow)
                    addParticlesAfterRemovingCell()
                    isFire = true
                default:
                    break
                }
            }
        }
    }
    
    private func animatingJump(ball: UIView, dx: Double, dy: Double, dxDown: Double) {
        if !isAnimating {
            isAnimating = true
            UIView.animate(withDuration: 0.3, animations: {
                //At each collision, we make a scale to make it look natural
                ball.transform = CGAffineTransform(scaleX: 0.8, y: 1.1)
            }, completion: { _ in
                self.isAnimating = false
            })
            animator?.behaviors.forEach { behavior in
                //creating a jump
                if let gravityBehavior = behavior as? UIGravityBehavior {
                    gravityBehavior.gravityDirection = CGVector(dx: dx, dy: dy)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animator?.behaviors.forEach { behavior in
                    //creating gravity so that the ball has gravity after the jump
                    if let gravityBehavior = behavior as? UIGravityBehavior {
                        gravityBehavior.gravityDirection = CGVector(dx: dxDown, dy: 1.2)
                    }
                }
            }
        }
    }
    
    private func updateCollisionBoundary() {
        //you need to resize the boundary so that the ball falls to the top of the buildFailedImage
        behavior?.removeBoundary(withIdentifier: "imageBuildFailed" as NSCopying)
        let insetRect = imageBuildFailed.frame.insetBy(dx: 0, dy: 19)
        behavior?.addBoundary(withIdentifier: "imageBuildFailed" as NSCopying, for: UIBezierPath(rect: insetRect))
    }
    
    private func animatePressDown() {
        // animating the pressure buildFailedImage
        UIView.animate(withDuration: 0.1) {
            self.imageBuildFailed.transform = self.originalIvanTransform.scaledBy(x: 0.8, y: 1.1)
        }completion: { _ in
            self.imageBuildFailed.transform = .identity
        }
        self.heightBuildFailed.constant -= 23
    }
}


//MARK: - FireParticlesAnimation

private extension GravityXcode {
    
    // Function to add particle effects after removing a cell
    func addParticlesAfterRemovingCell() {
        // Check if the fire effect is not active
        if !isFire {
            // Create two emitter layers for particles on the left and right sides
            let emitterLayerLeft = CAEmitterLayer()
            emitterLayerLeft.emitterPosition = CGPoint(x: 10, y: 0)
            emitterLayerLeft.emitterShape = .line
            emitterLayerLeft.emitterSize = CGSize(width: 10, height: 1)
            emitterLayerLeft.emitterMode = .outline
            
            let emitterLayerRight = CAEmitterLayer()
            emitterLayerRight.emitterPosition = CGPoint(x: 10, y: 0)
            emitterLayerRight.emitterShape = .line
            emitterLayerRight.emitterSize = CGSize(width: 10, height: 1)
            emitterLayerRight.emitterMode = .outline
            
            // Define colors for the particles
            let colors: [UIColor] = [.systemRed, .systemOrange]
            
            // Array to store emitter cells
            var cells: [CAEmitterCell] = []
            
            // Create emitter cells with specified properties for each color
            for color in colors {
                let cell = CAEmitterCell()
                cell.birthRate = 1000
                cell.lifetime = 3
                cell.velocity = -80
                cell.velocityRange = 50
                cell.emissionLongitude = .pi
                cell.emissionRange = .pi / 6
                cell.spin = 1
                cell.spinRange = 0.5
                cell.scale = 0.005
                cell.scaleRange = 0.05
                cell.contents = UIImage(named: Constant.particles)?.cgImage
                cell.color = color.cgColor
                cells.append(cell)
            }
            
            // Assign emitter cells to the left and right emitter layers
            emitterLayerLeft.emitterCells = cells
            emitterLayerRight.emitterCells = cells
            
            // Add emitter layers to the corresponding sublayers (falselightLeft and falselightRight)
            falselightLeft.layer.addSublayer(emitterLayerLeft)
            falselightRight.layer.addSublayer(emitterLayerRight)
        }
    }
}
