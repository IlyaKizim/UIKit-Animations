//
//  Slider.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class Slider: UIViewController {
    
    // MARK: - Properties
    
    private lazy var animatedViews: [UIView] = []
    private lazy var isAnimating: Bool = false
    private let imageViewWidthFraction: CGFloat = 4.0
    private let scaleView: CGFloat = 1.5
    private let sizeView: CGFloat = 100
    
    private lazy var slider: CustomSlider = {
        let slide = CustomSlider()
        slide.translatesAutoresizingMaskIntoConstraints = false
        return slide
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageViewLeadingConstraint: NSLayoutConstraint = {
        return imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
    }()
    
    private lazy var dissmis: UIButton = {
        let button = UIButton(type: .close)
        button.frame = .init(x: 10, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        return button
    }()
    
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


// MARK: - UI Setup

private extension Slider {
    
    func setupUI() {
        addSubviews()
        setConstraints()
        configuration()
    }
    
    func addSubviews() {
        view.addSubview(slider)
        view.addSubview(dissmis)
        view.addSubview(imageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slider.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -100),
            imageViewLeadingConstraint,
            imageView.widthAnchor.constraint(equalToConstant: sizeView),
            imageView.heightAnchor.constraint(equalToConstant: sizeView)
        ])
    }
}

// MARK: - Configuration

private extension Slider {
    
    func configuration() {
        slider.delegate = self
        slider.addTarget(self, action: #selector(drag), for: .valueChanged)
        imageView.image = UIImage(named: Constant.imageForView)
        imageView.contentMode = .scaleAspectFit
    }
    
    @objc func drag(_ event: UISlider) {
        if imageView.image != UIImage(named: Constant.imageForView) {
            imageView.image = UIImage(named: Constant.imageForView)
        }
        
        let scale = 1 + CGFloat(event.value) * (scaleView - 1)
        imageViewLeadingConstraint.constant = (slider.bounds.width - imageView.bounds.width - imageView.bounds.width / imageViewWidthFraction) * CGFloat(event.value)
        animateThumb(event)
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: CGFloat(slider.value) * .pi / 2)
    }
}

// MARK: - Animation

private extension Slider {
    
    // Function to animate thumb of a UISlider
    func animateThumb(_ event: UISlider) {
        // Get the rectangle of the thumb in the slider's coordinate system
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: slider.value)
        
        // Convert the origin of the thumb rectangle to the coordinate system of the view
        let thumbOriginInSuperview = slider.convert(thumbRect.origin, to: self.view)
        
        // Check if the animation is already in progress, if so, return
        guard !isAnimating else { return }
        
        // Create animated views for the animation
        createAnimatedViews()
        
        // Mark animation as in progress
        isAnimating = true
        
        // After a delay of 0.3 seconds, mark animation as complete and clear animated views
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimating = false
            self.animatedViews.removeAll()
        }
        
        // Arrays defining animation offsets for the views
        let arrayViewsY: [CGFloat] = [-60, 80, 40, -30]
        let arratViewsX: [CGFloat] = [10, 30, 50, 70]
        
        // Loop through animated views
        for (index, view) in animatedViews.enumerated() {
            // Calculate the center coordinates of the view relative to the thumb
            let viewCenterX = thumbOriginInSuperview.x + thumbRect.width / 2.0
            let viewCenterY = thumbOriginInSuperview.y
            
            // Set initial position and alpha of the view
            view.frame.origin.y = viewCenterY
            view.frame.origin.x = viewCenterX - 20
            view.alpha = 1.0
            
            // Perform the animation
            UIView.animate(withDuration: 1, animations: {
                view.isHidden = false
                view.frame.origin.y -= arrayViewsY[index]
                view.frame.origin.x -= arratViewsX[index]
                view.alpha = 0.5
                self.view.addSubview(view)
            }, completion: { _ in
                // Remove the view from the superview after animation completion
                view.removeFromSuperview()
            })
        }
    }
    
    // Helper function to create animated views
    private func createAnimatedViews() {
        // Image names for the animated views
        let imageNames = ["1", "2", "3", "4"]
        
        // Loop through image names to create UIImageViews within UIViews
        for (_, imageName) in imageNames.enumerated() {
            let view = UIView()
            view.isHidden = true
            view.frame.size = CGSize(width: 30, height: 30)
            
            // Create UIImageView and configure it with the image
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = view.bounds
            imageView.contentMode = .scaleAspectFit
            
            // Add UIImageView to the UIView
            view.addSubview(imageView)
            
            // Add the created view to the array of animated views
            animatedViews.append(view)
        }
    }
    
}

// MARK: - SliderDelegate

extension Slider: UISliderDelegate {
    func sliderDidEndTracking(_ slider: UISlider, withValue value: Float) {
        UIView.animate(withDuration: 1.5 , animations: {
            self.imageViewLeadingConstraint.constant = slider.bounds.width - self.imageView.bounds.width - self.imageView.bounds.width / self.imageViewWidthFraction
            self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5).rotated(by: .pi / 2)
            self.view.layoutIfNeeded()
        }) { _ in
            self.imageView.image = UIImage(named: Constant.buildFailedReversed)
        }
    }
}
