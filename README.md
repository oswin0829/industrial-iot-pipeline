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
* **`src/`** (Source Code):
    * `sensor_sim.py`: The "PLC" simulator - generates and pushes data.
    * `monitor.py`: The "Watchdog" service - alerts on threshold violations.
* **`data/`** (Database Infrastructure):
    * `schema.sql`: Contains the `CREATE TABLE` commands and initial seed data for machines/sensors.
* **`analysis/`** (Business Intelligence):
    * `queries.sql`: Analytical queries for Dashboarding, Anomaly Detection, and Root Cause Analysis.

## 🚀 How to Run

### 1. Setup
* **Clone the repo:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/industrial-iot-pipeline.git](https://github.com/oswin0829/industrial-iot-pipeline.git)
    ```
* **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
* **Configure Environment:**
    Create a `.env` file in the root directory with your DB credentials:
    ```ini
    DB_HOST=your-aws-endpoint
    DB_NAME=postgres
    DB_USER=postgres
    DB_PASS=your-password
    ```

### 2. Database Initialization
Before running the code, you must create the tables.
1.  Open `data/schema.sql` in your SQL Client (e.g., DBeaver).
2.  Execute the script to create the `machines`, `sensors`, and `readings` tables.

### 3. Execution
* **Terminal 1: Start the Simulation**
    (Acts as the machine generating data)
    ```bash
    python src/sensor_sim.py
    ```
* **Terminal 2: Start the Monitor**
    (Acts as the control room watchdog)
    ```bash
    python src/monitor.py
    ```