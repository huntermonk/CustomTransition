//
//  PictureViewController.swift
//  CustomTransition
//
//  Created by Hunter Monk on 8/2/16.
//  Copyright © 2016 Hunter Monk. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {

    @IBOutlet weak var petName: UILabel!

    @IBOutlet weak var imageView: UIImageView!

    var pet:PetCard?

    class func instantiateFromStoryboard() -> PictureViewController? {

        let storyboard = UIStoryboard(name: "PictureViewController", bundle: nil)

        let initial = storyboard.instantiateInitialViewController()

        guard let controller = initial as? PictureViewController else {
            return nil
        }

        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        petName.text = pet?.name
        imageView.image = pet?.image

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(recognizer)
    }

    func dismiss() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
