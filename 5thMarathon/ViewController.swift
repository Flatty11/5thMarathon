//
//  ViewController.swift
//  5thMarathon
//
//  Created by Илья on 7/13/23.
//

import UIKit

class ViewController: UIViewController {

    let openButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.setTitle("Present", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(openButton)

        NSLayoutConstraint.activate([
            openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openButton.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                            constant: .defaultSpacing)
        ])

        openButton.addTarget(self,
                             action: #selector(openButtonTapped),
                             for: .touchUpInside)

    }

    @objc func openButtonTapped() {
        let customViewController = CustomViewController()
        customViewController.modalPresentationStyle = .overCurrentContext
        customViewController.modalTransitionStyle = .crossDissolve
        customViewController.viewReference = openButton
        present(customViewController, animated: true, completion: nil)
    }
}

class CustomViewController: UIViewController {

    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["280pt", "150pt"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
        return view
    }()

    let triangleView: TriangleView = {
        let view = TriangleView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "xmark.circle.fill")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var viewReference: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)

        view.addSubview(contentView)

        contentView.frame = .init(x: view.center.x - .width / 2,
                                  y: viewReference.frame.maxY + .defaultSpacing,
                                  width: .width, height: .firstHeight)

        contentView.addSubview(triangleView)

        NSLayoutConstraint.activate([
            triangleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            triangleView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            triangleView.widthAnchor.constraint(equalToConstant: .defaultSpacing),
            triangleView.heightAnchor.constraint(equalToConstant: .defaultSpacing)
        ])

        setupSegmentedControl()
        setupCloseButton()
    }

    private func setupSegmentedControl() {
        contentView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .defaultSpacing)
        ])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }

    private func setupCloseButton() {
        contentView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.defaultSpacing),
            closeButton.centerYAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
        ])
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc func segmentedControlValueChanged() {
        UIView.animate(withDuration: 0.3) {
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.contentView.frame.size.height = .firstHeight
            } else {
                self.contentView.frame.size.height = .secondHeight
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

class TriangleView: UIView {

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        UIColor.systemGray5.setFill()
        UIColor.clear.setStroke()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()

        context.addPath(path.cgPath)
        context.drawPath(using: .fillStroke)
    }

}

extension CGFloat {
    static let defaultSpacing: CGFloat = 20
    static let width: CGFloat = 300
    static let firstHeight: CGFloat = 280
    static let secondHeight: CGFloat = 150
}
