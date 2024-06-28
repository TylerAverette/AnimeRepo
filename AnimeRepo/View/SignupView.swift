//
//  SignupView.swift
//  Notes
//
//  Created by Shirley Averette on 6/11/24.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var handle: Any = ""
    @ObservedObject var appAuth = AuthViewModel()
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    @State var showingAlert: Bool = false
    @State var passwordsMatch: Bool = false
    @State var path = NavigationPath()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Anime Repo")
                    .padding(.bottom)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                TextField("Email", text: $email)
                    .padding() // padding for width
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .onChange(of: email) {oldValue, newValue in
                        validEmail = appAuth.isValidEmail(email: email)
                    }
                
                SecureField("Password", text: $password)
                    .cornerRadius(20)
                    .padding() // padding for width
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .padding(.top) // space between fields
                    .onChange(of: password) {oldValue, newValue in
                        validPassword = appAuth.isValidPassword(password: password)
                        passwordsMatch = (password == password2)
                    }
                    .onChange(of: password2) {oldValue, newValue in
                        validPassword = appAuth.isValidPassword(password: password)
                        passwordsMatch = (password == password2)
                    }
                
                SecureField("Confirm Password", text: $password2)
                    .cornerRadius(20)
                    .padding() // padding for width
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .padding(.top) // space between fields
                    .onChange(of: password) {oldValue, newValue in
                        validPassword = appAuth.isValidPassword(password: password)
                        passwordsMatch = (password == password2)
                    }
                    .onChange(of: password2) {oldValue, newValue in
                        validPassword = appAuth.isValidPassword(password: password)
                        passwordsMatch = (password == password2)
                    }
                Spacer()
                
                Button {
                    if validEmail && validPassword && passwordsMatch {
                        // Create a user in Firebase
                        appAuth.RegisterUser(email: email, password: password)
                        path.append("ContentView")
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                } label: {
                    Text("Register")
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width - 20)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green)
                        )
                }
            }
            .padding()
            .padding(.top)
            .alert(isPresented: $showingAlert, content: {
                if !validEmail {
                    Alert(title: Text("Registration Error"),
                                 message: Text("Invalid Email"),
                                 dismissButton: .default(Text("OK"))
                               )
                } else if !validPassword {
                    Alert(title: Text("Registration Error"),
                                 message: Text("Invalid password, please use at least 8 characters, 1 Uppercase, 1 lower case, 1 special character"),
                                 dismissButton: .default(Text("OK"))
                               )
                } else if !passwordsMatch {
                    Alert(title: Text("Registration Error"),
                                 message: Text("Passwords do not match"),
                                 dismissButton: .default(Text("OK"))
                               )
                } else {
                    Alert(title: Text("Registration Error"),
                                 message: Text("Unkown error"),
                                 dismissButton: .default(Text("OK"))
                               )
                }
            })
        }
    }
}

#Preview {
    SignupView()
}
