//
//  ItemNameViewController.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 8/1/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit

class ItemNameViewController: UIViewController {

    @IBOutlet weak var promptLabel: ShadowText!
    
    @IBOutlet weak var itemName: UITextField!
    
    weak var delegate: AddItemDelegate!
    var cancelPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemName.delegate = self
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemName.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        
        cancelPressed = true
        itemName.text?.removeAll()
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch itemName.isEditing{
        case true:
            view.endEditing(true)
        case false:
            itemName.becomeFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ItemNameViewController: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    
//        guard !(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! && !cancelPressed else{
//            return false
//        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !cancelPressed{
            delegate.addGroceryList!(name: textField.text!)
            //navigationController?.pushViewController(UIViewController, animated: <#T##Bool#>)
            dismiss(animated: false, completion: nil)
        }
    }
    
    
}
