//
//  ViewController.swift
//  Project25
//
//  Created by Sergii Miroshnichenko on 27.07.2022.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture)), UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(importText))]
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)), UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showConnectedPeers))]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }

        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func importText() {
        let ac = UIAlertController(title: "Enter Text:", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Share", style: .default, handler: { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            
            // Convert String to Data
            let text_data = Data(text.utf8)
            
            // Send Data
            guard let mcSession = self?.mcSession else { return }
            if mcSession.connectedPeers.count > 0 {
                do {
                    try mcSession.send(text_data, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(ac, animated: true, completion: nil)
                }
            }
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func showConnectedPeers() {
        guard let mcSession = mcSession else { return }
        let ac = UIAlertController(title: "Peers List", message: nil, preferredStyle: .alert)
        for peer in mcSession.connectedPeers {
            ac.addAction(UIAlertAction(title: peer.displayName, style: .default))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
        print(mcSession.connectedPeers)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // 1 Check if we have an active session we can use.
        guard let mcSession = mcSession else { return }

        // 2 Check if there are any peers to send to.
        if mcSession.connectedPeers.count > 0 {
            // 3 Convert the new image to a Data object.
            if let imageData = image.pngData() {
                // 4 Send it to all peers, ensuring it gets delivered.
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 5 Show an error message if there's a problem.
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func startHosting(action: UIAlertAction) {
//        guard let mcSession = mcSession else { return }
//        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
//        mcAdvertiserAssistant?.start()
        
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
            mcNearbyServiceAdvertiser?.delegate = self
            mcNearbyServiceAdvertiser?.startAdvertisingPeer()
    }

    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")

        case .connecting:
            print("Connecting: \(peerID.displayName)")

        case .notConnected:
            DispatchQueue.main.async { [weak self] in
                let ac = UIAlertController(title: "User: \(peerID.displayName) is disconnected the network.", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(ac, animated: true, completion: nil)
            }
            print("Not Connected: \(peerID.displayName)")

        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let text = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "Message Shared:", message: "\(text)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            invitationHandler(true, mcSession)
    
        let ac = UIAlertController(title: "Connection Request", message: "User: \(peerID.displayName) is requesting to join the network.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Allow", style: .default) {[weak self] action in
            invitationHandler(true, self?.mcSession)
        })
        ac.addAction(UIAlertAction(title: "Deny", style: .cancel) {[weak self] action in
            invitationHandler(false, self?.mcSession)
        })
        present(ac, animated: true)
    }

}



