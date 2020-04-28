//
//  ImageViewController.swift
//  D03
//
//  Created by Maxime JOUBERT on 1/21/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    let qos = DispatchQoS.background.qosClass
    
    var selected : String!
    var imageView : UIImageView?
    var image : UIImage?
    let refreshControl = UIRefreshControl()
    var height : CGFloat = 0.0
    var width : CGFloat = 0.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.scrollView.minimumZoomScale = self.height
        } else {
            print("Portrait")
            self.scrollView.minimumZoomScale = self.width
            print(self.scrollView.minimumZoomScale)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let queue = DispatchQueue.global(qos: qos)
        queue.async {
            let imageUrl = NSURL(string: self.selected)
            let imageData = NSData(contentsOf: imageUrl! as URL)
            DispatchQueue.main.async {
                if imageData != nil {
                    self.image = UIImage(data: imageData! as Data)
                    self.imageView = UIImageView(image: self.image)
                    self.scrollView.addSubview(self.imageView!)
                    self.scrollView.contentSize = (self.imageView!.frame.size)
                    let imageViewSize = self.imageView!.bounds.size
                    let scrollViewSize = self.scrollView.bounds.size
                    self.width = scrollViewSize.width / imageViewSize.width
                    self.height = scrollViewSize.height / imageViewSize.width
                    self.scrollView.minimumZoomScale = self.width
                    print(self.scrollView.minimumZoomScale)
                    self.scrollView.maximumZoomScale = 100
                    
                }
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
