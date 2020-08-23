//
//  MyTextView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/22.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI
import UIKit

struct MyTextView : UIViewRepresentable {
    typealias UIViewType = UITextView
    var text : String = ""
    var fontSize : CGFloat = 10
    var fontColor : UIColor = .gray
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        return textView
    }

    func updateUIView(_ view: UITextView, context: Context) {
        view.text = self.text
        view.font = UIFont.systemFont(ofSize: self.fontSize)
        view.textColor = self.fontColor
    }
}

struct MyTextView_Previews: PreviewProvider {
    static var previews: some View {
        MyTextView(text: "xxxxyyyy")
    }
}
