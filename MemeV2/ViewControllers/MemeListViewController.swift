//
//  ViewController.swift
//  MemeV2
//
//  Created by Phuc Tran on 3/26/18.
//  Copyright © 2018 Phuc Tran. All rights reserved.
//

import UIKit

class MemeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        cell.topText?.text = appDelegate.memes[indexPath.row].topText
        cell.bottomText?.text = appDelegate.memes[indexPath.row].bottomText
        cell.photo?.image = appDelegate.memes[indexPath.row].memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetailSegue" {
            let controller = segue.destination as! ViewMemeViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                controller.currentMeme = self.appDelegate.memes[selectedRow] as! Meme
                controller.memeIndex = selectedRow
            }
        }
    }

}

