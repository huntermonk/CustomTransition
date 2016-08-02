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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
