//
//  LoginViewController.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/5/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import GoogleSignIn

class LoginViewController:UIViewController{
    @IBOutlet var gbutton:GIDSignInButton!
    
    let client_id = "1038533224100-qnqm3tih0cap1pjelkcl3ntkae4hjlj2.apps.googleusercontent.com"
    
    // Use google signin to authenticate user and set current user property
    @IBAction func signIn(_ sender: GIDSignInButton) {
        print("function triggered")
        let config = GIDConfiguration(clientID:client_id)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self){[self] guser, error in
            if let e = error{
                print(e)
                return
            }
            if let cuser = guser{
                if let profile = cuser.profile{
                    let docRef = Firestore.firestore().collection("users").document(cuser.userID!)
                    docRef.setData([
                        "firstName":profile.givenName ?? "",
                        "lastName":profile.familyName ?? "",
                        "email":profile.email,
                        "UID":cuser.userID ?? ""])
                    userModel.currentUser = user(firstName:profile.givenName ?? "", lastName:profile.familyName ?? "", email:profile.email,UID:cuser.userID ?? "")
                    
                    
                }
            }
            productModel.shared.getProducts{
                DispatchQueue.main.async{
                    self.dismiss(animated:true, completion:nil)
                    print("about to perform segue")
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            }
                
        }
    }
}
