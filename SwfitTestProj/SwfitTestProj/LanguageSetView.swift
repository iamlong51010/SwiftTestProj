//
//  LanguageSetView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct LanguageSetView: View {
    @EnvironmentObject var userData : UserData
    @Environment(\.presentationMode) var presentationMode
    
    func clickOnLanguage(language:Int) -> Void {
        UserData.globalGetIns().setLanguage(language: language)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Text(GlobalGetSentence(sentenceType: .languageselect))
                .bold()
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(0..<SentenceData.kLanguageList.count) {language in
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.clickOnLanguage(language: language)
                        }) {
                            Text(SentenceData.kLanguageList[language])
                            .font(.system(size: 16))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(GlobalGetSentence(sentenceType: .cancel))
                        .font(.system(size: 16))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
            }
        }
    }
}

struct LanguageSetView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSetView().environmentObject(UserData.globalGetIns())
    }
}
