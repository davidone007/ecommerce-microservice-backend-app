#!/usr/bin/env python3

"""
Generador de Reportes de Rendimiento
====================================

Analiza los resultados de las pruebas de Locust y genera reportes detallados
con métricas clave, gráficos y análisis de rendimiento.

Uso:
    python analyze_results.py <archivo_csv> [--output reporte.html]
"""

import sys
import argparse
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path
from datetime import datetime
import json

# Configuración de estilo
sns.set_theme(style="whitegrid")
plt.rcParams["figure.figsize"] = (12, 6)
plt.rcParams["font.size"] = 10


def load_stats(csv_file):
    """Carga las estadísticas desde el archivo CSV de Locust"""
    try:
        df = pd.read_csv(csv_file)
        return df
    except Exception as e:
        print(f"❌ Error al cargar {csv_file}: {e}")
        return None


def calculate_metrics(df):
    """Calcula métricas clave de rendimiento"""
    if df is None or df.empty:
        return {}

    total_requests = df["Request Count"].sum()
    total_failures = df["Failure Count"].sum()

    metrics = {
        "total_requests": int(total_requests),
        "total_failures": int(total_failures),
        "success_rate": (
            round((1 - total_failures / total_requests) * 100, 2)
            if total_requests > 0
            else 0
        ),
        "failure_rate": (
            round((total_failures / total_requests) * 100, 2)
            if total_requests > 0
            else 0
        ),
        "avg_response_time": round(df["Average Response Time"].mean(), 2),
        "min_response_time": round(df["Min Response Time"].min(), 2),
        "max_response_time": round(df["Max Response Time"].max(), 2),
        "median_response_time": round(df["Median Response Time"].mean(), 2),
        "p95_response_time": round(df["95%"].mean(), 2) if "95%" in df.columns else 0,
        "p99_response_time": round(df["99%"].mean(), 2) if "99%" in df.columns else 0,
        "avg_rps": round(df["Requests/s"].mean(), 2),
        "max_rps": round(df["Requests/s"].max(), 2),
    }

    return metrics


def generate_charts(df, output_dir):
    """Genera gráficos de análisis"""
    if df is None or df.empty:
        return []

    charts = []
    output_path = Path(output_dir)
    output_path.mkdir(exist_ok=True)

    # 1. Gráfico de tiempos de respuesta por endpoint
    plt.figure(figsize=(14, 8))
    endpoints = df["Name"].unique()[:10]  # Top 10 endpoints
    df_top = df[df["Name"].isin(endpoints)]

    plt.subplot(2, 2, 1)
    sns.barplot(data=df_top, x="Average Response Time", y="Name", palette="viridis")
    plt.title("Tiempo de Respuesta Promedio por Endpoint")
    plt.xlabel("Tiempo (ms)")
    plt.tight_layout()

    # 2. Gráfico de tasa de éxito/error
    plt.subplot(2, 2, 2)
    success_counts = df["Request Count"] - df["Failure Count"]
    failure_counts = df["Failure Count"]

    data = pd.DataFrame(
        {"Exitosas": [success_counts.sum()], "Fallidas": [failure_counts.sum()]}
    )

    data.T.plot(kind="bar", ax=plt.gca(), color=["green", "red"])
    plt.title("Distribución de Requests")
    plt.xlabel("")
    plt.ylabel("Cantidad")
    plt.legend().remove()
    plt.xticks(rotation=0)

    # 3. Gráfico de percentiles
    plt.subplot(2, 2, 3)
    percentiles = {
        "P50 (Mediana)": df["Median Response Time"].mean(),
        "P95": df["95%"].mean() if "95%" in df.columns else 0,
        "P99": df["99%"].mean() if "99%" in df.columns else 0,
        "Promedio": df["Average Response Time"].mean(),
    }

    plt.bar(
        percentiles.keys(),
        percentiles.values(),
        color=["blue", "orange", "red", "green"],
    )
    plt.title("Percentiles de Tiempo de Respuesta")
    plt.ylabel("Tiempo (ms)")
    plt.xticks(rotation=45)

    # 4. Gráfico de RPS
    plt.subplot(2, 2, 4)
    top_rps = df.nlargest(10, "Requests/s")[["Name", "Requests/s"]]
    sns.barplot(data=top_rps, x="Requests/s", y="Name", palette="coolwarm")
    plt.title("Throughput (Requests/segundo) por Endpoint")
    plt.xlabel("RPS")

    plt.tight_layout()
    chart_path = output_path / "performance_charts.png"
    plt.savefig(chart_path, dpi=300, bbox_inches="tight")
    plt.close()

    charts.append(str(chart_path))
    print(f"✓ Gráfico generado: {chart_path}")

    return charts


