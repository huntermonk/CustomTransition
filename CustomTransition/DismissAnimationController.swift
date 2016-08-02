//
//  DismissAnimationController.swift
//  CustomTransition
//
//  Created by Hunter Monk on 8/2/16.
//  Copyright © 2016 Hunter Monk. All rights reserved.
//

import Foundation
import UIKit

class DismissAnimationController: NSObject {
    var destinationFrame = CGRect.zero
}

extension DismissAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let containerView = transitionContext.containerView() else {
            return
        }

        let finalFrame = destinationFrame

        let snapshot = fromController.view.snapshotViewAfterScreenUpdates(false)
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true

        containerView.addSubview(toController.view)
        containerView.addSubview(snapshot)
        fromController.view.hidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView)

        toController.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)

        let duration = transitionDuration(transitionContext)

        UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeCubic, animations: {

            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
                snapshot.frame = finalFrame
            })

            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
            })

            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                toController.view.layer.transform = AnimationHelper.yRotation(0.0)
            })

            }) { (_) in
                fromController.view.hidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}