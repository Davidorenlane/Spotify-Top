//
//  SessionOpener.swift
//  My Spotify Analytics
//
//  Created by David Lane on 9/12/19.
//  Copyright © 2019 David Lane. All rights reserved.
//

import Foundation

class SessionOpener: NSObject, SPTSessionManagerDelegate{
    
    static let shared = SessionOpener()    
    override private init(){}
        
    // MARK: - Session Configuration
    
    fileprivate let SpotifyClientID = "0a7b2d8c10324ae99b79352e62c3f65d"
    fileprivate let SpotifyRedirectURI = URL(string: "my-spotify-analytics://returnAfterLogin")!
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        
        //To wake up Spotify
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        //Wifi Networks must match on both devices, IP address of Network 45.50.169.233
        configuration.tokenSwapURL = URL(string: "http://45.50.169.233:93/swap")
        configuration.tokenRefreshURL = URL(string: "http://45.50.169.233:93/refresh")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    // MARK: - SPTSessionManagerDelegate
    
    func startSession() {

        // MARK: - Scopes
        let scope: SPTScope = [
            .appRemoteControl,
            .userTopRead,
            .playlistReadPrivate,
            .userLibraryRead,
            .userReadRecentlyPlayed,
            .playlistModifyPrivate]
    
        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            //print("here")
            sessionManager.initiateSession(with: scope, options: .default)
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            sessionManager.initiateSession(with: scope, options: .default)//, presenting: self)
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        //Triggers Error pop-up in ViewController.swift
        NotificationCenter.default.post(name: NSNotification.Name(ViewController.authenticationFailed), object: nil)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        //self.presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        DispatchQueue.main.async{
            RemotePlayer.shared.appRemote.connectionParameters.accessToken = session.accessToken
            print(session.accessToken)
            RemotePlayer.shared.appRemote.connect()
        }
        //Notifies ViewController.swift that i is ready for transition to top50VC
        NotificationCenter.default.post(name: NSNotification.Name(ViewController.authenticatedUser), object: nil, userInfo: ["token": session.accessToken])
        
        
    }
    
    
}



