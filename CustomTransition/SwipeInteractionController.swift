//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by Hunter Monk on 8/1/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!

    func wireToViewController(viewController: UIViewController!) {
        self.viewController = viewController
        addRecognizer(toView: viewController.view)
    }

    private func addRecognizer(toView view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
        gesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(gesture)
    }

    func handleGesture(recognizer: UIScreenEdgePanGestureRecognizer) {

        guard let superview = recognizer.view?.superview else {
            return
        }

        let translation = recognizer.translationInView(superview)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch recognizer.state {

        case .Began:
            interactionInProgress = true
            viewController.dismissViewControllerAnimated(true, completion: nil)

        case .Changed:
            shouldCompleteTransition = progress > 0.5
            updateInteractiveTransition(progress)

        case .Cancelled:
            interactionInProgress = false
            cancelInteractiveTransition()

        case .Ended:
            interactionInProgress = false

            if shouldCompleteTransition {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }

        case .Failed, .Possible:
            print("Unsupported")

        }

    }
}