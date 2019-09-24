//
//  RemotePlayer.swift
//  My Spotify Analytics
//
//  Created by David Lane on 9/24/19.
//  Copyright © 2019 David Lane. All rights reserved.
//

import Foundation

class RemotePlayer: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    //Singleton
    static let shared = RemotePlayer()
    override private init(){}
    
    var accessToken: String?// = ""
        /*= UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SessionOpener.kAccessTokenKey)
            defaults.synchronize()
        }
    }*/
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: SessionOpener.shared.configuration, logLevel: .debug)
      //appRemote.connectionParameters.accessToken = self.accessToken
      appRemote.delegate = self
      return appRemote
    }()
    
    func playTrack(track: String) {
        appRemote.playerAPI?.play(track, callback: defaultCallback)
    }
    
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {[weak self] _, error in
                if let error = error {
                    //self?.displayError(error as NSError)
                }
            }
        }
    }
    
    /*private func displayError(_ error: NSError?) {
        if let error = error {
            //presentAlert(title: "Error", message: error.description)
        }
    }*/
    
    /*func playOpeningTrack() {
        appRemote.playerAPI?.play("spotify:track:5S9d4zV0jeAKVmikBBpHoA", callback: defaultCallback)
    }
 
 private func startPlayback() {
        appRemote.playerAPI?.resume(defaultCallback)
 }
    
    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
 static private let kAccessTokenKey = "access-token-key"*/
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Connection was successful, you can begin issuing commands
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
          if let error = error {
            debugPrint(error.localizedDescription)
          }
        })
      print("connected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }
    
}
