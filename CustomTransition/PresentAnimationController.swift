//
//  PresentAnimationController.swift
//  CustomTransition
//
//  Created by Hunter Monk on 8/2/16.
//  Copyright © 2016 Hunter Monk. All rights reserved.
//

import Foundation
import UIKit

class PresentAnimationController: NSObject {
    var originFrame = CGRect.zero
}

extension PresentAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), containerView = transitionContext.containerView() else {
            return
        }

        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrameForViewController(toController)

        let snapshot = toController.view.snapshotViewAfterScreenUpdates(true)
        snapshot.frame = initialFrame
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true

        containerView.addSubview(toController.view)
        containerView.addSubview(snapshot)
        toController.view.hidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)

        let duration = transitionDuration(transitionContext)

        UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeCubic, animations: {

            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
                fromController.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
            })

            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                snapshot.layer.transform = AnimationHelper.yRotation(0.0)
            })

            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                snapshot.frame = finalFrame
            })

        }) { (_) in
            toController.view.hidden = false
            fromController.view.layer.transform = AnimationHelper.yRotation(0.0)
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}
