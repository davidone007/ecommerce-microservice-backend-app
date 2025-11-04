#!/usr/bin/env python3
"""
Script para generar reportes HTML a partir de los resultados CSV de Locust.
Crea un reporte visual con gráficos y tablas.

Uso: python generate_report.py [archivo_csv]
"""

import sys
import csv
import os
from datetime import datetime
from pathlib import Path


def read_csv_file(filepath):
    """Lee un archivo CSV y retorna los datos."""
    data = []
    if not os.path.exists(filepath):
        print(f"Error: Archivo no encontrado: {filepath}")
        return None

    with open(filepath, "r") as f:
        reader = csv.DictReader(f)
        data = list(reader)
    return data


def calculate_stats(data):
    """Calcula estadísticas generales."""
    if not data:
        return {}

    total_requests = sum(int(row.get("requests", 0)) for row in data)
    total_failures = sum(int(row.get("failures", 0)) for row in data)
    failure_rate = (total_failures / total_requests * 100) if total_requests > 0 else 0

    avg_response_time = (
        sum(float(row.get("Average", 0)) for row in data) / len(data) if data else 0
    )

    return {
        "total_requests": total_requests,
        "total_failures": total_failures,
        "failure_rate": failure_rate,
        "avg_response_time": avg_response_time,
        "endpoints": len(data),
    }


def create_html_report(csv_file, output_file=None):
    """Crea un reporte HTML a partir de datos CSV."""

    if output_file is None:
        basename = Path(csv_file).stem
        output_file = f"{basename}_report.html"

    # Leer datos
    data = read_csv_file(csv_file)
    if data is None:
        return

    stats = calculate_stats(data)

    # Generar HTML
    html_content = f"""
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reporte de Rendimiento - E-Commerce Microservicios</title>
        <style>
            * {{
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }}
            
            body {{
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #333;
                padding: 20px;
            }}
            
            .container {{
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
                padding: 40px;
            }}
            
            header {{
                text-align: center;
                margin-bottom: 40px;
                border-bottom: 3px solid #667eea;
                padding-bottom: 20px;
            }}
            
            h1 {{
                font-size: 2.5em;
                color: #667eea;
                margin-bottom: 10px;
            }}
            
            .timestamp {{
                color: #666;
                font-size: 0.9em;
            }}
            
            .stats-grid {{
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 40px;
            }}
            
            .stat-card {{
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 8px;
                text-align: center;
            }}
            
            .stat-value {{
                font-size: 2em;
                font-weight: bold;
                margin: 10px 0;
            }}
            
            .stat-label {{
                font-size: 0.9em;
                opacity: 0.9;
            }}
            
            table {{
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
            }}
            
            table thead {{
                background: #f5f5f5;
            }}
            
            table th {{
                padding: 12px;
                text-align: left;
                font-weight: 600;
                color: #667eea;
                border-bottom: 2px solid #667eea;
            }}
            
            table td {{
                padding: 12px;
                border-bottom: 1px solid #eee;
            }}
            
            table tr:hover {{
                background: #f9f9f9;
            }}
            
            .status-ok {{
                color: #28a745;
                font-weight: bold;
            }}
            
            .status-warning {{
                color: #ffc107;
                font-weight: bold;
            }}
            
            .status-error {{
                color: #dc3545;
                font-weight: bold;
            }}
            
            .footer {{
                text-align: center;
                margin-top: 40px;
                color: #999;
                font-size: 0.9em;
            }}
            
            .charts-section {{
                margin-top: 40px;
                padding-top: 40px;
                border-top: 2px solid #eee;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <header>
                <h1>📊 Reporte de Rendimiento</h1>
                <p>E-Commerce Microservicios - Pruebas de Carga y Estrés</p>
                <p class="timestamp">Generado: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
            </header>
            
            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Solicitudes Totales</div>
                    <div class="stat-value">{stats['total_requests']}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Fallos</div>
                    <div class="stat-value">{stats['total_failures']}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Tasa de Fallos</div>
                    <div class="stat-value">{stats['failure_rate']:.2f}%</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Tiempo Promedio (ms)</div>
                    <div class="stat-value">{stats['avg_response_time']:.0f}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Endpoints Probados</div>
                    <div class="stat-value">{stats['endpoints']}</div>
                </div>
            </section>
            
            <section>
                <h2 style="color: #667eea; margin: 30px 0 20px 0;">📋 Resultados por Endpoint</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Endpoint</th>
                            <th>Solicitudes</th>
                            <th>Fallos</th>
                            <th>Tasa Fallos</th>
                            <th>Respuesta Min (ms)</th>
                            <th>Respuesta Prom (ms)</th>
                            <th>Respuesta Max (ms)</th>
                            <th>P95 (ms)</th>
                            <th>P99 (ms)</th>
                        </tr>
                    </thead>
                    <tbody>
"""

    # Agregar filas de datos
    for row in data:
        failure_rate = float(row.get("Failure rate", 0))
        status_class = (
            "status-ok"
            if failure_rate == 0
            else "status-error" if failure_rate > 5 else "status-warning"
        )

        html_content += f"""
                        <tr>
                            <td><strong>{row.get('Name', 'N/A')}</strong></td>
                            <td>{row.get('requests', 0)}</td>
                            <td>{row.get('failures', 0)}</td>
                            <td><span class="{status_class}">{failure_rate:.2f}%</span></td>
                            <td>{row.get('Min', 0)}</td>
                            <td>{row.get('Average', 0)}</td>
                            <td>{row.get('Max', 0)}</td>
                            <td>{row.get('[95', 0)}</td>
                            <td>{row.get('[99', 0)}</td>
                        </tr>
"""

    html_content += """
                    </tbody>
                </table>
            </section>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el script de pruebas de rendimiento</p>
                <p>Para más información, consulta la documentación de Locust: https://docs.locust.io/</p>
            </div>
        </div>
    </body>
    </html>
    """

    # Escribir archivo HTML
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(html_content)

    print(f"✅ Reporte generado: {output_file}")
    print(f"\n📊 Resumen:")
    print(f"   Total de solicitudes: {stats['total_requests']}")
    print(f"   Total de fallos: {stats['total_failures']}")
    print(f"   Tasa de fallos: {stats['failure_rate']:.2f}%")
    print(f"   Tiempo de respuesta promedio: {stats['avg_response_time']:.0f} ms")
    print(f"   Endpoints probados: {stats['endpoints']}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python generate_report.py archivo_stats.csv [archivo_salida.html]")
        print("\nBuscar archivos CSV recientes:")
        results_dir = "performance-results"
        if os.path.exists(results_dir):
            files = sorted(
                Path(results_dir).glob("*_stats.csv"),
                key=os.path.getmtime,
                reverse=True,
            )[:5]
            if files:
                print("\nArchivos disponibles:")
                for f in files:
                    print(f"  - {f}")
        sys.exit(1)

    csv_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    create_html_report(csv_file, output_file)
