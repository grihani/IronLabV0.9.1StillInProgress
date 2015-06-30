//
//  LoginViewController.swift
//  IronLab
//
//  Created by CSC CSC on 22/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFieldsOfForm: [UITextField]! {didSet{
        for textField in textFieldsOfForm {
            textField.delegate = self
        }
        textFieldsOfForm[0].isFirstResponder()
        indexOfActiveTextField = 0
        
    }}
    
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfActiveTextField = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextFieldDelegate
    var indexOfActiveTextField: Int! {
        didSet {
            if let textFieldsOfForm = textFieldsOfForm {
                textFieldsOfForm[indexOfActiveTextField].becomeFirstResponder()
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let indexOfActiveTextField = find(textFieldsOfForm, textField) {
            self.indexOfActiveTextField = indexOfActiveTextField
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if indexOfActiveTextField == textFieldsOfForm.count - 1 {
            performSegueWithIdentifier(segueIdentifiers.login, sender: self)
            indexOfActiveTextField = 0
        } else {
            indexOfActiveTextField = indexOfActiveTextField + 1
        }
        return true
    }
    
    // MARK: - Navigation
    private struct segueIdentifiers {
        static let login = "logInSegue"
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
}
