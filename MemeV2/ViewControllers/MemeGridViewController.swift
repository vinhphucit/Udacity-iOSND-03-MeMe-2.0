//
//  MemeGridViewController.swift
//  MemeV2
//
//  Created by Phuc Tran on 3/26/18.
//  Copyright © 2018 Phuc Tran. All rights reserved.
//

import UIKit

class MemeGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row] as! Meme
        
        // Set the name and image
        cell.photo?.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetailSegue" {
            let controller = segue.destination as! ViewMemeViewController
            if let selectedIndexPath = sender as? NSIndexPath {
                controller.currentMeme = self.appDelegate.memes[selectedIndexPath.row] as! Meme
                controller.memeIndex = selectedIndexPath.row
            }
        }
    }
}


