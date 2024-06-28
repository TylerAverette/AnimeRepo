//
//  LoginView.swift
//  Notes
//
//  Created by Shirley Averette on 6/11/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var handle: Any = ""
   // @ObservedObject var appAuth = AuthViewModel()
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    @EnvironmentObject var appAuth: AuthViewModel

    
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
                    ) .onChange(of: email) {oldValue, newValue in
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
                    }
                
                
                NavigationLink{
                    SignupView()
                } label: {
                    Text("Dont have an account?")
                    
                }
                Spacer()
                
                Button {
                    if validEmail && validPassword {
                        appAuth.SignIn(email: email, password: password)
                    }
                } label: {
                    Text("Sign In")
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
                .environmentObject(appAuth)
            }
            .padding()
            .padding(.top)
        }
    }
}

#Preview {
    LoginView(handle: "")
}
