//
//  PopAnimator.swift
//  CustomTransition
//
//  Created by Hunter Monk on 8/1/16.
//  Copyright © 2016 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

class PopAnimator: NSObject {
    let duration = 0.3
    var presenting = true
    var originFrame = CGRect.zero
}

extension PopAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            return
        }

        guard let toView =
            transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }

        guard let pictureView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            return
        }

        let initialFrame = presenting ? originFrame : pictureView.frame
        let finalFrame = presenting ? pictureView.frame : originFrame

        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width

        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)

        if presenting {
            pictureView.transform = scaleTransform
            pictureView.center = CGPoint(x: CGRectGetMidX(initialFrame), y: CGRectGetMidY(initialFrame))
            pictureView.clipsToBounds = true
        }

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(pictureView)

        pictureView.subviews[0].alpha = presenting ? 0 : 1
        pictureView.subviews[1].alpha = presenting ? 0 : 1

        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            pictureView.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform

            pictureView.subviews[0].alpha = self.presenting ? 1 : 0
            pictureView.subviews[1].alpha = self.presenting ? 1 : 0

            pictureView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())

                if transitionContext.transitionWasCancelled() {
                    self.resetCorners(pictureView)
                }
        }

        roundCorners(transitionContext.transitionWasCancelled(), scale: xScaleFactor, pictureView: pictureView)

    }

    func resetCorners(pictureView: UIView) {
        pictureView.layer.cornerRadius = 0
    }

    func roundCorners(transitionCancelled: Bool, scale: CGFloat, pictureView: UIView) {

        let round = CABasicAnimation(keyPath: "cornerRadius")

        round.fromValue = presenting ? 25 / scale : 0
        round.toValue = presenting ? 0 : 25 / scale
        round.duration = duration / 2
        pictureView.layer.addAnimation(round, forKey: nil)
        pictureView.layer.cornerRadius = presenting ? 0 : 25 / scale

    }
}