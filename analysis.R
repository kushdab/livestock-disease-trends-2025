# Livestock Disease Trends 2025
# Analysis of regional cattle disease outbreaks using time-series forecasting

# 1. Load Libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, lubridate, forecast, tseries, gridExtra)

# 2. Synthetic Data Generation
set.seed(2025)
regions <- c("North", "South", "East", "West")
start_date <- as.Date("2018-01-01")
end_date <- as.Date("2024-12-01")
date_seq <- seq.Date(start_date, end_date, by = "month")

data <- expand.grid(Date = date_seq, Region = regions) %>%
  mutate(
    # Create a seasonal trend with an upward trajectory and random noise
    BaseRate = rep(seq(10, 25, length.out = length(date_seq)), length(regions)),
    Seasonality = 10 * sin(2 * pi * month(Date) / 12),
    Noise = rnorm(n(), mean = 0, sd = 5),
    Outbreaks = pmax(0, round(BaseRate + Seasonality + Noise))
  )

# 3. Exploratory Data Analysis
p1 <- ggplot(data, aes(x = Date, y = Outbreaks, color = Region)) +
  geom_line(alpha = 0.7) +
  theme_minimal() +
  labs(title = "Monthly Cattle Disease Outbreaks by Region (2018-2024)",
       subtitle = "Historical Veterinary Records",
       y = "Confirmed Cases")

# 4. Time Series Decomposition (Aggregated National Level)
national_ts <- data %>%
  group_by(Date) %>%
  summarise(TotalOutbreaks = sum(Outbreaks)) %>%
  pull(TotalOutbreaks) %>%
  ts(start = c(2018, 1), frequency = 12)

decomp <- stl(national_ts, s.window = "periodic")
p2 <- autoplot(decomp) + theme_minimal() + labs(title = "Seasonal-Trend Decomposition")

# 5. Forecasting with ARIMA
# Fitting an automated ARIMA model
fit <- auto.arima(national_ts, stepwise = FALSE, approximation = FALSE)

# Forecast for 2025 (12 months)
forecast_2025 <- forecast(fit, h = 12)

p3 <- autoplot(forecast_2025) +
  theme_minimal() +
  labs(title = "National Forecast for 2025",
       subtitle = "ARIMA Model with 80% and 95% Confidence Intervals",
       x = "Year", y = "Outbreaks")

# 6. Regional Trend Analysis
regional_slopes <- data %>%
  group_by(Region) %>%
  do(model = lm(Outbreaks ~ as.numeric(Date), data = .)) %>%
  mutate(GrowthRate = coef(model)[2] * 30.5) # Monthly growth

# 7. Output Results
print("--- Summary of Regional Growth Rates (Monthly Increase) ---")
print(regional_slopes %>% select(Region, GrowthRate))

# Save plots
grid.arrange(p1, p3, ncol = 1)
ggsave("disease_trends_2025.png", plot = arrangeGrob(p1, p3, ncol = 1), width = 10, height = 8)

cat("\nAnalysis Complete. Forecast summary for Jan 2025:", forecast_2025$mean[1], "\n")