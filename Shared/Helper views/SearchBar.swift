//
//  SwiftUIView.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/14/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchedText: String
    var body: some View {
        ZStack {
            HStack {
                Text("Search...")
                    .foregroundColor(.white)
                Spacer()
            }.opacity(0)
            .padding(.horizontal, 48)
            
            HStack{
                TextField("Search...", text: $searchedText)
                    .padding(8)
                    .padding(.horizontal, 24)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            Spacer()
                            Button(action: {}, label: {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24, weight: .light, design: .rounded))
                                    .padding(.trailing)
                            })
                        },
                        alignment: .leading
                    )
            }.padding(.horizontal, 10)
        }.padding(12)
        .background(Color(#colorLiteral(red: 0.2077952027, green: 0.2640034556, blue: 0.3278865218, alpha: 1)))
        .cornerRadius(20.0)
        .padding([.horizontal, .top])
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1401646137, green: 0.1773337126, blue: 0.2355768085, alpha: 1)), Color(#colorLiteral(red: 0.09998283535, green: 0.1434168518, blue: 0.1889503896, alpha: 1))]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            SearchBar(searchedText: .constant(""))
        }
    }
}
