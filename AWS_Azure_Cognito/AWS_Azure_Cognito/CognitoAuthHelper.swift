//
//  CognitoAuthHelper.swift
//  AWS_Azure_Cognito
//
//  Created by Kseniia Zozulia on 7/17/18.
//  Copyright © 2018 Sezorus. All rights reserved.
//

import UIKit
import AWSCognitoAuth
import AWSUserPoolsSignIn
import AWSCore

final class CognitoAuthHelper {
    
    // MARK: - Properties

    private(set) var session:        AWSCognitoAuthUserSession?
    private(set) var cognitoAuth:    AWSCognitoAuth!
    private(set) var identityPool:   AWSCognitoIdentityUserPool!
    private weak var delegate:       AWSCognitoAuthDelegate!
    
    var isSignedIn: Bool {
        return cognitoAuth.isSignedIn
    }
    
    var currentUser: AWSCognitoIdentityUser? {
        return identityPool.currentUser()
    }
    
    // MARK: - Initialization
    
    init(delegate: AWSCognitoAuthDelegate) {
        self.cognitoAuth            = AWSCognitoAuth.default()
        self.identityPool           = AWSCognitoIdentityUserPool.default()
        self.cognitoAuth.delegate   = delegate
    }
    
    // MARK: - Sign-In

    func getSesstion(delegate: AWSCognitoAuthDelegate, completion: @escaping AWSCognitoAuthGetSessionBlock) {
        cognitoAuth.getSession { [weak self] (session, error) in
            self?.session = session
            completion(session, error)
        }
    }
    
    // MARK: - Sign-Out

    func signOut(completion: @escaping AWSCognitoAuthSignOutBlock) {
        cognitoAuth.signOut { (error) in
            completion(error)
        }
    }

    // MARK: - User Identity

    func getUserInformation(_ user: AWSCognitoIdentityUser, completion: @escaping ((Array<AWSCognitoIdentityProviderAttributeType>?) -> ())) {
        user.getDetails().continueWith { (taskResponse) -> Any? in
            completion(taskResponse.result?.userAttributes)
            return nil
        }
    }
}
