//
//  ViewController.swift
//  D06
//
//  Created by Maxime JOUBERT on 1/28/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dynamicAnimator : UIDynamicAnimator!
    var itemBehavior: UIDynamicItemBehavior!
    var gravityBehavior : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var rotation : UIRotationGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dynamicAnimator = UIDynamicAnimator(referenceView: view)

        gravityBehavior = UIGravityBehavior(items: [])
        dynamicAnimator.addBehavior(gravityBehavior)

        collision = UICollisionBehavior(items: [])
        collision.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collision)
        
        itemBehavior = UIDynamicItemBehavior(items: [])
        itemBehavior.elasticity = 0.5
        dynamicAnimator.addBehavior(itemBehavior)

    }

    @IBAction func tapAct(_ tap: UITapGestureRecognizer) {
        let form = Form(point: tap.location(in: view), maxWidth: self.view.bounds.width, maxHeigth: self.view.bounds.height)
        view.addSubview(form)
        gravityBehavior.addItem(form)
        collision.addItem(form)
        itemBehavior.addItem(form)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        form.addGestureRecognizer(gesture)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(pinch:)))
        form.addGestureRecognizer(pinch)
        
        let rot = UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(rotation:)))
        form.addGestureRecognizer(rot)
    }
    
    @objc func panGesture(gesture : UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        switch gesture.state {
        case .began:
                self.gravityBehavior.removeItem(gesture.view!)
        case .changed:
                gesture.view?.center = gesture.location(in: self.view)
                self.dynamicAnimator.updateItem(usingCurrentState: gesture.view!)
        case .cancelled, .failed:
            print("failed")
        case .ended:
                self.gravityBehavior.addItem(gesture.view!)
        case .possible:
                print("possible")
        default:
            break;
        }
    }

    @objc func pinchGesture(pinch : UIPinchGestureRecognizer) {
        guard pinch.view != nil else { return }
        let view = pinch.view as! Form;
        
        switch pinch.state {
        case .began:
            self.gravityBehavior.removeItem(view);
        case .changed:
            self.collision.removeItem(view);
            self.itemBehavior.removeItem(view);
            view.bounds.size.width = view.originalBounds.width * pinch.scale;
            view.bounds.size.height = view.originalBounds.height * pinch.scale;
            if (view.isCircle == true) {
                view.layer.cornerRadius = view.bounds.size.width / 2
            }
            self.collision.addItem(view);
            self.itemBehavior?.addItem(view);
            self.dynamicAnimator.updateItem(usingCurrentState: view);
        case .ended:
            view.originalBounds = view.bounds;
            self.gravityBehavior.addItem(view);
        default:
            break ;
        }
    }
    
    @objc func rotationGesture(rotation: UIRotationGestureRecognizer) {
        guard rotation.view != nil else { return }
        let view = rotation.view as! Form
        
        switch rotation.state {
        case .began:
            self.gravityBehavior.removeItem(view)
        case .changed:
            self.collision.removeItem(view);
            self.itemBehavior.removeItem(view);
            rotation.view!.transform = rotation.view!.transform.rotated(by: rotation.rotation);
            rotation.rotation = 0;
            self.collision.addItem(view);
            self.itemBehavior?.addItem(view);
            self.dynamicAnimator.updateItem(usingCurrentState: view);
        case .ended:
            self.gravityBehavior.addItem(view)
        case .failed, .cancelled:
            print("failse")
        case .possible:
            print("possible")
        default:
            break;
        }
    }
}

