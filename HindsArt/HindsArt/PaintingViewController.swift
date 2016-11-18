//
//  PaintingViewController.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/9/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Braintree
import Firebase

class PaintingViewController: UIViewController, BTDropInViewControllerDelegate {
    var painting = Painting()
    @IBOutlet weak var paintingImgView: UIImageView!
    @IBOutlet weak var paintingTitleLable: UILabel!
    @IBOutlet weak var paintingPriceLabel: UILabel!
    
    @IBOutlet weak var paintingDesc: UITextView!
    
    @IBAction func purchaseButton(_ sender: UIButton) {
        self.braintreeClient = BTAPIClient(authorization: clientToken)
        let dropInView = BTDropInViewController(apiClient: braintreeClient!)
        dropInView.delegate = self
        //let navController = UINavigationController(rootViewController: dropInView)
        
        dropInView.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelPayment))
        navigationController?.pushViewController(dropInView, animated: true)
        //present(navController, animated: true, completion: nil)
        
    }
    var braintreeClient: BTAPIClient?
    let clientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiIzNGM1ZmE3NjQwY2M3YmI2YzYyNzc5NDA3NWE2Zjg2ZmIyOTA5YTJkYmEzNDJjYTAwZjViMDIwZmRkMTE5NDJjfGNyZWF0ZWRfYXQ9MjAxNi0xMS0xMFQxNzo1MzoxNC4xODg1Mzk2NDkrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0="

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      paintingDesc.isEditable = false
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

        paintingPriceLabel.text = painting.price
        paintingTitleLable.text = painting.title
        paintingDesc.text = painting.desc
        paintingImgView.loadImageUsingCache(painting.imgURL!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func drop(_ viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        print("SUCCESS!!")
        let ref = FIRDatabase.database().reference().child("paintings")
        ref.child(painting.paintingKey!).removeValue()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "confirm") as! PurchaseViewController
        navigationController?.pushViewController(vc, animated: true)
       // _ = navigationController?.popToRootViewController(animated: true )
    }
    func drop(inViewControllerDidCancel viewController: BTDropInViewController) {
        _ = navigationController?.popToRootViewController(animated: true )
    }
    func cancelPayment()  {
        _ = navigationController?.popToRootViewController(animated: true )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
