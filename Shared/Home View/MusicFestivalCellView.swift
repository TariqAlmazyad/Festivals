//
//  SwiftUIView.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/15/21.
//

import SwiftUI

struct MusicFestivalCellView: View {
    let proxy: GeometryProxy
    let festival: Festival
    var body: some View {
        ZStack {
            Image(festival.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 250)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
                .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                    height: .getScale(proxy: proxy, scalerView: .leftView)))
                .animation(.easeOut(duration: 0.5))
            
            // shadow view
            LinearShadowView(proxy: proxy)
            
            VStack{
                // top heart view
                TopHeartView()
                    .padding()
                Spacer()
                // festival info
                FestivalInfoView(festival: festival)
                
            }.frame(width: 250)
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 5)
            .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                height: .getScale(proxy: proxy, scalerView: .leftView)))
            .animation(.easeOut(duration: 0.5))
        }
    }
}


struct LinearShadowView: View {
    let proxy: GeometryProxy
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]),
                       startPoint: .center, endPoint: .bottom)
            .frame(width: 250)
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 5)
            .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                height: .getScale(proxy: proxy, scalerView: .leftView)))
            .animation(.easeOut(duration: 0.5))
    }
}

struct TopHeartView: View {
    var body: some View {
        HStack{
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "heart")
                    .font(.title)
                    .padding(6)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(20)
            })
        }
    }
}


struct FestivalInfoView: View {
    let festival: Festival
    var body: some View {
        Group{
            HStack{
                Text("28 - 9 June, 2021")
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack{
                Text(festival.title)
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Spacer()
            }.padding(.bottom)
        }.padding(.horizontal)
    }
}



struct MusicFestivalCellView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1401646137, green: 0.1773337126, blue: 0.2355768085, alpha: 1)), Color(#colorLiteral(red: 0.09998283535, green: 0.1434168518, blue: 0.1889503896, alpha: 1))]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            HomeView()
                .foregroundColor(.white)
        }
    }
}
