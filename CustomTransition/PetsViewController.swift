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

}

extension PetsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = view.frame.width * cellToScreenWidthRatio
        let height = view.frame.height * cellToScreenHeightRatio

        return CGSize(width: width, height: height)
        
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

        cardCell.descriptionLabel.text = petCards[indexPath.row].description

        return cardCell
    }
}