def generate_html_report(metrics, charts, output_file):
    """Genera un reporte HTML con las métricas y gráficos"""

    html_template = """
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reporte de Rendimiento - E-commerce Microservices</title>
        <style>
            * {{
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }}
            
            body {{
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 20px;
                color: #333;
            }}
            
            .container {{
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                overflow: hidden;
            }}
            
            .header {{
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 40px;
                text-align: center;
            }}
            
            .header h1 {{
                font-size: 2.5em;
                margin-bottom: 10px;
            }}
            
            .header p {{
                font-size: 1.2em;
                opacity: 0.9;
            }}
            
            .content {{
                padding: 40px;
            }}
            
            .metrics-grid {{
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 40px;
            }}
            
            .metric-card {{
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }}
            
            .metric-card:hover {{
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }}
            
            .metric-card.success {{
                background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            }}
            
            .metric-card.warning {{
                background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            }}
            
            .metric-card.danger {{
                background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%);
            }}
            
            .metric-label {{
                font-size: 0.9em;
                color: #555;
                margin-bottom: 10px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }}
            
            .metric-value {{
                font-size: 2.5em;
                font-weight: bold;
                color: #333;
            }}
            
            .metric-unit {{
                font-size: 0.5em;
                color: #666;
                font-weight: normal;
            }}
            
            .section {{
                margin-bottom: 40px;
            }}
            
            .section-title {{
                font-size: 1.8em;
                color: #667eea;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 3px solid #667eea;
            }}
            
            .charts {{
                background: #f8f9fa;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
            }}
            
            .chart-image {{
                width: 100%;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }}
            
            .summary {{
                background: #f8f9fa;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
            }}
            
            .summary-item {{
                display: flex;
                justify-content: space-between;
                padding: 15px 0;
                border-bottom: 1px solid #ddd;
            }}
            
            .summary-item:last-child {{
                border-bottom: none;
            }}
            
            .summary-label {{
                font-weight: 600;
                color: #555;
            }}
            
            .summary-value {{
                color: #667eea;
                font-weight: bold;
            }}
            
            .footer {{
                background: #2c3e50;
                color: white;
                padding: 30px;
                text-align: center;
            }}
            
            .status-badge {{
                display: inline-block;
                padding: 8px 20px;
                border-radius: 20px;
                font-weight: bold;
                font-size: 0.9em;
                margin-top: 10px;
            }}
            
            .status-excellent {{
                background: #27ae60;
                color: white;
            }}
            
            .status-good {{
                background: #3498db;
                color: white;
            }}
            
            .status-fair {{
                background: #f39c12;
                color: white;
            }}
            
            .status-poor {{
                background: #e74c3c;
                color: white;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>📊 Reporte de Rendimiento</h1>
                <p>E-commerce Microservices - Performance Testing</p>
                <p style="font-size: 0.9em; margin-top: 10px;">Generado: {timestamp}</p>
            </div>
            
            <div class="content">
                <div class="section">
                    <h2 class="section-title">🎯 Métricas Clave</h2>
                    
                    <div class="metrics-grid">
                        <div class="metric-card {success_class}">
                            <div class="metric-label">Tasa de Éxito</div>
                            <div class="metric-value">{success_rate}<span class="metric-unit">%</span></div>
                        </div>
                        
                        <div class="metric-card">
                            <div class="metric-label">Total Requests</div>
                            <div class="metric-value">{total_requests}</div>
                        </div>
                        
                        <div class="metric-card">
                            <div class="metric-label">Tiempo Promedio</div>
                            <div class="metric-value">{avg_response_time}<span class="metric-unit">ms</span></div>
                        </div>
                        
                        <div class="metric-card">
                            <div class="metric-label">Throughput Promedio</div>
                            <div class="metric-value">{avg_rps}<span class="metric-unit">RPS</span></div>
                        </div>
                        
                        <div class="metric-card">
                            <div class="metric-label">P95 Response Time</div>
                            <div class="metric-value">{p95_response_time}<span class="metric-unit">ms</span></div>
                        </div>
                        
                        <div class="metric-card">
                            <div class="metric-label">P99 Response Time</div>
                            <div class="metric-value">{p99_response_time}<span class="metric-unit">ms</span></div>
                        </div>
                    </div>
                </div>
                
                <div class="section">
                    <h2 class="section-title">📈 Resumen Detallado</h2>
                    <div class="summary">
                        <div class="summary-item">
                            <span class="summary-label">Total de Requests:</span>
                            <span class="summary-value">{total_requests}</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Requests Fallidas:</span>
                            <span class="summary-value">{total_failures}</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Tasa de Error:</span>
                            <span class="summary-value">{failure_rate}%</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Tiempo de Respuesta Mínimo:</span>
                            <span class="summary-value">{min_response_time} ms</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Tiempo de Respuesta Máximo:</span>
                            <span class="summary-value">{max_response_time} ms</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Tiempo de Respuesta Mediano:</span>
                            <span class="summary-value">{median_response_time} ms</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Throughput Máximo:</span>
                            <span class="summary-value">{max_rps} RPS</span>
                        </div>
                    </div>
                    
                    <div style="text-align: center;">
                        <span class="status-badge {status_class}">Estado General: {status_text}</span>
                    </div>
                </div>
                
                {charts_section}
            </div>
            
            <div class="footer">
                <p>🚀 Performance Testing Suite - E-commerce Microservices</p>
                <p style="margin-top: 10px; font-size: 0.9em;">
                    Generado automáticamente por el sistema de análisis de rendimiento
                </p>
            </div>
        </div>
    </body>
    </html>
    """

    # Determinar la clase de éxito
    success_rate = metrics.get("success_rate", 0)
    if success_rate >= 99:
        success_class = "success"
        status_class = "status-excellent"
        status_text = "EXCELENTE"
    elif success_rate >= 95:
        success_class = "success"
        status_class = "status-good"
        status_text = "BUENO"
    elif success_rate >= 90:
        success_class = "warning"
        status_class = "status-fair"
        status_text = "ACEPTABLE"
    else:
        success_class = "danger"
        status_class = "status-poor"
        status_text = "NECESITA MEJORAS"

    # Sección de gráficos
    charts_section = ""
    if charts:
        charts_section = """
        <div class="section">
            <h2 class="section-title">📊 Gráficos de Análisis</h2>
            <div class="charts">
        """
        for chart in charts:
            # Convertir ruta absoluta a relativa
            chart_name = Path(chart).name
            charts_section += f'<img src="{chart_name}" alt="Performance Chart" class="chart-image">\n'

        charts_section += """
            </div>
        </div>
        """

    # Rellenar plantilla
    html_content = html_template.format(
        timestamp=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        success_class=success_class,
        status_class=status_class,
        status_text=status_text,
        charts_section=charts_section,
        **metrics,
    )

    # Guardar archivo
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(html_content)

    print(f"✓ Reporte HTML generado: {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description="Analiza resultados de pruebas de Locust y genera reportes"
    )
    parser.add_argument(
        "csv_file",
        help="Archivo CSV con estadísticas de Locust (terminado en _stats.csv)",
    )
    parser.add_argument(
        "--output",
        "-o",
        default="performance_report.html",
        help="Nombre del archivo HTML de salida (default: performance_report.html)",
    )

    args = parser.parse_args()

    # Validar que el archivo existe
    csv_path = Path(args.csv_file)
    if not csv_path.exists():
        print(f"❌ Error: El archivo {args.csv_file} no existe")
        sys.exit(1)

    print(f"📊 Analizando resultados de: {args.csv_file}")
    print("=" * 80)

    # Cargar datos
    df = load_stats(args.csv_file)
    if df is None:
        sys.exit(1)

    # Calcular métricas
    print("📈 Calculando métricas...")
    metrics = calculate_metrics(df)

    # Mostrar resumen en consola
    print("\n" + "=" * 80)
    print("RESUMEN DE MÉTRICAS:")
    print("=" * 80)
    for key, value in metrics.items():
        print(f"  {key.replace('_', ' ').title()}: {value}")
    print("=" * 80)

    # Generar gráficos
    print("\n📊 Generando gráficos...")
    output_dir = Path(args.output).parent
    if not output_dir:
        output_dir = Path(".")
    charts = generate_charts(df, output_dir)

    # Generar reporte HTML
    print("\n📝 Generando reporte HTML...")
    generate_html_report(metrics, charts, args.output)

    print("\n" + "=" * 80)
    print("✅ ANÁLISIS COMPLETADO")
    print("=" * 80)
    print(f"\n🎉 Abre el reporte en tu navegador: {args.output}\n")


if __name__ == "__main__":
    main()
