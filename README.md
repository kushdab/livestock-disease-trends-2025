# Livestock Disease Trends 2025

This project provides a comprehensive time-series analysis framework for monitoring and forecasting regional cattle disease outbreaks. 

## Project Overview
Using historical veterinary data (2018-2024), the analysis identifies seasonal patterns and utilizes ARIMA (AutoRegressive Integrated Moving Average) modeling to predict disease trajectories for the year 2025.

## Key Features
- **Data Simulation**: Generates multi-region veterinary outbreak logs with realistic seasonality and noise.
- **STL Decomposition**: Separates historical data into seasonal, trend, and remainder components.
- **Predictive Modeling**: Implements `auto.arima` for robust forecasting.
- **Visualization**: Outputs comparative regional plots and national forecast confidence intervals.

## How to Run
1. Ensure R is installed.
2. Open `analysis.R` in RStudio or your preferred IDE.
3. The script will automatically install missing dependencies via `pacman`.
4. Run the script to generate the `disease_trends_2025.png` report.

## Requirements
- R >= 4.0
- Packages: `tidyverse`, `forecast`, `lubridate`, `tseries`