//
//  InitialVC.swift
//  faiaz_rahman_30024_LOCAL_PERSISTENT
//
//  Created by bjit on 9/1/23.
//

import UIKit

class InitialVC: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loginStatus.text = ""
        //let defaultUserName = "admin"
        let defaultPassword = "admin"
       // let userInputPassword = "123456"
        guard let data = try? JSONEncoder().encode(defaultPassword) else {
            return
        }
        
        writeToKeychain(data: data)

        // Do any additional setup after loading the view.
    }
    @IBAction func loginBtn(_ sender: Any) {
        let userNameA = userNameField.text!
        let passwordA = passwordField.text!


        let (userNameKeyChain , passwordKeyChain) = self.readFromKeyChain(account: "faiazewu@gmail.com", service: "password")

        if userNameA == userNameKeyChain && passwordA == passwordKeyChain{
            performSegue(withIdentifier: "way1", sender: self)
        }else{
            loginStatus.text = "Wrong Credentials"
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        var oldPass = UITextField()
        var newPass = UITextField()
        var confirmPass = UITextField()
        
        let alertAction = UIAlertController(title: "Change Password", message: "Security is Priority", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Save Change", style: .default) { [self] (action) in
            
            let (_ , passwordKeyChain) = self.readFromKeyChain(account: "faiazewu@gmail.com", service: "password")
            
            if oldPass.text! == passwordKeyChain && newPass.text! == confirmPass.text!{
                update(newPass: newPass.text!)
            }else{
                loginStatus.text = "Unable to Change Password"
            }

        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = "Old Password"
            oldPass = alertTextField
        }

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Password"
            newPass = alertTextField
        }
        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = "Confirm New Password"
            confirmPass = alertTextField
        }
        
        alertAction.addAction(action)
        alertAction.addAction(cancel)
        
        present(alertAction, animated: true, completion: nil)
        
        
    }
    
    
    
}

extension InitialVC {
    
    func writeToKeychain(data: Data) {
        
        let account = "faiazewu@gmail.com"
        let service = "password"
   //     let authToken = "token1"
        
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecValueData: data
        ] as CFDictionary
    
        SecItemAdd(query, nil)
    }
    
    func delete() {
        let account = "test@gmail.com"
        let service = "password"
        
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    func update(newPass : String) {
        let account = "faiazewu@gmail.com"
        let service = "password"
        
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
        ] as CFDictionary
        
        let newPassword = newPass
        let data = try? JSONEncoder().encode(newPassword)
        
        let attributesToUpdate = [
            kSecValueData : data
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributesToUpdate)
        
        if status == errSecSuccess {
            print("update successful")
        } else {
            print(status)
        }
    }
    
    func readFromKeyChain(account: String, service: String) -> (String,String) {
        
        var accountX = ""
        var passwordX = ""
    
        let query = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true,
            kSecReturnAttributes: true
        ] as CFDictionary
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        
        if status == errSecSuccess {
            if let result = result as? [CFString : Any] {
//                print(result[kSecValueData])
//                print(result[kSecAttrAccount]!)
//                print(result[kSecAttrService])
//
                accountX = result[kSecAttrAccount] as! String
                
                
                if let data = result[kSecValueData] as? Data {
                    let password = try? JSONDecoder().decode(String.self, from: data)
                    passwordX = password!
                    //print(password)
                }
            }
        } else {
            print(status)
        }
        
        return (accountX, passwordX)
        

    }
    
    
}

