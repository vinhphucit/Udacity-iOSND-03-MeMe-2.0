//
//  ViewMemeViewController.swift
//  MemeV2
//
//  Created by Phuc Tran on 3/26/18.
//  Copyright © 2018 Phuc Tran. All rights reserved.
//

import UIKit

class ViewMemeViewController: UIViewController {
    @IBOutlet weak var ivPhoto: UIImageView!
    
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    
    var currentMeme: Meme?
    var memeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentMeme = currentMeme {
            ivPhoto.image = currentMeme.memedImage
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickEditButton(_ sender: Any) {
        
         performSegue(withIdentifier: "editMemeSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMemeSegue" {
            let controller = segue.destination as! EditMemeViewController
            if let currentMeme = currentMeme {
                controller.choosedMeme = currentMeme
                controller.memeIndex = memeIndex
            }
        }
    }
}



