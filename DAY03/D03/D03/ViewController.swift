//
//  ViewController.swift
//  D03
//
//  Created by Maxime JOUBERT on 1/20/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

//    let qos = DispatchQoS.background.qosClass
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    let nasaImages : [String] = [
        "https://images-assets.nasa.gov/image/PIA01384/PIA01384~orig.jpg",
        "https://images-assets.nasa.gov/image/iss061e129986/iss061e129986~orig.jpg",
        "https://images-assets.nasa.gov/image/PIA18033/PIA18033~orig.jpg",
        "https://images-assets.nasa.gov/image/behemoth-black-hole-found-in-an-unlikely-place_26209716511_o/behemoth-black-hole-found-in-an-unlikely-place_26209716511_o~orig.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        loadImage(image: self.nasaImages[indexPath.row], cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let imageView: ImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        imageView.selected = self.nasaImages[indexPath.row]
        
        self.navigationController?.pushViewController(imageView, animated: true)
    }
    
    func loadImage(image : String, cell :CollectionViewCell) {
        cell.cellActivity.isHidden = false
        cell.cellActivity.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = URL(string: image)
        let task = URLSession.shared.dataTask(with: url!) {
            data, response, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if error != nil {
                let alerte = UIAlertController(title: "Error", message: error!.localizedDescription + image, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alerte.addAction(action)
                self.present(alerte, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                if data != nil {
                    cell.cellActivity.isHidden = true
                    cell.cellActivity.stopAnimating()
                    cell.cellImage.image = UIImage(data: data! as Data)
                }
            }
        }
        task.resume()
    }

}

