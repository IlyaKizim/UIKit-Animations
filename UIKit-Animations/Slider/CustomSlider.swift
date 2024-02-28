//
//  CustomSlider.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

// MARK: - UISliderDelegate

protocol UISliderDelegate: AnyObject {
    func sliderDidEndTracking(_ slider: UISlider, withValue value: Float)
}

// MARK: - CustomSlider

final class CustomSlider: UISlider {
    
    // MARK: - Properties
    
    weak var delegate: UISliderDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // Add a touch-up-inside and touch-up-outside action to the slider
        addAction(UIAction(handler: { _ in
            // Animate the slider value change over 1.5 seconds to the maximum value (1)
            UIView.animate(withDuration: 1.5) { [self] in
                setValue(1, animated: true)
            }
        }), for: [.touchUpInside, .touchUpOutside])
        
        // Configure the thumb image for the normal state
        if let thumbImage = UIImage(named: Constant.thumb) {
            // Create a circular version of the thumb image with a specified size
            let circularThumbImage = thumbImage.circularImage(size: CGSize(width: 50, height: 50))
            
            // Set the circular thumb image for the normal state
            setThumbImage(circularThumbImage, for: .normal)
        }
        
        // Configure the minimum track image for the normal state
        if let minimumTrackImage = UIImage(named: Constant.imageTrackBack) {
            // Create a circular version of the minimum track image with a specified height
            let circularTrackImage = minimumTrackImage.circularImage(size: CGSize(width: minimumTrackImage.size.width, height: 50))
            
            // Set the circular minimum track image for the normal state, making it resizable
            setMinimumTrackImage(circularTrackImage.resizableImage(withCapInsets: UIEdgeInsets(), resizingMode: .tile), for: .normal)
        }
        
        // Set an empty image for the maximum track to hide it
        setMaximumTrackImage(UIImage(), for: .normal)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Customization
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 50
        newBounds.origin.y = bounds.origin.y
        return newBounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height / 2.0
    }
    
    // MARK: - Tracking
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        delegate?.sliderDidEndTracking(self, withValue: value)
    }
}

//MARK: extentionRenderPhoto

extension UIImage {
    // Render a square photo to a round one, if there is a round photo, then you can not render
    func circularImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let roundedRect = CGRect(origin: .zero, size: size)
            context.cgContext.addEllipse(in: roundedRect)
            context.cgContext.clip()
            draw(in: roundedRect)
        }
    }
}
