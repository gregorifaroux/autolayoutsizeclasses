//
//  ViewController.swift
//  Copyright (c) 2015 digistarters. All rights reserved.
//
// AutoLayout with Visual Style and Size classes to display an additional view on large screen.
// Add an additional view on landscape mode




import UIKit
class ViewController: UIViewController {
    var viewsDictionary = Dictionary<String, UIView>()
    
    var view_constraint_V:NSArray = [NSLayoutConstraint]();
    var view_constraint_H:NSArray = [NSLayoutConstraint]();
    var view_constraint_H2:NSArray = [NSLayoutConstraint]()
    
    // Used for the button that change a contraint's constant
    var originalValue:CGFloat = 0.0;
    var offsetValue:CGFloat = -200;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var topView = UIView()
        topView.setTranslatesAutoresizingMaskIntoConstraints(false)
        topView.backgroundColor = UIColor.blackColor()
        
        var bottomView = UIView()
        bottomView.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomView.backgroundColor = UIColor.lightGrayColor()

        var landscapeView = UIView()
        landscapeView.setTranslatesAutoresizingMaskIntoConstraints(false)
        landscapeView.backgroundColor = UIColor.orangeColor()

        let button   = UIButton()
        button.backgroundColor = UIColor.darkGrayColor()
        button.setTitle("Click me!", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addSubview(topView);
        self.view.addSubview(bottomView);
        self.view.addSubview(landscapeView)
        bottomView.addSubview(button)

        // constraints
        viewsDictionary = ["top":topView,"bottom":bottomView, "button":button,"landscape":landscapeView]

        view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-20-[top(bottom)]-[bottom]-10-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsDictionary)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[landscape]-10-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsDictionary))

        
        // Detect size Compact or Large -- we add an extra view for the larger screens
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact) {
            button.setTitle("Click Me (Compact Screen)!", forState: UIControlState.Normal)

            view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[top]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
            view_constraint_H2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[bottom]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)

        } else {
            button.setTitle("Click Me (Large Screen)!", forState: UIControlState.Normal)
            

            var largeonlyView = UIView()
            largeonlyView.setTranslatesAutoresizingMaskIntoConstraints(false)
            largeonlyView.backgroundColor = UIColor.darkGrayColor()
            self.view.addSubview(largeonlyView)
            
            viewsDictionary["largeonly"] = largeonlyView
            
            //position constraints
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[largeonly]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))

            view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[largeonly(200)]-[top]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
            view_constraint_H2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[bottom]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)

        }
        
        view.addConstraints(view_constraint_V)
        view.addConstraints(view_constraint_H)
        view.addConstraints(view_constraint_H2)
        
        originalValue = (view_constraint_V[1] as NSLayoutConstraint).constant;
        
        
        // Position button
        let control_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[button]-30-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let control_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[button(50)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        
        bottomView.addConstraints(control_constraint_H)
        bottomView.addConstraints(control_constraint_V)
        
        
    }
    
    
    
    /**
    Example of dynamically changing the constraints when clicking on a button.
    */
    func buttonAction(sender:UIButton!)
    {
        if (view_constraint_V[1].constant == offsetValue) {
            (view_constraint_V[1] as NSLayoutConstraint).constant = originalValue
        } else {
            (view_constraint_V[1] as NSLayoutConstraint).constant = offsetValue
        }
    }
    
    /**
    We overrides viewWillTransitionToSize instead of traitCollectionDidChange as on iPad the traitCollectionDidChange is not called.
    */
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        if (UIDevice.currentDevice().orientation.isLandscape) {
            // ----- Landscape -----
            view.removeConstraints(view_constraint_H)
            view.removeConstraints(view_constraint_H2)
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact) {
                // --- Compact ---
                view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[top]-[landscape(50)]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
                view_constraint_H2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[bottom]-[landscape]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
            } else {
                // --- Large ---
                view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[largeonly(200)]-[top]-[landscape(200)]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
                view_constraint_H2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[bottom]-[landscape]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
            }
            view.addConstraints(view_constraint_H)
            view.addConstraints(view_constraint_H2)
        } else {
            // ----- Portrait -----
            view.removeConstraints(view_constraint_H)
            view.removeConstraints(view_constraint_H2)
            if (view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact) {
                // --- Compact ---
                view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[top]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
                view_constraint_H2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[bottom]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
            } else {
                // --- Large ---
                view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[largeonly(200)]-[top]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
                view_constraint_H2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[bottom]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
            }
            view.addConstraints(view_constraint_H)
            view.addConstraints(view_constraint_H2)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}

