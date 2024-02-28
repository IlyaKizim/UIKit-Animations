//
//  DrawHearts.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class DrawHearts: UIViewController {
    
    //MARK: - Properties
    
    private lazy var dissmis: UIButton = {
        let button = UIButton(type: .close)
        button.frame = .init(x: 10, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        return button
    }()
    
    private lazy var button: UIButton = {
        let button = ButtonCast()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.present, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(pushPopover), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
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

//MARK: - setupUI

private extension DrawHearts {
    
    func setupUI() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.addSubview(button)
        view.addSubview(dissmis)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    @objc  func pushPopover() {
        let controller = PresentController()
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = button
        controller.popoverPresentationController?.permittedArrowDirections = .up
        controller.popoverPresentationController?.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

//MARK: - UIPopoverPresentationControllerDelegate

extension DrawHearts: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) ->
    UIModalPresentationStyle {
        return .none
    }
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
