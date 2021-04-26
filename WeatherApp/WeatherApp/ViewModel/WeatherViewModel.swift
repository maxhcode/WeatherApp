//
//  WeatheerViewModel.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 25.04.21.
//

import Foundation
import SwiftUI


class WeatherViewModel: ObservableObject{
    @Published var circleValue = 10.0
    @Published var colorCircle = Color.green
    
    func animationForCircle(){
        if circleValue < 100 {
            circleValue += 2
        }
    }
    
    func circleColorChange(){
        if circleValue == 10{
            colorCircle = .green
        }
        if circleValue == 20{
            colorCircle = .green
        }
        if circleValue == 30{
            colorCircle = .green
        }
        if circleValue == 40{
            colorCircle = .yellow
        }
        if circleValue == 50{
            colorCircle = .yellow
        }
        if circleValue == 60{
            colorCircle = .orange
        }
        if circleValue == 70{
            colorCircle = .orange
        }
        if circleValue == 80{
            colorCircle = .red
        }
        if circleValue == 90{
            colorCircle = .red
        }
        if circleValue == 100{
            colorCircle = .red
        }
    }
}


//    @EnvironmentObject var learningQuizViewModel: LearningQuizViewModel
//
//    @StateObject var learningViewModel = LearningViewModel()
//        .environmentObject(learningViewModel)
//
//    struct LearningView_Previews: PreviewProvider {
//        static var previews: some View {
//            LearningView(learningViewModel: LearningViewModel())
//        }
//    }

