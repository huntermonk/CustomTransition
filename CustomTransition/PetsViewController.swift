//
//  PetsViewController.swift
//  CustomTransition
//
//  Created by Hunter Monk on 8/2/16.
//  Copyright © 2016 Hunter Monk. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PetsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let petCards = PetCardStore.defaultPets()

    var cellToScreenWidthRatio: CGFloat = 0.88

    var cellToScreenHeightRatio: CGFloat {
        return cellToScreenWidthRatio / 1.25
    }

    private let presentAnimationController = PresentAnimationController()

    private let dismissAnimationController = DismissAnimationController()

    private let swipeInteractionController = SwipeInteractionController()

    var selectedCell: CardCollectionViewCell?

}

extension PetsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = view.frame.width * cellToScreenWidthRatio
        let height = view.frame.height * cellToScreenHeightRatio

        return CGSize(width: width, height: height)
        
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? CardCollectionViewCell

        let pet = petCards[indexPath.row]

        guard let controller = PictureViewController.instantiateFromStoryboard() else {
            return
        }

        controller.pet = pet
        controller.transitioningDelegate = self

        swipeInteractionController.wireToViewController(controller)

        presentViewController(controller, animated: true, completion: nil)
    }
}

extension PetsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petCards.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)

        guard let cardCell = cell as? CardCollectionViewCell else {
            return cell
        }

        cell.layer.cornerRadius = 25

        cardCell.descriptionLabel.text = petCards[indexPath.row].description

        return cardCell
    }
}

extension PetsViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let frame = selectedCell?.frame else {
            return nil
        }
        presentAnimationController.originFrame = frame
        return presentAnimationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = selectedCell?.frame else {
            return nil
        }
        dismissAnimationController.destinationFrame = frame
        return dismissAnimationController
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
    
}
