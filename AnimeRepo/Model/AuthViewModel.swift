//
//  AuthViewModel.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var session: User? = nil
    @Published var userInstance: UserModel = UserModel() {
        didSet {
            print("User instance updated")
        }
    }
    var animevm: AnimeViewModel?
    
    let db = Firestore.firestore()
    
    init() {
        // Initilaize user with the currently signed on user if there is one.
        // This is a safe call, so it cannot fail and break the program
        // @return - Returns a user or nil of value User?
        self.session = Auth.auth().currentUser
        if self.session != nil {
            self.populateUser()
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
           
            // update user property when the sign in state changes
            if self.session != Auth.auth().currentUser {
                self.session = user
                self.populateUser()
            }
        }
    }
    
    func RegisterUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Registration Error: \(error)")
                return
            }
            
            // Create user document in firestore
            do {
                try self.db.collection("userData").document((authResult?.user.uid)!).setData(from: self.userInstance) {err in
                    if let err = err {
                        print(err)
                    } else {
                        self.populateUser()
                    }
                }
            } catch {
                print(error)
            }
            
            // Assign user
            self.session = authResult?.user
            self.populateUser()
        }
    }
    
    func SignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            // sign in user
            self?.session = authResult?.user
            self?.populateUser()
            print("Sign in method ignore count: \(self?.userInstance.ignoreList.count ?? 9999)")
        }
    }
    
    func SignOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch let error {
            print("Error signing out: \(error)")
        }
    }
    
    func isValidEmail(email : String) -> Bool {
        let emailRegexPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegexPattern)
        
        
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number
        let passwordRegexPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d\\$@\\$!%*?&#])[A-Za-z\\d\\$@\\$!%*?&#]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegexPattern)
        
        return passwordPredicate.evaluate(with: password)
    }
    
    /* Uses isValidEmail and isValid password to validate a user */
    func validateBoth(email: Bool, password: Bool) -> String {
        if !email {return "Invalid email Address"}
        
        if !password {return "Invalid password, please use 1 uppercase, 1 lowercase, 1 number, 1 special character required"}
        return "SignUpView()"
    }
    
    func getUserInstance() -> UserModel {
        return self.userInstance
    }
    
    /* Get user information and initialize the userInstance field*/
    func populateUser() {
        // Verify there is a user logged in and get their id
        guard let uid = self.session?.uid else {
            print("User ID not found")
            return
        }
        
        // Create a reference to the database
        let userDocument = db.collection("userData").document(uid)
        
        userDocument.getDocument { document, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Ensure the document exists, and capture it
            // Document contains the document and its fields
            // Data contains the values stored in those fields.
            guard let document = document, document.exists, let data = document.data() else {
                print("Document missing or nil data")
                return
            }
            
            do{
                let fetchedUser = try document.data(as: UserModel.self)
                // Populate the user instance
                self.userInstance = fetchedUser
                self.animevm?.fetchData()
                print("Populating user - IgnoreCount: \(self.userInstance.ignoreList.count)")
            } catch {
                print(error)
            }
        }
    }
    
    /* This function is used the access the environment variable values in the model. */
    func setup(animevm: AnimeViewModel) {
        self.animevm = animevm
    }
    
}
