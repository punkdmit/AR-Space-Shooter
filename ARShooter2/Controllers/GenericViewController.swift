//
//  GenericViewController.swift
//  ARShooter2
//
//  Created by Dmitry Apenko on 26.09.2023.
//

import UIKit

class GenericViewController<T: UIView>: UIViewController { 
    public var rootView: T { return view as! T }
        
      override open func loadView() {
         self.view = T()
      }
}
