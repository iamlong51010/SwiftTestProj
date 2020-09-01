//
//  NLanguageSetView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct NLanguageSetView: View, CloseSelfProtocol {
    
    @ObservedObject var viewModel : NLanguageSetViewModel = NLanguageSetViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    func close() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Text(ESentenceType.languageselect.localized)
                .bold()
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(0..<self.viewModel.languageList.count) {language in
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.viewModel.clickOnLanguage(language: language)
                        }) {
                            Text(self.viewModel.languageList[language])
                            .font(.system(size: 16))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.close()
                    }) {
                        Text(ESentenceType.cancel.localized)
                        .font(.system(size: 16))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
            }
        }
        .onAppear() {
            self.viewModel.setView(view: self)
        }
    }
}

struct NLanguageSetView_Previews: PreviewProvider {
    static var previews: some View {
        NLanguageSetView()
    }
}
