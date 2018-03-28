//
//  EditMemeViewController.swift
//  MemeV2
//
//  Created by Phuc Tran on 3/26/18.
//  Copyright © 2018 Phuc Tran. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    @IBOutlet weak var tfTop: UITextField!
    @IBOutlet weak var tfBottom: UITextField!
    @IBOutlet weak var ivPhoto: UIImageView!
    
    @IBOutlet weak var toolbarOnTop: UIToolbar!
    @IBOutlet weak var toolbarUnderBottom: UIToolbar!
    var choosedMeme: Meme?
    var memeIndex: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = choosedMeme {
            setupTextField(tf: tfTop, text: meme.topText)
            setupTextField(tf: tfBottom, text: meme.bottomText)
            ivPhoto.image = meme.originalImage
        }else {
            setupTextField(tf: tfTop, text: "TOP")
            setupTextField(tf: tfBottom, text: "BOTTOM")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        self.setupViews()
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickShareButton(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { activity, success, items, error in
            let meme = self.save()
            if let choosedMeme = self.choosedMeme, let memeIndex = self.memeIndex {
                self.appDelegate.editMeme(meme: meme, position: memeIndex)
                
            }else {
                self.appDelegate.addMeme(meme: meme)
                
            }
            
            self.dismiss(animated: true, completion: {                    
            })
        }
        
        present(activityController, animated: true, completion: nil)
        
    }
    
    @IBAction func onClickAlbumButton(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    @IBAction func onClickCameraButton(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    func setupViews() {
        if ivPhoto.image == nil {
            btnShare.isEnabled = false
        } else {
            btnShare.isEnabled = true
        }
        
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    func save() -> Meme{
        let memedImage = generateMemedImage()
        let meme = Meme(topText: tfTop.text!, bottomText: tfBottom.text!, originalImage: ivPhoto.image!, memedImage: memedImage)
        return meme
    }
    
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
       toolbarOnTop.isHidden = true
       toolbarUnderBottom.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
       
        toolbarOnTop.isHidden = false
        toolbarUnderBottom.isHidden = false
        
        return memedImage
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ivPhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
        setupViews()
        
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func isFontNameAvailable(fontName: String) -> Bool {
        
        for name in UIFont.familyNames {
            
            for fontFamilyName in UIFont.fontNames(forFamilyName: name) {
                if fontFamilyName == fontName {
                    return true
                }
            }
        }
        
        return false
    }

    func setupTextField(tf: UITextField, text: String) {
        let memeParagraphStyle = NSMutableParagraphStyle()
        memeParagraphStyle.lineBreakMode = .byWordWrapping;
        memeParagraphStyle.alignment = .center;

        tf.defaultTextAttributes = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.paragraphStyle.rawValue: memeParagraphStyle,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4.0,        ]
        tf.text = text
        tf.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if tfBottom.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if tfBottom.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func controlButtons() {
        
    }
}


