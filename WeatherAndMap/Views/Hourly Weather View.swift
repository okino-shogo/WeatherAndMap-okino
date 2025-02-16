//
//  Hourly Weather View.swift
//  WeatherAndMap
//
//  Created by 沖野匠吾 on 2025/02/16.
//

import SwiftUI

struct HourlyWeatherView: View {
    let defaultDateStr = "----年--月--日" // 日付が取得できていないときに表示する文字
    @ObservedObject var weatherVM: WeatherViewModel// APIレスポンスの値を保持するオブジェクト

    var body: some View {
        if let forecastsDay = weatherVM.forecast?.forecastsDay {
            //ForEachで日毎に表示を作る


            ForEach(forecastsDay, id: \.self) { forecastDay in // 3回繰り返す(3日分)
                // compactMapを使って[HourlyForecast] → [HourlyDisplayForecast] に変換
                let hourlyDisplayForecasts = forecastDay.hour.compactMap { hourlyDisplayForecast in hourlyDisplayForecast.toDisplayFormat(hourlyForecast: hourlyDisplayForecast)
                }
                VStack {

                    // 区切り線
                    Divider()

                    // 日付
                    Text(hourlyDisplayForecasts.first?.date ?? defaultDateStr)
                        .padding(.vertical, 5) // 垂直方向に余白を5とる

                    // 時間毎の天気予報
                    HStack(spacing: 5) {

                        // ヘッダー(見出し)
                        HourlyWeatherHeader(weatherVM: weatherVM)

                        // 0~23時までの時間毎の予報
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(hourlyDisplayForecasts) { hourlyDisplayForecast in // 24回繰り返す
                                    // MARK: 1時間分の表示
                                    VStack(spacing: 10) {
                                        // 時刻
                                        Text(hourlyDisplayForecast.time)
                                            .font(.subheadline)

                                        // 天気アイコン
                                        AsyncImageView(urlStr: "https:\(hourlyDisplayForecast.weatherIcon)")
                                            .frame(maxWidth: 64, maxHeight: 64)
                                            .scaledToFit()

                                        // 気温
                                        Text(hourlyDisplayForecast.temperature, format: .number)
                                            .font(.subheadline)

                                        // 降水確率
                                        Text(50, format: .number)
                                            .font(.subheadline)
                                    }
                                    .frame(width: ScreenInfo.width / 9)
                                }
                            }
                            .padding()
                            .frame(height: 180)
                            .background(Color.gray.opacity(0.2)) // 背景色グレー
                            .clipShape(.rect(cornerRadius: 10))  // 角丸に切り取る
                        }
                    }
                }
            }
        }
    }
}
// MARK: - 時間毎の予報のヘッダー
struct HourlyWeatherHeader: View {
    let defaultDateStr = "----年--月--日" // 日付が取得できていないときに表示する文字
    @ObservedObject var weatherVM: WeatherViewModel // APIレスポンスの値を保持するオブジェクト
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("時刻(時)")
                .font(.caption)


            Text("天気")
                .font(.caption)
                .frame(maxHeight: 40)


            Text("気温(℃)")
                .font(.caption)


            Text("降水確率(%)")
                .font(.caption2)
        }
        .frame(width: 65, height: 180)
        .background(Color.blue.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {


    @Previewable @StateObject var weatherVM = WeatherViewModel()
    // 八幡平市大更の緯度・経度
    let lat: Double = 39.91167
    let lon: Double = 141.093459

    HourlyWeatherView(weatherVM: weatherVM)
        .onAppear {
            weatherVM.request3DaysForecast(lat: lat, lon: lon)
        }
}
#Preview("ContentView") {
    ContentView()
}
