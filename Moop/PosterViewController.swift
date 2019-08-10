//
//  PosterViewController.swift
//  Moop
//
//  Created by kor45cw on 09/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {
    static func instance(image: UIImage) -> PosterViewController {
        let vc: PosterViewController = PosterViewController()
        vc.targetImage = image
        return vc
    }
    
    private var imageView: UIImageView!
    private var targetImage: UIImage!
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        self.view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.image = targetImage
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.5
    public var animationDuration: TimeInterval = 0.2
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        func slideViewVerticallyTo(_ y: CGFloat) {
            self.view.frame.origin = CGPoint(x: 0, y: y)
        }

        switch panGesture.state {

        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            self.view.frame.origin = CGPoint(x: 0, y: y)

        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                          (velocity.y > minimumVelocityToHide)

            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.view.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.view.frame.origin = CGPoint(x: 0, y: 0)
                })
            }

        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.frame.origin = CGPoint(x: 0, y: 0)
            })

        }
    }
}
