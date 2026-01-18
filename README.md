# Cloud-Native Industrial IoT Telemetry Pipeline

## 📌 Project Overview
A real-time data engineering pipeline that simulates an Industrial IoT (IIoT) environment. The system acts as a digital twin for factory machinery, generating synthetic telemetry data (temperature, vibration, speed), ingesting it into a cloud-based PostgreSQL database (AWS RDS), and performing automated anomaly detection.

## 🏗 Architecture
**Tech Stack:** Python, SQL (PostgreSQL), AWS RDS, Git.

* **Data Source:** Python-based PLC simulator generating realistic time-series data with stochastic failure modes.
* **Ingestion:** Real-time stream to AWS RDS using `psycopg2`.
* **Analysis:** SQL layer utilizing Window Functions for moving averages and threshold-based anomaly detection.
* **Monitoring:** Automated "Watchdog" script for 24/7 failure alerting.

## 📂 Repository Structure
* `src/sensor_sim.py`: The "PLC" - generates and pushes data.
* `src/monitor.py`: The "Watchdog" - alerts on threshold violations.
* `sql/queries.sql`: Analytical queries for Dashboarding and Root Cause Analysis.

## 🚀 How to Run
1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/industrial-iot-pipeline.git](https://github.com/YOUR_USERNAME/industrial-iot-pipeline.git)
    ```
2.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Configure Environment:**
    Create a `.env` file in the root with your DB credentials:
    ```ini
    DB_HOST=your-aws-endpoint
    DB_NAME=postgres
    DB_USER=postgres
    DB_PASS=your-password
    ```
4.  **Run the Simulation:**
    ```bash
    python src/sensor_sim.py
    ```